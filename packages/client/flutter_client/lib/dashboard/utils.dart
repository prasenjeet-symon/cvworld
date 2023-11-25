import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> isAdminAuthenticated() async {
  var isAuthenticated = await const FlutterSecureStorage().read(key: 'JWT_ADMIN');
  if (isAuthenticated == null) {
    return false;
  } else {
    return true;
  }
}
