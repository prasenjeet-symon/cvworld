import 'package:auto_route/auto_route.dart';
import 'package:flutter_client/client/utils.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: HomeRoute.page, initial: true),
        AutoRoute(path: '/signup', page: SignUpRoute.page),
        AutoRoute(path: '/signin', page: SignInRoute.page),
        AutoRoute(
            path: '/dashboard', page: Dashboard.page, guards: [AuthGuard()]),
        AutoRoute(
            path: '/dashboard/view-resume/:resumeID',
            page: ViewResume.page,
            guards: [AuthGuard()]),
        AutoRoute(
            path: '/cv-maker', page: CvMakerRoute.page, guards: [AuthGuard()]),
      ];
}
