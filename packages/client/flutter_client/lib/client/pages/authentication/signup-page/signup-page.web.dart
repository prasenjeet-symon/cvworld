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

class SignUpPageWeb extends StatefulWidget {
  const SignUpPageWeb({super.key});

  @override
  State<SignUpPageWeb> createState() => _SignUpPageWebState();
}

class _SignUpPageWebState extends State<SignUpPageWeb> {
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
        context.pushNamed(RouteNames.dashboard);
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
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Back button
                              BackButton(),
                              const SizedBox(height: 15),
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width * 0.35,
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
                                        onPressed: () {},
                                      ),
                                      const SizedBox(height: 30),
                                      AlreadyHaveAnAccount()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        flex: 1),
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(0), child: Container(margin: const EdgeInsets.fromLTRB(0, 30, 10, 0), child: Image.asset('signup_cover.webp'))), flex: 1),
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
