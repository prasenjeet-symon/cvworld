import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

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
  void signUpWithEmailAndPassword(String fullName, String userName, String email, String password) {
    try {
      singleCall(NetworkApi().signup(email, password, fullName, userName, 'IST'));
    } catch (e) {
      if (kDebugMode) {
        print("signUpWithEmailAndPassword :: Error while signing up");
        print(e);
      }
    }
  }
}
