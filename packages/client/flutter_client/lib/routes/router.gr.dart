// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:cvworld/client/pages/about-us-page/about-us-page.dart' as _i1;
import 'package:cvworld/client/pages/contact-us-page/contact-us-page.dart'
    as _i2;
import 'package:cvworld/client/pages/dashboard/account-setting/account-setting.dart'
    as _i3;
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard.dart' as _i4;
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart'
    as _i5;
import 'package:cvworld/client/pages/dashboard/view-resume/view-resume.dart'
    as _i6;
import 'package:cvworld/client/pages/home-page/home-page.dart' as _i7;
import 'package:cvworld/client/pages/intro-slides/intro-slides.dart' as _i8;
import 'package:cvworld/client/pages/make-cv-pages/cv-maker-page.dart' as _i9;
import 'package:cvworld/client/pages/signin-page/signin-page.dart' as _i10;
import 'package:cvworld/client/pages/signup-page/signup-page.dart' as _i11;
import 'package:cvworld/dashboard/dashboard/change_password/change_password.dart'
    as _i12;
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_full_page.dart'
    as _i13;
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_page.dart'
    as _i14;
import 'package:cvworld/dashboard/dashboard/home_page/home_page.dart' as _i15;
import 'package:cvworld/dashboard/dashboard/subscription_setting/subscription_setting.dart'
    as _i16;
import 'package:cvworld/dashboard/dashboard/templates/all_templates_page.dart'
    as _i17;
import 'package:cvworld/dashboard/dashboard/templates/update_template.dart'
    as _i18;
import 'package:cvworld/dashboard/dashboard/users/all_users_page.dart' as _i19;
import 'package:cvworld/dashboard/dashboard/users/user_profile_page.dart'
    as _i20;
import 'package:cvworld/dashboard/sign_in_page/sign_in_page.dart' as _i21;
import 'package:flutter/foundation.dart' as _i23;
import 'package:flutter/material.dart' as _i24;

abstract class $AppRouter extends _i22.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i22.PageFactory> pagesMap = {
    AboutUsPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AboutUsPage(),
      );
    },
    ContactUsPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ContactUsPage(),
      );
    },
    AccountSettingPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AccountSettingPage(),
      );
    },
    Dashboard.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.Dashboard(),
      );
    },
    MarketPlacePage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.MarketPlacePage(),
      );
    },
    ViewResume.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ViewResumeArgs>(
          orElse: () =>
              ViewResumeArgs(resumeID: pathParams.getInt('resumeID')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ViewResume(
          key: args.key,
          resumeID: args.resumeID,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomeScreen(),
      );
    },
    IntroSliderPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.IntroSliderPage(),
      );
    },
    CvMakerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CvMakerRouteArgs>(
          orElse: () => CvMakerRouteArgs(
                resumeID: pathParams.optInt('resumeID'),
                templateName: pathParams.optString('templateName'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.CvMakerScreen(
          key: args.key,
          resumeID: args.resumeID,
          templateName: args.templateName,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SignUpScreen(),
      );
    },
    AdminChangePasswordPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.AdminChangePasswordPage(),
      );
    },
    AdminContactUsFullPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminContactUsFullPageArgs>(
          orElse: () => AdminContactUsFullPageArgs(
              messageId: pathParams.getString('messageId')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.AdminContactUsFullPage(
          key: args.key,
          messageId: args.messageId,
        ),
      );
    },
    AdminContactUsPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.AdminContactUsPage(),
      );
    },
    AdminHomePage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.AdminHomePage(),
      );
    },
    AdminSubscriptionSettingPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.AdminSubscriptionSettingPage(),
      );
    },
    AllTemplatesPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.AllTemplatesPage(),
      );
    },
    AdminUpdateTemplatePage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminUpdateTemplatePageArgs>(
          orElse: () => AdminUpdateTemplatePageArgs(
              templateId: pathParams.getString('templateId')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.AdminUpdateTemplatePage(
          key: args.key,
          templateId: args.templateId,
        ),
      );
    },
    AdminAllUsersPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.AdminAllUsersPage(),
      );
    },
    UserProfilePage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserProfilePageArgs>(
          orElse: () =>
              UserProfilePageArgs(userId: pathParams.getString('userId')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.UserProfilePage(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    SignInDashboardPage.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.SignInDashboardPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AboutUsPage]
class AboutUsPage extends _i22.PageRouteInfo<void> {
  const AboutUsPage({List<_i22.PageRouteInfo>? children})
      : super(
          AboutUsPage.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ContactUsPage]
class ContactUsPage extends _i22.PageRouteInfo<void> {
  const ContactUsPage({List<_i22.PageRouteInfo>? children})
      : super(
          ContactUsPage.name,
          initialChildren: children,
        );

  static const String name = 'ContactUsPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AccountSettingPage]
class AccountSettingPage extends _i22.PageRouteInfo<void> {
  const AccountSettingPage({List<_i22.PageRouteInfo>? children})
      : super(
          AccountSettingPage.name,
          initialChildren: children,
        );

  static const String name = 'AccountSettingPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i4.Dashboard]
class Dashboard extends _i22.PageRouteInfo<void> {
  const Dashboard({List<_i22.PageRouteInfo>? children})
      : super(
          Dashboard.name,
          initialChildren: children,
        );

  static const String name = 'Dashboard';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i5.MarketPlacePage]
class MarketPlacePage extends _i22.PageRouteInfo<void> {
  const MarketPlacePage({List<_i22.PageRouteInfo>? children})
      : super(
          MarketPlacePage.name,
          initialChildren: children,
        );

  static const String name = 'MarketPlacePage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ViewResume]
class ViewResume extends _i22.PageRouteInfo<ViewResumeArgs> {
  ViewResume({
    _i23.Key? key,
    required int resumeID,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ViewResume.name,
          args: ViewResumeArgs(
            key: key,
            resumeID: resumeID,
          ),
          rawPathParams: {'resumeID': resumeID},
          initialChildren: children,
        );

  static const String name = 'ViewResume';

  static const _i22.PageInfo<ViewResumeArgs> page =
      _i22.PageInfo<ViewResumeArgs>(name);
}

class ViewResumeArgs {
  const ViewResumeArgs({
    this.key,
    required this.resumeID,
  });

  final _i23.Key? key;

  final int resumeID;

  @override
  String toString() {
    return 'ViewResumeArgs{key: $key, resumeID: $resumeID}';
  }
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i22.PageRouteInfo<void> {
  const HomeRoute({List<_i22.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i8.IntroSliderPage]
class IntroSliderPage extends _i22.PageRouteInfo<void> {
  const IntroSliderPage({List<_i22.PageRouteInfo>? children})
      : super(
          IntroSliderPage.name,
          initialChildren: children,
        );

  static const String name = 'IntroSliderPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i9.CvMakerScreen]
class CvMakerRoute extends _i22.PageRouteInfo<CvMakerRouteArgs> {
  CvMakerRoute({
    _i24.Key? key,
    required int? resumeID,
    required String? templateName,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          CvMakerRoute.name,
          args: CvMakerRouteArgs(
            key: key,
            resumeID: resumeID,
            templateName: templateName,
          ),
          rawPathParams: {
            'resumeID': resumeID,
            'templateName': templateName,
          },
          initialChildren: children,
        );

  static const String name = 'CvMakerRoute';

  static const _i22.PageInfo<CvMakerRouteArgs> page =
      _i22.PageInfo<CvMakerRouteArgs>(name);
}

class CvMakerRouteArgs {
  const CvMakerRouteArgs({
    this.key,
    required this.resumeID,
    required this.templateName,
  });

  final _i24.Key? key;

  final int? resumeID;

  final String? templateName;

  @override
  String toString() {
    return 'CvMakerRouteArgs{key: $key, resumeID: $resumeID, templateName: $templateName}';
  }
}

/// generated route for
/// [_i10.SignInScreen]
class SignInRoute extends _i22.PageRouteInfo<void> {
  const SignInRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SignUpScreen]
class SignUpRoute extends _i22.PageRouteInfo<void> {
  const SignUpRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i12.AdminChangePasswordPage]
class AdminChangePasswordPage extends _i22.PageRouteInfo<void> {
  const AdminChangePasswordPage({List<_i22.PageRouteInfo>? children})
      : super(
          AdminChangePasswordPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminChangePasswordPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i13.AdminContactUsFullPage]
class AdminContactUsFullPage
    extends _i22.PageRouteInfo<AdminContactUsFullPageArgs> {
  AdminContactUsFullPage({
    _i24.Key? key,
    required String messageId,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          AdminContactUsFullPage.name,
          args: AdminContactUsFullPageArgs(
            key: key,
            messageId: messageId,
          ),
          rawPathParams: {'messageId': messageId},
          initialChildren: children,
        );

  static const String name = 'AdminContactUsFullPage';

  static const _i22.PageInfo<AdminContactUsFullPageArgs> page =
      _i22.PageInfo<AdminContactUsFullPageArgs>(name);
}

class AdminContactUsFullPageArgs {
  const AdminContactUsFullPageArgs({
    this.key,
    required this.messageId,
  });

  final _i24.Key? key;

  final String messageId;

  @override
  String toString() {
    return 'AdminContactUsFullPageArgs{key: $key, messageId: $messageId}';
  }
}

/// generated route for
/// [_i14.AdminContactUsPage]
class AdminContactUsPage extends _i22.PageRouteInfo<void> {
  const AdminContactUsPage({List<_i22.PageRouteInfo>? children})
      : super(
          AdminContactUsPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminContactUsPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i15.AdminHomePage]
class AdminHomePage extends _i22.PageRouteInfo<void> {
  const AdminHomePage({List<_i22.PageRouteInfo>? children})
      : super(
          AdminHomePage.name,
          initialChildren: children,
        );

  static const String name = 'AdminHomePage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i16.AdminSubscriptionSettingPage]
class AdminSubscriptionSettingPage extends _i22.PageRouteInfo<void> {
  const AdminSubscriptionSettingPage({List<_i22.PageRouteInfo>? children})
      : super(
          AdminSubscriptionSettingPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminSubscriptionSettingPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i17.AllTemplatesPage]
class AllTemplatesPage extends _i22.PageRouteInfo<void> {
  const AllTemplatesPage({List<_i22.PageRouteInfo>? children})
      : super(
          AllTemplatesPage.name,
          initialChildren: children,
        );

  static const String name = 'AllTemplatesPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i18.AdminUpdateTemplatePage]
class AdminUpdateTemplatePage
    extends _i22.PageRouteInfo<AdminUpdateTemplatePageArgs> {
  AdminUpdateTemplatePage({
    _i24.Key? key,
    required String templateId,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          AdminUpdateTemplatePage.name,
          args: AdminUpdateTemplatePageArgs(
            key: key,
            templateId: templateId,
          ),
          rawPathParams: {'templateId': templateId},
          initialChildren: children,
        );

  static const String name = 'AdminUpdateTemplatePage';

  static const _i22.PageInfo<AdminUpdateTemplatePageArgs> page =
      _i22.PageInfo<AdminUpdateTemplatePageArgs>(name);
}

class AdminUpdateTemplatePageArgs {
  const AdminUpdateTemplatePageArgs({
    this.key,
    required this.templateId,
  });

  final _i24.Key? key;

  final String templateId;

  @override
  String toString() {
    return 'AdminUpdateTemplatePageArgs{key: $key, templateId: $templateId}';
  }
}

/// generated route for
/// [_i19.AdminAllUsersPage]
class AdminAllUsersPage extends _i22.PageRouteInfo<void> {
  const AdminAllUsersPage({List<_i22.PageRouteInfo>? children})
      : super(
          AdminAllUsersPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminAllUsersPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i20.UserProfilePage]
class UserProfilePage extends _i22.PageRouteInfo<UserProfilePageArgs> {
  UserProfilePage({
    _i24.Key? key,
    required String userId,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          UserProfilePage.name,
          args: UserProfilePageArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'UserProfilePage';

  static const _i22.PageInfo<UserProfilePageArgs> page =
      _i22.PageInfo<UserProfilePageArgs>(name);
}

class UserProfilePageArgs {
  const UserProfilePageArgs({
    this.key,
    required this.userId,
  });

  final _i24.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserProfilePageArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i21.SignInDashboardPage]
class SignInDashboardPage extends _i22.PageRouteInfo<void> {
  const SignInDashboardPage({List<_i22.PageRouteInfo>? children})
      : super(
          SignInDashboardPage.name,
          initialChildren: children,
        );

  static const String name = 'SignInDashboardPage';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}
