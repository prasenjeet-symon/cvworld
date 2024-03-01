import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/pages/about-us-page/about-us-page.dart';
import 'package:cvworld/client/pages/authentication/reset-password-page/reset-password-page.dart';
import 'package:cvworld/client/pages/authentication/signup-page/signup-page.dart';
import 'package:cvworld/client/pages/contact-us-page/contact-us-page.dart';
import 'package:cvworld/client/pages/dashboard/account-page/account-page.dart';
import 'package:cvworld/client/pages/dashboard/account-setting/account-setting.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart';
import 'package:cvworld/client/pages/dashboard/templates-page/templates-page.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.dart';
import 'package:cvworld/client/pages/dashboard/view-resume/view-resume.dart';
import 'package:cvworld/client/pages/home-page/home-page.dart';
import 'package:cvworld/client/pages/intro-slides/intro-slides.dart';
import 'package:cvworld/client/pages/make-cv-pages/cv-maker-page.dart';
import 'package:cvworld/client/pages/signin-page/signin-page.dart';
import 'package:cvworld/client/pages/signup-page/signup-page.dart';
import 'package:cvworld/dashboard/dashboard/change_password/change_password.dart';
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_full_page.dart';
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_page.dart';
import 'package:cvworld/dashboard/dashboard/feedback_page/feedback_page.admin.dart';
import 'package:cvworld/dashboard/dashboard/home_page/home_page.dart';
import 'package:cvworld/dashboard/dashboard/subscription_setting/subscription_setting.dart';
import 'package:cvworld/dashboard/dashboard/templates/all_templates_page.dart';
import 'package:cvworld/dashboard/dashboard/templates/update_template.dart';
import 'package:cvworld/dashboard/dashboard/users/all_users_page.dart';
import 'package:cvworld/dashboard/dashboard/users/user_profile_page.dart';
import 'package:cvworld/dashboard/sign_in_page/sign_in_page.dart';
import 'package:go_router/go_router.dart';

import '../client/pages/authentication/forgot-password-page/forgot-password-page.dart';
import '../client/pages/authentication/signin-page/signin-page.dart';
import '../client/utils.dart';
import '../dashboard/utils.dart';

class RouteNames {
  static const String home = '/';
  static const String introSlider = '/intro-slider';
  static const String contactUs = '/contact-us';
  static const String dashboardContactUs = '/dashboard/contact-us';
  static const String aboutUs = '/about-us';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String dashboardAccountSetting = '/dashboard/account-setting';
  static const String dashboard = '/dashboard';
  static const String dashboardViewResume = '/dashboard/view-resume';
  static const String cvMaker = '/cv-maker';
  static const String chooseTemplate = '/choose-template';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String dashboardAccount = '/dashboard/account';
  static const String dashboardTransactions = '/dashboard/transactions';
  static const String dashboardTemplates = '/dashboard/templates';

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
  static const String adminFeedbackPage = '/admin/feedback-page';
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  redirect: (context, state) async {
    if (state.fullPath?.startsWith('/admin') ?? false) {
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
      // Client routes
      bool isClientAuthenticated = ApplicationToken.getInstance().getToken != null ? true : false;
      bool isTutorialCompleted = TutorialStatus().isTutorialCompletedValue;
      PlatformType platform = detectPlatformType();

      if (platform == PlatformType.mobile) {
        if (state.fullPath!.startsWith('/signin') || state.fullPath!.startsWith('/signup') || state.fullPath == '/' || state.fullPath!.startsWith('/about-us') || state.fullPath!.startsWith('/intro-slider')) {
          // Under public route
          // Check if authenticated
          if (isClientAuthenticated) {
            // Public route cannot be accessed because the user is authenticated
            return '/dashboard';
          } else if (!isTutorialCompleted) {
            // Tutorial not completed
            // nav to intro
            return '/intro-slider';
          } else if (state.fullPath == '/' || state.fullPath!.startsWith('/about-us')) {
            // nav to signin
            return '/signin';
          } else {
            // Let them go to public route
            return null;
          }
        } else if (!isClientAuthenticated) {
          // Not authenticated
          // dashboard routes
          return '/signin';
        } else {
          // authenticated and dashboard routes
          return null;
        }
      } else {
        // On the web
        if (state.fullPath!.startsWith('/signin') ||
            state.fullPath!.startsWith('/forgot-password') ||
            state.fullPath!.startsWith('/reset-password') ||
            state.fullPath!.startsWith('/signup') ||
            state.fullPath == '/' ||
            state.fullPath!.startsWith('/contact-us') ||
            state.fullPath!.startsWith('/about-us') ||
            state.fullPath!.startsWith('/intro-slider')) {
          // Under public route
          if (isClientAuthenticated) {
            // Public route cannot be accessed because the user is authenticated
            return '/dashboard';
          } else {
            // Let them go to public route
            return null;
          }
        } else {
          // Dashboard routes
          if (isClientAuthenticated) {
            // If authenticated then let them go to dashboard
            return null;
          } else {
            // Not authenticated
            // Redirect to signin
            return '/signin';
          }
        }
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
      builder: (context, state) => const SignUpPage(),
      name: RouteNames.signup,
    ),

    // Signin
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SigninPage(),
      name: RouteNames.signin,
    ),

    // Forgot Password
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
      name: RouteNames.forgotPassword,
    ),

    // Reset Password
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        final userId = queryParams['userId'];
        final token = queryParams['token'];
        return ResetPasswordPage(token: token ?? '', userId: userId ?? '');
      },
      name: RouteNames.resetPassword,
    ),

    // dashboard/account-setting
    GoRoute(
      path: '/dashboard/account-setting',
      builder: (context, state) => const AccountSettingPage(),
      name: RouteNames.dashboardAccountSetting,
    ),

    // Dashboard account page
    GoRoute(
      path: '/dashboard/account',
      builder: (context, state) => const AccountPage(),
      name: RouteNames.dashboardAccount,
    ),

    // Dashboard transactions page
    GoRoute(
      path: '/dashboard/transactions',
      builder: (context, state) => const TransactionPage(),
      name: RouteNames.dashboardTransactions,
    ),

    // Dashboard templates page
    GoRoute(
      path: '/dashboard/templates',
      builder: (context, state) => const TemplatesPage(),
      name: RouteNames.dashboardTemplates,
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

    // Dashboard contact us
    GoRoute(
      path: '/dashboard/contact-us',
      builder: (context, state) => const ContactUsPage(),
      name: RouteNames.dashboardContactUs,
    ),

    ///
    ///
    ///
    ///
    /// For the admin panel
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
    ),

    // Feedback page
    GoRoute(
      path: '/admin/feedback',
      builder: (context, state) => const FeedbackPageAdmin(),
      name: RouteNames.adminFeedbackPage,
    )
  ],
);
