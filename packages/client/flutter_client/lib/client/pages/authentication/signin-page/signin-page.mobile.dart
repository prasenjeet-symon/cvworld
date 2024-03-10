import 'dart:async';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/client/pages/authentication/signin-page/signin-page.controller.dart';
import 'package:cvworld/client/pages/authentication/signin-page/signin-page.dart';
import 'package:cvworld/client/pages/home-page/components/footer.dart';
import 'package:cvworld/client/shared/continue-with-google/continue-with-google.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SigninPageMobile extends StatefulWidget {
  const SigninPageMobile({super.key});

  @override
  State<SigninPageMobile> createState() => _SigninPageMobileState();
}

class _SigninPageMobileState extends State<SigninPageMobile> {
  SigninPageController controller = SigninPageController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ApplicationToken.getInstance().observable.listen((event) {
      if (event != null) {
        context.goNamed(RouteNames.dashboard);
      }
    });

    NotificationManager.getInstance(ctx: context);
  }

  ///
  ///
  /// Signin with email and password
  void signin(String email, String password) {
    controller.signinWithEmailAndPassword(email, password);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Heading text and subheading text
                                  const SigninHeading(),
                                  const SigninSubHeading(),
                                  const SizedBox(height: 20),
                                  SigninForm(onSubmit: signin),
                                  const SizedBox(height: 10),
                                  // Sign up with google
                                  ContinueWithGoogle(
                                    buttonText: 'Sign in with Google',
                                    icon: FontAwesomeIcons.google,
                                    onPressed: () {
                                      controller.signinWithGoogle();
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  const DoNotHaveAnAccount()
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const FooterSection()
            ],
          ),
        ),
      ),
    );
  }
}
