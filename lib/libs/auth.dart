import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Auth {
  Auth._internal();
  static Auth get instance => Auth._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> facebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == 200) {
        print("facebook login ok");
        // final userData = await FacebookAuth.instance.getUserData();
        // print(userData);

        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);

        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        print("facebook username: ${user.displayName} ");
      } else if (result.status == 403) {
        print("facebook login cancelled");
      } else {
        print("facebook login failed");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> google() async {
    try {
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> logOut() async {
    
  }
}
