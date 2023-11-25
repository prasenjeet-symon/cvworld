import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/about-us-page/about-us-page.dart';
import 'package:cvworld/client/pages/contact-us-page/contact-us-page.dart';
import 'package:cvworld/client/pages/dashboard/account-setting/account-setting.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart';
import 'package:cvworld/client/pages/dashboard/view-resume/view-resume.dart';
import 'package:cvworld/client/pages/home-page/home-page.dart';
import 'package:cvworld/client/pages/intro-slides/intro-slides.dart';
import 'package:cvworld/client/pages/make-cv-pages/cv-maker-page.dart';
import 'package:cvworld/client/pages/signin-page/signin-page.dart';
import 'package:cvworld/client/pages/signup-page/signup-page.dart';
import 'package:cvworld/dashboard/dashboard/change_password/change_password.dart';
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_full_page.dart';
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_page.dart';
import 'package:cvworld/dashboard/dashboard/home_page/home_page.dart';
import 'package:cvworld/dashboard/dashboard/subscription_setting/subscription_setting.dart';
import 'package:cvworld/dashboard/dashboard/templates/all_templates_page.dart';
import 'package:cvworld/dashboard/dashboard/templates/update_template.dart';
import 'package:cvworld/dashboard/dashboard/users/all_users_page.dart';
import 'package:cvworld/dashboard/dashboard/users/user_profile_page.dart';
import 'package:cvworld/dashboard/sign_in_page/sign_in_page.dart';
import 'package:go_router/go_router.dart';

import '../dashboard/utils.dart';

class RouteNames {
  static const String home = '/';
  static const String introSlider = '/intro-slider';
  static const String contactUs = '/contact-us';
  static const String aboutUs = '/about-us';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String dashboardAccountSetting = '/dashboard/account-setting';
  static const String dashboard = '/dashboard';
  static const String dashboardViewResume = '/dashboard/view-resume';
  static const String cvMaker = '/cv-maker';
  static const String chooseTemplate = '/choose-template';

  /// ADMIN
  /// Admin related routes
  static const String adminSignin = '/admin/signin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminChangePassword = '/admin/changePassword';
  static const String adminSubscriptionSetting = '/admin/subscriptionSetting';
  static const String adminAllUsers = '/admin/allUsers';
  static const String adminUserProfile = '/admin/userProfile/:userId';
  static const String adminAllTemplates = '/admin/allTemplates';
  static const String adminUpdateTemplate = '/admin/updateTemplate/:templateId';
  static const String adminContactUs = '/admin/contactUs';
  static const String adminContactUsMessage = '/admin/contactUs/:messageId';
}

final goRouter = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      if (state.fullPath!.startsWith('/admin')) {
        bool isAuthenticated = await isAdminAuthenticated();

        // check if login route
        if (state.fullPath!.startsWith('/admin/signin')) {
          if (isAuthenticated) {
            return '/admin/dashboard';
          } else {
            return null;
          }
        }

        if (!isAuthenticated) {
          return '/admin/signin';
        } else {
          return null;
        }
      } else {
        bool isClientAuthenticated = await DatabaseService().isAuthenticated();

        if (state.fullPath!.startsWith('/signin') || state.fullPath!.startsWith('/signup') || state.fullPath == '/' || state.fullPath!.startsWith('/contact-us') || state.fullPath!.startsWith('/about-us')) {
          if (isClientAuthenticated) {
            return '/dashboard';
          } else {
            return null;
          }
        }

        if (!isClientAuthenticated) {
          return '/signin';
        } else {
          return null;
        }
      }
    },
    routes: [
      // Home route
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        name: RouteNames.home,
      ),

      // Intro Slider
      GoRoute(
        path: '/intro-slider',
        builder: (context, state) => const IntroSliderPage(),
        name: RouteNames.introSlider,
      ),

      // Contact Us
      GoRoute(
        path: '/contact-us',
        builder: (context, state) => const ContactUsPage(),
        name: RouteNames.contactUs,
      ),

      // About US
      GoRoute(
        path: '/about-us',
        builder: (context, state) => const AboutUsPage(),
        name: RouteNames.aboutUs,
      ),

      // Signup
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
        name: RouteNames.signup,
      ),

      // Signin
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
        name: RouteNames.signin,
      ),

      // dashboard/account-setting
      GoRoute(
        path: '/dashboard/account-setting',
        builder: (context, state) => const AccountSettingPage(),
        name: RouteNames.dashboardAccountSetting,
      ),

      // dashboard
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
        name: RouteNames.dashboard,
      ),

      // dashboard/view-resume/:resumeID
      GoRoute(
        path: '/dashboard/view-resume/:resumeID',
        builder: (context, state) => ViewResume(resumeID: int.parse(state.pathParameters['resumeID']!)),
        name: RouteNames.dashboardViewResume,
      ),

      // cv-maker/:resumeID/:templateName
      GoRoute(
        path: '/cv-maker/:resumeID/:templateName',
        builder: (context, state) => CvMakerScreen(resumeID: int.parse(state.pathParameters['resumeID']!), templateName: state.pathParameters['templateName']!),
        name: RouteNames.cvMaker,
      ),

      // choose-template
      GoRoute(
        path: '/choose-template',
        builder: (context, state) => const MarketPlacePage(),
        name: RouteNames.chooseTemplate,
      ),

      // admin/signin
      GoRoute(
        path: '/admin/signin',
        builder: (context, state) => const SignInDashboardPage(),
        name: RouteNames.adminSignin,
      ),

      // admin/dashboard
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminHomePage(),
        name: RouteNames.adminDashboard,
      ),

      // admin/changePassword
      GoRoute(
        path: '/admin/changePassword',
        builder: (context, state) => const AdminChangePasswordPage(),
        name: RouteNames.adminChangePassword,
      ),

      // admin/subscriptionSetting
      GoRoute(
        path: '/admin/subscriptionSetting',
        builder: (context, state) => const AdminSubscriptionSettingPage(),
        name: RouteNames.adminSubscriptionSetting,
      ),

      // admin/allUsers
      GoRoute(
        path: '/admin/allUsers',
        builder: (context, state) => const AdminAllUsersPage(),
        name: RouteNames.adminAllUsers,
      ),

      // admin/userProfile/:userId
      GoRoute(
        path: '/admin/userProfile/:userId',
        builder: (context, state) => UserProfilePage(userId: state.pathParameters['userId']!),
        name: RouteNames.adminUserProfile,
      ),

      // admin/allTemplates
      GoRoute(
        path: '/admin/allTemplates',
        builder: (context, state) => const AllTemplatesPage(),
        name: RouteNames.adminAllTemplates,
      ),

      // admin/updateTemplate/:templateId
      GoRoute(
        path: '/admin/updateTemplate/:templateId',
        builder: (context, state) => AdminUpdateTemplatePage(templateId: state.pathParameters['templateId']!),
        name: RouteNames.adminUpdateTemplate,
      ),

      // admin/contactUs
      GoRoute(
        path: '/admin/contactUs',
        builder: (context, state) => const AdminContactUsPage(),
        name: RouteNames.adminContactUs,
      ),

      // admin/contactUs/:messageId
      GoRoute(
        path: '/admin/contactUs/:messageId',
        builder: (context, state) => AdminContactUsFullPage(messageId: state.pathParameters['messageId']!),
        name: RouteNames.adminContactUsMessage,
      )
    ]);
