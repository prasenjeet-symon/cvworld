import 'package:auto_route/auto_route.dart';
import 'package:flutter_client/client/utils.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: HomeRoute.page, initial: true),
        AutoRoute(path: '/contact-us', page: ContactUsPage.page),
        AutoRoute(path: '/signup', page: SignUpRoute.page, guards: [RouteGuard()]),
        AutoRoute(path: '/signin', page: SignInRoute.page, guards: [RouteGuard()]),
        AutoRoute(path: '/dashboard/account-setting', maintainState: false, page: AccountSettingPage.page, guards: [AuthGuard()]),
        AutoRoute(path: '/dashboard', page: Dashboard.page, maintainState: false, guards: [AuthGuard()]),
        AutoRoute(path: '/dashboard/view-resume/:resumeID', page: ViewResume.page, maintainState: false, guards: [AuthGuard()]),
        AutoRoute(path: '/cv-maker/:resumeID', page: CvMakerRoute.page, maintainState: false, guards: [AuthGuard()]),
      ];
}
