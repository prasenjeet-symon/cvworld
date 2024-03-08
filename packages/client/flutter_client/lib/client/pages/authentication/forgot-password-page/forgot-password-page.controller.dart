import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';

class ForgotPasswordController {
  ///
  ///
  /// Send reset password email
  Future<ApiResponse> sendResetPasswordEmail(String email) {
    return NetworkApi().forgotPassword(email).first;
  }
}
