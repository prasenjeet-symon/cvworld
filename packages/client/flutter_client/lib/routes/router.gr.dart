// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/foundation.dart' as _i22;
import 'package:flutter/material.dart' as _i23;
import 'package:flutter_client/client/pages/contact-us-page/contact-us-page.dart'
    as _i1;
import 'package:flutter_client/client/pages/dashboard/account-setting/account-setting.dart'
    as _i2;
import 'package:flutter_client/client/pages/dashboard/dashboard/dashboard.dart'
    as _i3;
import 'package:flutter_client/client/pages/dashboard/market-place/market-place.dart'
    as _i4;
import 'package:flutter_client/client/pages/dashboard/view-resume/view-resume.dart'
    as _i5;
import 'package:flutter_client/client/pages/home-page/home-page.dart' as _i6;
import 'package:flutter_client/client/pages/intro-slides/intro-slides.dart'
    as _i7;
import 'package:flutter_client/client/pages/make-cv-pages/cv-maker-page.dart'
    as _i8;
import 'package:flutter_client/client/pages/signin-page/signin-page.dart'
    as _i9;
import 'package:flutter_client/client/pages/signup-page/signup-page.dart'
    as _i10;
import 'package:flutter_client/dashboard/dashboard/change_password/change_password.dart'
    as _i13;
import 'package:flutter_client/dashboard/dashboard/contact_us/contact_us_full_page.dart'
    as _i20;
import 'package:flutter_client/dashboard/dashboard/contact_us/contact_us_page.dart'
    as _i19;
import 'package:flutter_client/dashboard/dashboard/home_page/home_page.dart'
    as _i12;
import 'package:flutter_client/dashboard/dashboard/subscription_setting/subscription_setting.dart'
    as _i14;
import 'package:flutter_client/dashboard/dashboard/templates/all_templates_page.dart'
    as _i17;
import 'package:flutter_client/dashboard/dashboard/templates/update_template.dart'
    as _i18;
import 'package:flutter_client/dashboard/dashboard/users/all_users_page.dart'
    as _i15;
import 'package:flutter_client/dashboard/dashboard/users/user_profile_page.dart'
    as _i16;
import 'package:flutter_client/dashboard/sign_in_page/sign_in_page.dart'
    as _i11;

abstract class $AppRouter extends _i21.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i21.PageFactory> pagesMap = {
    ContactUsPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ContactUsPage(),
      );
    },
    AccountSettingPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AccountSettingPage(),
      );
    },
    Dashboard.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.Dashboard(),
      );
    },
    MarketPlacePage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MarketPlacePage(),
      );
    },
    ViewResume.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ViewResumeArgs>(
          orElse: () =>
              ViewResumeArgs(resumeID: pathParams.getInt('resumeID')));
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ViewResume(
          key: args.key,
          resumeID: args.resumeID,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.HomeScreen(),
      );
    },
    IntroSliderPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.IntroSliderPage(),
      );
    },
    CvMakerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CvMakerRouteArgs>(
          orElse: () => CvMakerRouteArgs(
                resumeID: pathParams.optInt('resumeID'),
                templateName: pathParams.optString('templateName'),
              ));
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.CvMakerScreen(
          key: args.key,
          resumeID: args.resumeID,
          templateName: args.templateName,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SignUpScreen(),
      );
    },
    SignInDashboardPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SignInDashboardPage(),
      );
    },
    AdminHomePage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.AdminHomePage(),
      );
    },
    AdminChangePasswordPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.AdminChangePasswordPage(),
      );
    },
    AdminSubscriptionSettingPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.AdminSubscriptionSettingPage(),
      );
    },
    AdminAllUsersPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.AdminAllUsersPage(),
      );
    },
    UserProfilePage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserProfilePageArgs>(
          orElse: () =>
              UserProfilePageArgs(userId: pathParams.getString('userId')));
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.UserProfilePage(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    AllTemplatesPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.AllTemplatesPage(),
      );
    },
    AdminUpdateTemplatePage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminUpdateTemplatePageArgs>(
          orElse: () => AdminUpdateTemplatePageArgs(
              templateId: pathParams.getString('templateId')));
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.AdminUpdateTemplatePage(
          key: args.key,
          templateId: args.templateId,
        ),
      );
    },
    AdminContactUsPage.name: (routeData) {
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.AdminContactUsPage(),
      );
    },
    AdminContactUsFullPage.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminContactUsFullPageArgs>(
          orElse: () => AdminContactUsFullPageArgs(
              messageId: pathParams.getString('messageId')));
      return _i21.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.AdminContactUsFullPage(
          key: args.key,
          messageId: args.messageId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ContactUsPage]
class ContactUsPage extends _i21.PageRouteInfo<void> {
  const ContactUsPage({List<_i21.PageRouteInfo>? children})
      : super(
          ContactUsPage.name,
          initialChildren: children,
        );

  static const String name = 'ContactUsPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AccountSettingPage]
class AccountSettingPage extends _i21.PageRouteInfo<void> {
  const AccountSettingPage({List<_i21.PageRouteInfo>? children})
      : super(
          AccountSettingPage.name,
          initialChildren: children,
        );

  static const String name = 'AccountSettingPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i3.Dashboard]
class Dashboard extends _i21.PageRouteInfo<void> {
  const Dashboard({List<_i21.PageRouteInfo>? children})
      : super(
          Dashboard.name,
          initialChildren: children,
        );

  static const String name = 'Dashboard';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MarketPlacePage]
class MarketPlacePage extends _i21.PageRouteInfo<void> {
  const MarketPlacePage({List<_i21.PageRouteInfo>? children})
      : super(
          MarketPlacePage.name,
          initialChildren: children,
        );

  static const String name = 'MarketPlacePage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ViewResume]
class ViewResume extends _i21.PageRouteInfo<ViewResumeArgs> {
  ViewResume({
    _i22.Key? key,
    required int resumeID,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<ViewResumeArgs> page =
      _i21.PageInfo<ViewResumeArgs>(name);
}

class ViewResumeArgs {
  const ViewResumeArgs({
    this.key,
    required this.resumeID,
  });

  final _i22.Key? key;

  final int resumeID;

  @override
  String toString() {
    return 'ViewResumeArgs{key: $key, resumeID: $resumeID}';
  }
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i21.PageRouteInfo<void> {
  const HomeRoute({List<_i21.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i7.IntroSliderPage]
class IntroSliderPage extends _i21.PageRouteInfo<void> {
  const IntroSliderPage({List<_i21.PageRouteInfo>? children})
      : super(
          IntroSliderPage.name,
          initialChildren: children,
        );

  static const String name = 'IntroSliderPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i8.CvMakerScreen]
class CvMakerRoute extends _i21.PageRouteInfo<CvMakerRouteArgs> {
  CvMakerRoute({
    _i23.Key? key,
    required int? resumeID,
    required String? templateName,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<CvMakerRouteArgs> page =
      _i21.PageInfo<CvMakerRouteArgs>(name);
}

class CvMakerRouteArgs {
  const CvMakerRouteArgs({
    this.key,
    required this.resumeID,
    required this.templateName,
  });

  final _i23.Key? key;

  final int? resumeID;

  final String? templateName;

  @override
  String toString() {
    return 'CvMakerRouteArgs{key: $key, resumeID: $resumeID, templateName: $templateName}';
  }
}

/// generated route for
/// [_i9.SignInScreen]
class SignInRoute extends _i21.PageRouteInfo<void> {
  const SignInRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SignUpScreen]
class SignUpRoute extends _i21.PageRouteInfo<void> {
  const SignUpRoute({List<_i21.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SignInDashboardPage]
class SignInDashboardPage extends _i21.PageRouteInfo<void> {
  const SignInDashboardPage({List<_i21.PageRouteInfo>? children})
      : super(
          SignInDashboardPage.name,
          initialChildren: children,
        );

  static const String name = 'SignInDashboardPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i12.AdminHomePage]
class AdminHomePage extends _i21.PageRouteInfo<void> {
  const AdminHomePage({List<_i21.PageRouteInfo>? children})
      : super(
          AdminHomePage.name,
          initialChildren: children,
        );

  static const String name = 'AdminHomePage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i13.AdminChangePasswordPage]
class AdminChangePasswordPage extends _i21.PageRouteInfo<void> {
  const AdminChangePasswordPage({List<_i21.PageRouteInfo>? children})
      : super(
          AdminChangePasswordPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminChangePasswordPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i14.AdminSubscriptionSettingPage]
class AdminSubscriptionSettingPage extends _i21.PageRouteInfo<void> {
  const AdminSubscriptionSettingPage({List<_i21.PageRouteInfo>? children})
      : super(
          AdminSubscriptionSettingPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminSubscriptionSettingPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i15.AdminAllUsersPage]
class AdminAllUsersPage extends _i21.PageRouteInfo<void> {
  const AdminAllUsersPage({List<_i21.PageRouteInfo>? children})
      : super(
          AdminAllUsersPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminAllUsersPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i16.UserProfilePage]
class UserProfilePage extends _i21.PageRouteInfo<UserProfilePageArgs> {
  UserProfilePage({
    _i23.Key? key,
    required String userId,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<UserProfilePageArgs> page =
      _i21.PageInfo<UserProfilePageArgs>(name);
}

class UserProfilePageArgs {
  const UserProfilePageArgs({
    this.key,
    required this.userId,
  });

  final _i23.Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserProfilePageArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i17.AllTemplatesPage]
class AllTemplatesPage extends _i21.PageRouteInfo<void> {
  const AllTemplatesPage({List<_i21.PageRouteInfo>? children})
      : super(
          AllTemplatesPage.name,
          initialChildren: children,
        );

  static const String name = 'AllTemplatesPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i18.AdminUpdateTemplatePage]
class AdminUpdateTemplatePage
    extends _i21.PageRouteInfo<AdminUpdateTemplatePageArgs> {
  AdminUpdateTemplatePage({
    _i23.Key? key,
    required String templateId,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<AdminUpdateTemplatePageArgs> page =
      _i21.PageInfo<AdminUpdateTemplatePageArgs>(name);
}

class AdminUpdateTemplatePageArgs {
  const AdminUpdateTemplatePageArgs({
    this.key,
    required this.templateId,
  });

  final _i23.Key? key;

  final String templateId;

  @override
  String toString() {
    return 'AdminUpdateTemplatePageArgs{key: $key, templateId: $templateId}';
  }
}

/// generated route for
/// [_i19.AdminContactUsPage]
class AdminContactUsPage extends _i21.PageRouteInfo<void> {
  const AdminContactUsPage({List<_i21.PageRouteInfo>? children})
      : super(
          AdminContactUsPage.name,
          initialChildren: children,
        );

  static const String name = 'AdminContactUsPage';

  static const _i21.PageInfo<void> page = _i21.PageInfo<void>(name);
}

/// generated route for
/// [_i20.AdminContactUsFullPage]
class AdminContactUsFullPage
    extends _i21.PageRouteInfo<AdminContactUsFullPageArgs> {
  AdminContactUsFullPage({
    _i23.Key? key,
    required String messageId,
    List<_i21.PageRouteInfo>? children,
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

  static const _i21.PageInfo<AdminContactUsFullPageArgs> page =
      _i21.PageInfo<AdminContactUsFullPageArgs>(name);
}

class AdminContactUsFullPageArgs {
  const AdminContactUsFullPageArgs({
    this.key,
    required this.messageId,
  });

  final _i23.Key? key;

  final String messageId;

  @override
  String toString() {
    return 'AdminContactUsFullPageArgs{key: $key, messageId: $messageId}';
  }
}
