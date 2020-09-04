import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_avanzadas/pages/login/login_page.dart';
import 'package:flutter_ui_avanzadas/utils/dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  Auth._internal();
  static Auth get instance => Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User get user {
    return _firebaseAuth.currentUser;
  }

  Future<User> loginByPassword(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      progressDialog.dismiss();

      if (userCredential.user != null) {
        return userCredential.user;
      }
      return null;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      String message = "Unknown error";
      if (e is FirebaseAuthException) {
        if (e.code == "user-not-found") {
          message = "Invalid email. User not found";
        } else {
          message = e.message;
        }
      }

      Dialogs.alert(context, title: "ERROR", description: message);

      return null;
    }
  }

  Future<User> facebook(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();

      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == 200) {
        // final userData = await FaebookAuth.instance.getUserData();
        // print(userData);

        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken.token,
        );

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User user = userCredential.user;
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

  Future<User> google(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User user = userCredential.user;

      print("username: ${user.displayName} ");
      progressDialog.dismiss();
      return user;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return null;
    }
  }

  Future<User> signUp(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();

      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        userCredential.user.updateProfile(displayName: username);
        progressDialog.dismiss();
        return userCredential.user;
      }

      progressDialog.dismiss();
      return null;
    } catch (e) {
      progressDialog.dismiss();
      print(e);
      print(e.runtimeType);
      String message = "Unknown error";
      if (e is FirebaseAuthException) {
        print(e.code);
        if (e.code == "email-already-in-use") {
          message = e.message;
        } else if (e.code == "weak-password") {
          message = e.message;
        }
      }
      Dialogs.alert(context, title: "ERROR", description: message);
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
      String message = "Unknown error";
      progressDialog.dismiss();
      if (e is FirebaseAuthException) {
        message = e.message;
      }
      Dialogs.alert(context, title: "ERROR", description: message);
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    final List<UserInfo> providers = (await user).providerData;
    String providerId = "firebase";
    for (final p in providers) {
      if (p.providerId != 'firebase') {
        providerId = p.providerId;
        break;
      }
    }

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
