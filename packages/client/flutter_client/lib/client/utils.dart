// a function to determine the page width given the context
import 'dart:html';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

double pageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600
      ? MediaQuery.of(context).size.width * 0.7
      : MediaQuery.of(context).size.width;
}

int flexNumber(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600 ? 1 : 0;
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var canNavigate = await DatabaseService().isAuthenticated();
    if (!canNavigate) {
      router.navigateNamed('/signin');
      return;
    } else {
      resolver.next(canNavigate);
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
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 15)),
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
