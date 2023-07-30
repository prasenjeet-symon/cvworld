// ignore: file_names
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/home-page/components/footer.dart';
import 'package:flutter_client/client/pages/signup-page/components/signup_form_mobile.dart';
import 'package:flutter_client/client/utils.dart';

import 'components/signup_form.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > Constants.breakPoint) {
        return const SignupFormDesktop();
      } else {
        return const SignUpFormMobile();
      }
    });
  }
}
