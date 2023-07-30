// ignore: file_names
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/signin-page/components/signin_form.dart';
import 'package:flutter_client/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:flutter_client/client/utils.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > Constants.breakPoint) {
        return const SignInFormDesktop();
      } else {
        return const SigninFormMobile();
      }
    });
  }
}
