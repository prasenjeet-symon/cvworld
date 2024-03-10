import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/datasource/http/http.manager.admin.dart';
import 'package:cvworld/dashboard/datasource/network.api.admin.dart';

class DashboardSigninController {
  ///
  ///
  /// Sing in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    String timeZone = await getCurrentTimeZone();
    await singleCall(NetworkApiAdmin().signInAsAdmin(email, password, timeZone));
  }
}
