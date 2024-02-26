import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:flutter/foundation.dart';

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
}
