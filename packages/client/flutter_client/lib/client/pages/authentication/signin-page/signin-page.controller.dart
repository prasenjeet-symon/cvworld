import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninPageController {
  ///
  ///
  /// Signin with email and password
  void signinWithEmailAndPassword(String email, String password) {
    try {
      singleCall(NetworkApi().signin(email, password));
    } catch (e) {
      if (kDebugMode) {
        print("signinWithEmailAndPassword :: Error while signing in");
        print(e);
      }
    }
  }

  ///
  ///
  /// Signin with google
  signinWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = kIsWeb ? GoogleSignIn(clientId: ApplicationConfiguration.googleWebClientId) : GoogleSignIn(serverClientId: ApplicationConfiguration.googleAndroidClientId);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        var accessToken = googleAuth.accessToken ?? '';
        singleCall(NetworkApi().googleSignIn(accessToken));
      } else {
        if (kDebugMode) {
          print("signinWithGoogle :: Error while signing in with google");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("signinWithGoogle :: Error while signing in with google");
        print(e);
      }
    }
  }
}
