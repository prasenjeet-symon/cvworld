// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:flutter_client/client/pages/contact-us-page/contact-us-page.dart'
    as _i8;
import 'package:flutter_client/client/pages/dashboard/account-setting.dart'
    as _i1;
import 'package:flutter_client/client/pages/dashboard/dashboard.dart' as _i2;
import 'package:flutter_client/client/pages/dashboard/market-place.dart' as _i9;
import 'package:flutter_client/client/pages/dashboard/view-resume.dart' as _i3;
import 'package:flutter_client/client/pages/home-page/home-page.dart' as _i4;
import 'package:flutter_client/client/pages/make-cv-pages/cv-maker-page.dart'
    as _i5;
import 'package:flutter_client/client/pages/signin-page/signin-page.dart'
    as _i6;
import 'package:flutter_client/client/pages/signup-page/signup-page.dart'
    as _i7;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    AccountSettingPage.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AccountSettingPage(),
      );
    },
    Dashboard.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Dashboard(),
      );
    },
    ViewResume.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ViewResumeArgs>(
          orElse: () =>
              ViewResumeArgs(resumeID: pathParams.getInt('resumeID')));
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ViewResume(
          key: args.key,
          resumeID: args.resumeID,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomeScreen(),
      );
    },
    CvMakerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CvMakerRouteArgs>(
          orElse: () => CvMakerRouteArgs(
                resumeID: pathParams.optInt('resumeID'),
                templateName: pathParams.optString('templateName'),
              ));
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.CvMakerScreen(
          key: args.key,
          resumeID: args.resumeID,
          templateName: args.templateName,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SignUpScreen(),
      );
    },
    ContactUsPage.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ContactUsPage(),
      );
    },
    MarketPlacePage.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.MarketPlacePage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AccountSettingPage]
class AccountSettingPage extends _i10.PageRouteInfo<void> {
  const AccountSettingPage({List<_i10.PageRouteInfo>? children})
      : super(
          AccountSettingPage.name,
          initialChildren: children,
        );

  static const String name = 'AccountSettingPage';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.Dashboard]
class Dashboard extends _i10.PageRouteInfo<void> {
  const Dashboard({List<_i10.PageRouteInfo>? children})
      : super(
          Dashboard.name,
          initialChildren: children,
        );

  static const String name = 'Dashboard';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ViewResume]
class ViewResume extends _i10.PageRouteInfo<ViewResumeArgs> {
  ViewResume({
    _i11.Key? key,
    required int resumeID,
    List<_i10.PageRouteInfo>? children,
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

  static const _i10.PageInfo<ViewResumeArgs> page =
      _i10.PageInfo<ViewResumeArgs>(name);
}

class ViewResumeArgs {
  const ViewResumeArgs({
    this.key,
    required this.resumeID,
  });

  final _i11.Key? key;

  final int resumeID;

  @override
  String toString() {
    return 'ViewResumeArgs{key: $key, resumeID: $resumeID}';
  }
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.CvMakerScreen]
class CvMakerRoute extends _i10.PageRouteInfo<CvMakerRouteArgs> {
  CvMakerRoute({
    _i11.Key? key,
    required int? resumeID,
    required String? templateName,
    List<_i10.PageRouteInfo>? children,
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

  static const _i10.PageInfo<CvMakerRouteArgs> page =
      _i10.PageInfo<CvMakerRouteArgs>(name);
}

class CvMakerRouteArgs {
  const CvMakerRouteArgs({
    this.key,
    required this.resumeID,
    required this.templateName,
  });

  final _i11.Key? key;

  final int? resumeID;

  final String? templateName;

  @override
  String toString() {
    return 'CvMakerRouteArgs{key: $key, resumeID: $resumeID, templateName: $templateName}';
  }
}

/// generated route for
/// [_i6.SignInScreen]
class SignInRoute extends _i10.PageRouteInfo<void> {
  const SignInRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SignUpScreen]
class SignUpRoute extends _i10.PageRouteInfo<void> {
  const SignUpRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ContactUsPage]
class ContactUsPage extends _i10.PageRouteInfo<void> {
  const ContactUsPage({List<_i10.PageRouteInfo>? children})
      : super(
          ContactUsPage.name,
          initialChildren: children,
        );

  static const String name = 'ContactUsPage';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.MarketPlacePage]
class MarketPlacePage extends _i10.PageRouteInfo<void> {
  const MarketPlacePage({List<_i10.PageRouteInfo>? children})
      : super(
          MarketPlacePage.name,
          initialChildren: children,
        );

  static const String name = 'MarketPlacePage';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
