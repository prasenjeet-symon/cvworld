import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:flutter/foundation.dart';

class ForgotPasswordController {
  ///
  ///
  /// Send reset password email
  sendResetPasswordEmail(String email) async {
    try {
      await singleCall(NetworkApi().forgotPassword(email));
    } catch (e) {
      if (kDebugMode) {
        print("sendResetPasswordEmail :: Error while sending reset password email");
        print(e);
      }
    }
  }
}
