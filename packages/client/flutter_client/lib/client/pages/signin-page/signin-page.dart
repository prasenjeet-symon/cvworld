import 'package:cvworld/client/pages/signin-page/components/signin_form.dart';
import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:cvworld/client/utils.dart';
// ignore: file_names
import 'package:flutter/material.dart';

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
