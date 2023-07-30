// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;
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

abstract class $AppRouter extends _i11.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    ContactUsPage.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ContactUsPage(),
      );
    },
    AccountSettingPage.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AccountSettingPage(),
      );
    },
    Dashboard.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.Dashboard(),
      );
    },
    MarketPlacePage.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MarketPlacePage(),
      );
    },
    ViewResume.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ViewResumeArgs>(
          orElse: () =>
              ViewResumeArgs(resumeID: pathParams.getInt('resumeID')));
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ViewResume(
          key: args.key,
          resumeID: args.resumeID,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.HomeScreen(),
      );
    },
    IntroSliderPage.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
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
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.CvMakerScreen(
          key: args.key,
          resumeID: args.resumeID,
          templateName: args.templateName,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SignInScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SignUpScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ContactUsPage]
class ContactUsPage extends _i11.PageRouteInfo<void> {
  const ContactUsPage({List<_i11.PageRouteInfo>? children})
      : super(
          ContactUsPage.name,
          initialChildren: children,
        );

  static const String name = 'ContactUsPage';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AccountSettingPage]
class AccountSettingPage extends _i11.PageRouteInfo<void> {
  const AccountSettingPage({List<_i11.PageRouteInfo>? children})
      : super(
          AccountSettingPage.name,
          initialChildren: children,
        );

  static const String name = 'AccountSettingPage';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i3.Dashboard]
class Dashboard extends _i11.PageRouteInfo<void> {
  const Dashboard({List<_i11.PageRouteInfo>? children})
      : super(
          Dashboard.name,
          initialChildren: children,
        );

  static const String name = 'Dashboard';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MarketPlacePage]
class MarketPlacePage extends _i11.PageRouteInfo<void> {
  const MarketPlacePage({List<_i11.PageRouteInfo>? children})
      : super(
          MarketPlacePage.name,
          initialChildren: children,
        );

  static const String name = 'MarketPlacePage';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ViewResume]
class ViewResume extends _i11.PageRouteInfo<ViewResumeArgs> {
  ViewResume({
    _i12.Key? key,
    required int resumeID,
    List<_i11.PageRouteInfo>? children,
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

  static const _i11.PageInfo<ViewResumeArgs> page =
      _i11.PageInfo<ViewResumeArgs>(name);
}

class ViewResumeArgs {
  const ViewResumeArgs({
    this.key,
    required this.resumeID,
  });

  final _i12.Key? key;

  final int resumeID;

  @override
  String toString() {
    return 'ViewResumeArgs{key: $key, resumeID: $resumeID}';
  }
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i7.IntroSliderPage]
class IntroSliderPage extends _i11.PageRouteInfo<void> {
  const IntroSliderPage({List<_i11.PageRouteInfo>? children})
      : super(
          IntroSliderPage.name,
          initialChildren: children,
        );

  static const String name = 'IntroSliderPage';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i8.CvMakerScreen]
class CvMakerRoute extends _i11.PageRouteInfo<CvMakerRouteArgs> {
  CvMakerRoute({
    _i12.Key? key,
    required int? resumeID,
    required String? templateName,
    List<_i11.PageRouteInfo>? children,
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

  static const _i11.PageInfo<CvMakerRouteArgs> page =
      _i11.PageInfo<CvMakerRouteArgs>(name);
}

class CvMakerRouteArgs {
  const CvMakerRouteArgs({
    this.key,
    required this.resumeID,
    required this.templateName,
  });

  final _i12.Key? key;

  final int? resumeID;

  final String? templateName;

  @override
  String toString() {
    return 'CvMakerRouteArgs{key: $key, resumeID: $resumeID, templateName: $templateName}';
  }
}

/// generated route for
/// [_i9.SignInScreen]
class SignInRoute extends _i11.PageRouteInfo<void> {
  const SignInRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SignUpScreen]
class SignUpRoute extends _i11.PageRouteInfo<void> {
  const SignUpRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}
