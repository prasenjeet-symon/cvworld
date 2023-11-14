import 'package:auto_route/auto_route.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/utils.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        ///
        ///
        ///
        ///
        ///Client Routes
        AutoRoute(path: '/', page: HomeRoute.page, initial: true, guards: [PathGuard()]),
        AutoRoute(path: '/intro-slider', page: IntroSliderPage.page),
        AutoRoute(path: '/contact-us', page: ContactUsPage.page),
        AutoRoute(path: '/about-us', page: AboutUsPage.page),
        AutoRoute(path: '/signup', page: SignUpRoute.page, guards: [RouteGuard()]),
        AutoRoute(path: '/signin', page: SignInRoute.page, guards: [RouteGuard()]),
        AutoRoute(path: '/dashboard/account-setting', maintainState: false, page: AccountSettingPage.page, guards: [AuthGuard()]),
        AutoRoute(path: '/dashboard', page: Dashboard.page, maintainState: false, guards: [AuthGuard()]),
        AutoRoute(path: '/dashboard/view-resume/:resumeID', page: ViewResume.page, maintainState: true, guards: [AuthGuard()]),
        AutoRoute(path: '/cv-maker/:resumeID/:templateName', page: CvMakerRoute.page, maintainState: false, guards: [AuthGuard()]),
        AutoRoute(path: '/choose-template', page: MarketPlacePage.page, maintainState: false, guards: [AuthGuard()]),

        ///
        ///
        ///
        ///
        /// Admin Routes
        AutoRoute(path: '/admin/signin', page: SignInDashboardPage.page, maintainState: false),
        AutoRoute(path: '/admin/dashboard', page: AdminHomePage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/changePassword', page: AdminChangePasswordPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/subscriptionSetting', page: AdminSubscriptionSettingPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/allUsers', page: AdminAllUsersPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/userProfile/:userId', page: UserProfilePage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/allTemplates', page: AllTemplatesPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/updateTemplate/:templateId', page: AdminUpdateTemplatePage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/contactUs', page: AdminContactUsPage.page, maintainState: false, guards: [AuthAdminGuard()]),
        AutoRoute(path: '/admin/contactUs/:messageId', page: AdminContactUsFullPage.page, maintainState: false, guards: [AuthAdminGuard()]),
      ];
}
