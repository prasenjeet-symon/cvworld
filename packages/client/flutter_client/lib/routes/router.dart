import 'package:auto_route/auto_route.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/utils.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: HomeRoute.page, initial: true, guards: [PathGuard()]),
        AutoRoute(path: '/intro-slider', page: IntroSliderPage.page),
        AutoRoute(path: '/contact-us', page: ContactUsPage.page),
        AutoRoute(path: '/signup', page: SignUpRoute.page, guards: [RouteGuard()]),
        AutoRoute(path: '/signin', page: SignInRoute.page, guards: [RouteGuard()]),
        AutoRoute(path: '/dashboard/account-setting', maintainState: false, page: AccountSettingPage.page, guards: [AuthGuard()]),
        AutoRoute(path: '/dashboard', page: Dashboard.page, maintainState: false, guards: [AuthGuard()]),
        AutoRoute(path: '/dashboard/view-resume/:resumeID', page: ViewResume.page, maintainState: true, guards: [AuthGuard()]),
        AutoRoute(path: '/cv-maker/:resumeID/:templateName', page: CvMakerRoute.page, maintainState: false, guards: [AuthGuard()]),
        AutoRoute(path: '/choose-template', page: MarketPlacePage.page, maintainState: false, guards: [AuthGuard()]),

        // For the dashboard , prepend /dashboard/
        // sign
        AutoRoute(path: '/admin/signin', page: SignInDashboardPage.page, maintainState: false),
        // Dashboard
        AutoRoute(path: '/admin/dashboard', page: AdminHomePage.page, maintainState: false, guards: [AuthAdminGuard()]),
        // change password
        AutoRoute(path: '/admin/changePassword', page: AdminChangePasswordPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        // subscription Setting
        AutoRoute(path: '/admin/subscriptionSetting', page: AdminSubscriptionSettingPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        // all users
        AutoRoute(path: '/admin/allUsers', page: AdminAllUsersPage.page, maintainState: false, guards: [AuthAdminGuard()]),
      ];
}
