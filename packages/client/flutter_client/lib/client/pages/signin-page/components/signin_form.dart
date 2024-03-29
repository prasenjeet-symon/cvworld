import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/home-page/components/footer.dart';
import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../config.dart';

class SignInFormDesktop extends StatefulWidget {
  const SignInFormDesktop({super.key});

  @override
  State<SignInFormDesktop> createState() => _SignInFormDesktopState();
}

class _SignInFormDesktopState extends State<SignInFormDesktop> {
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
                mainAxisSize: MainAxisSize.min,
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
                                    title: 'Welcome back!',
                                    subtitle: 'Ready to generate a new CV? Login to your account.',
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height: 50),
                                  SigninForm(),
                                  SizedBox(height: 100),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 500,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(fit: BoxFit.cover, 'assets/signin_cover.jpg', height: double.infinity),
                      ),
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

class SignInLogic {
  final String email;
  final String password;

  const SignInLogic({required this.email, required this.password});

  signInNow(BuildContext ctx) async {
    try {
      await DatabaseService().signInUserWithEmailAndPassword(email, password);
    } catch (e) {
      if (e is NoUserException) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.horizontal,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.all(20),
            content: Center(
              child: Text(
                'No user found. Please check your email and try again.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }

      if (e is WrongPasswordException) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            dismissDirection: DismissDirection.horizontal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.all(20),
            duration: Duration(seconds: 5),
            content: Center(
              child: Text(
                'Wrong password. Please try again.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }

      return;
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 5),
        content: Center(
          child: Text(
            'Welcome back!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    // ignore: use_build_context_synchronously
    ctx.goNamed(RouteNames.dashboard);
  }

  // Sign in with google
  void signInWithGoogle(BuildContext ctx) async {
    final GoogleSignIn googleSignIn = kIsWeb ? GoogleSignIn(clientId: ApplicationConfiguration.googleWebClientId) : GoogleSignIn(serverClientId: ApplicationConfiguration.googleAndroidClientId);
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
