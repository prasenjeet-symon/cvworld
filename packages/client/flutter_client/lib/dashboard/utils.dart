// Admin Guard
import 'package:auto_route/auto_route.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthAdminGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var isAuthenticated = await const FlutterSecureStorage().read(key: 'JWT_ADMIN');
    if (isAuthenticated == null) {
      router.navigateNamed('/admin/signin');
      return;
    } else {
      resolver.next(true);
    }
  }
}
