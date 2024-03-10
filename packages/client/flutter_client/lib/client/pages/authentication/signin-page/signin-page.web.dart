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

class SigninPageWeb extends StatefulWidget {
  const SigninPageWeb({super.key});

  @override
  State<SigninPageWeb> createState() => _SigninPageWebState();
}

class _SigninPageWebState extends State<SigninPageWeb> {
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  ///
  ///
  /// Signin with email and password
  void signin(String email, String password) {
    controller.signinWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Back button
                          const BackButton(),
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
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Container(
                          height: 500,
                          margin: const EdgeInsets.fromLTRB(0, 50, 10, 0),
                          child: Image.asset('assets/signin_cover.jpg', fit: BoxFit.cover, height: double.infinity),
                        ),
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
