import 'dart:async';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/client/pages/authentication/signup-page/signup-page.controller.dart';
import 'package:cvworld/client/pages/authentication/signup-page/signup-page.dart';
import 'package:cvworld/client/pages/home-page/components/footer.dart';
import 'package:cvworld/client/shared/continue-with-google/continue-with-google.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SignUpPageMobile extends StatefulWidget {
  const SignUpPageMobile({super.key});

  @override
  State<SignUpPageMobile> createState() => _SignUpPageMobileState();
}

class _SignUpPageMobileState extends State<SignUpPageMobile> {
  SignUpPageController controller = SignUpPageController();
  StreamSubscription? _subscription;

  ///
  ///
  /// Signup with email and password
  void signup(String name, String username, String email, String password) {
    controller.signUpWithEmailAndPassword(name, username, email, password);
  }

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
                                  const SignUpHeading(),
                                  const SignUpSubHeading(),
                                  const SizedBox(height: 20),
                                  SignUpForm(onSubmit: signup, forgotPassword: () {}),
                                  const SizedBox(height: 10),
                                  // Sign up with google
                                  ContinueWithGoogle(
                                    buttonText: 'Sign up with Google',
                                    icon: FontAwesomeIcons.google,
                                    onPressed: () {
                                      controller.signupWithGoogle();
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  const AlreadyHaveAnAccount()
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
