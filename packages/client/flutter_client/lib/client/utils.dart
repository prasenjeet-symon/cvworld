// a function to determine the page width given the context
import 'dart:html';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// SOME APPLICATION CONSTANTS
class Constants {
  static const String appName = 'CV World';
  static const String appVersion = '1.0';
  static const int debounceTime = 1000;
  static const googleClientId = '599994784077-8b5i8jsi9s75ddqv8p8v1031gk2mise7.apps.googleusercontent.com';
  static const String razorpayKeyID = 'rzp_test_nkLYI55QVnJlaQ';
}

double pageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600 ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width;
}

int flexNumber(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600 ? 1 : 0;
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var isAuthenticated = await DatabaseService().isAuthenticated();
    if (!isAuthenticated) {
      router.navigateNamed('/signin');
      return;
    } else {
      resolver.next(true);
    }
  }
}

class RouteGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var isAuthenticated = await DatabaseService().isAuthenticated();
    if (isAuthenticated) {
      router.navigateNamed('/dashboard');
      return;
    } else {
      resolver.next(true);
    }
  }
}

void downloadFile(String url, String fileName) {
  final anchor = AnchorElement(href: url);
  anchor.download = fileName;
  anchor.target = '_blank';

  anchor.click();
}

Future<void> logOutUser(BuildContext context) async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'JWT');
  // ignore: use_build_context_synchronously
  context.navigateNamedTo('/signin');
}

class BackButtonApp extends StatelessWidget {
  final void Function() onPressed;

  const BackButtonApp({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.fromLTRB(25, 15, 25, 15)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          SizedBox(width: 8.0),
          Text(
            'Back',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

String toUtcJsonDateTimeFromDateTime(DateTime dateTime) {
  // Convert DateTime to UTC
  DateTime utcDateTime = dateTime.toUtc();

  // Convert DateTime to JSON datetime string with 'Z' for UTC
  String jsonDateTime = utcDateTime.toIso8601String();

  return jsonDateTime;
}

// For the user already exit
class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException(this.message);

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}

// For no user exist
class NoUserException implements Exception {
  final String message;

  NoUserException(this.message);

  @override
  String toString() => 'NoUserException: $message';
}

// For the week password
class WeekPasswordException implements Exception {
  final String message;

  WeekPasswordException(this.message);

  @override
  String toString() => 'WeekPasswordException: $message';
}

// For the wrong password exception
class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException(this.message);

  @override
  String toString() => 'WrongPasswordException: $message';
}

// Input fields are required
class RequiredFieldException implements Exception {
  final String message;

  RequiredFieldException(this.message);

  @override
  String toString() => 'RequiredFieldException: $message';
}
