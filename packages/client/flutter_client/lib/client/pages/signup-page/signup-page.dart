import 'package:cvworld/client/pages/signup-page/components/signup_form_mobile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

import 'components/signup_form.dart';

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
