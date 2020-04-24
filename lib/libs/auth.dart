import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_avanzadas/pages/login/login_page.dart';
import 'package:flutter_ui_avanzadas/utils/dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  Auth._internal();
  static Auth get instance => Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> get user async {
    return (await _firebaseAuth.currentUser());
  }

  Future<FirebaseUser> facebook(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();

      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == 200) {
        print("facebook login ok");
        // final userData = await FaebookAuth.instance.getUserData();
        // print(userData);

        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);

        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        print("facebook username: ${user.displayName} ");
        progressDialog.dismiss();
        return user;
      } else if (result.status == 403) {
        print("facebook login cancelled");
      } else {
        print("facebook login failed");
      }
      progressDialog.dismiss();
      return null;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return null;
    }
  }

  Future<FirebaseUser> google(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);

      final AuthResult result =
          await _firebaseAuth.signInWithCredential(credential);

      final FirebaseUser user = result.user;

      print("username: ${user.displayName} ");
      progressDialog.dismiss();
      return user;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return null;
    }
  }

  Future<FirebaseUser> signUp(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();

      final AuthResult result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = username;
        await result.user.updateProfile(userUpdateInfo);
        progressDialog.dismiss();
        return result.user;
      }

      progressDialog.dismiss();
      return null;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return null;
    }
  }

  Future<bool> sendResetEmailLink(BuildContext context,
      {@required String email}) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      progressDialog.dismiss();
      return true;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    final String providerId = (await user).providerData[0].providerId;
    print("providerId $providerId");
    switch (providerId) {
      case "facebook.com":
        await FacebookAuth.instance.logOut();
        break;
      case "google.com":
        await _googleSignIn.signOut();
        break;
      case "password":
        break;
      case "phone":
        break;
    }
    await _firebaseAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (_) => false);
  }
}
