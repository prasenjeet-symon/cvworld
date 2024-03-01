import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:flutter/foundation.dart';

class ResetPasswordPageController {
  ///
  ///
  /// Reset password
  resetPassword(String userId, String password, String token) async {
    try {
      await singleCall(NetworkApi().resetPassword(userId, password, token));
    } catch (e) {
      if (kDebugMode) {
        print("resetPassword :: Error while resetting password");
        print(e);
      }
    }
  }
}
