import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/home-page/components/footer.dart';
import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:cvworld/client/pages/signup-page/components/signup_form_mobile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupFormDesktop extends StatefulWidget {
  const SignupFormDesktop({super.key});

  @override
  State<SignupFormDesktop> createState() => _SignupFormDesktopState();
}

class _SignupFormDesktopState extends State<SignupFormDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 40,
                          child: TextButton.icon(
                            onPressed: () => {context.pushNamed(RouteNames.home)},
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                          width: double.infinity,
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Heading(
                                      title: 'Create an Account',
                                      subtitle: 'Take the first step toward your dream job with CV World.',
                                    ),
                                    SizedBox(height: 50),
                                    SignUpForm(),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('assets/signup_cover.webp')),
                    ),
                  )
                ],
              ),
            ),
            const FooterSection()
          ],
        ),
      ),
    );
  }
}

class SignUpLogic {
  final String name;
  final String email;
  final String password;

  SignUpLogic({required this.name, required this.email, required this.password});

  Future<void> signUp(BuildContext ctx) async {
    if (!(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty)) {
      return;
    }

    try {
      await DatabaseService().signUpUserWithEmailAndPassword(email, password, name);
    } catch (e) {
      if (e is UserAlreadyExistsException) {
        // ignore: use_build_context_synchronously
        // Flutter toast
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: const Text('User already exists. Please signin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            action: SnackBarAction(
              label: 'Signin',
              onPressed: () {
                ctx.pushNamed(RouteNames.signin);
              },
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );

        ctx.pushNamed(RouteNames.signin);
      }

      return;
    }

    // ignore: use_build_context_synchronously
    ctx.goNamed(RouteNames.dashboard);
  }

  void signInWithGoogle(BuildContext ctx) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(clientId: kIsWeb ? ApplicationConfiguration.GOOGLE_WEB_CLIENT_ID : Constants.googleClientIdAndroid);
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      var accessToken = googleAuth.accessToken!;
      await DatabaseService().continueWithGoogle(accessToken);
      // ignore: use_build_context_synchronously
      ctx.goNamed(RouteNames.dashboard);
    }
  }
}
