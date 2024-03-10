import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPageController {
  ///
  ///
  ///
  /// Is username taken
  Future<bool> isUsernameTaken(String? username) async {
    try {
      if (username == null) {
        return false;
      }

      ApiResponse response = await singleCall(NetworkApi().isUsernameTaken(username));
      if (response.statusCode != 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("isUsernameTaken :: Error while checking if username is taken");
        print(e);
      }

      return true;
    }
  }

  ///
  ///
  /// Signup with email and password
  void signUpWithEmailAndPassword(String fullName, String userName, String email, String password) async {
    try {
      singleCall(NetworkApi().signup(email, password, fullName, userName, await getCurrentTimeZone()));
    } catch (e) {
      if (kDebugMode) {
        print("signUpWithEmailAndPassword :: Error while signing up");
        print(e);
      }
    }
  }

  ///
  ///
  /// Signup with google
  signupWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = kIsWeb ? GoogleSignIn(clientId: ApplicationConfiguration.googleWebClientId) : GoogleSignIn(serverClientId: ApplicationConfiguration.googleAndroidClientId);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        var accessToken = googleAuth.accessToken ?? '';
        singleCall(NetworkApi().googleSignUp(accessToken, await getCurrentTimeZone()));
      } else {
        if (kDebugMode) {
          print("signupWithGoogle :: Error while signing up with google");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("signupWithGoogle :: Error while signing up with google");
        print(e);
      }
    }
  }
}
