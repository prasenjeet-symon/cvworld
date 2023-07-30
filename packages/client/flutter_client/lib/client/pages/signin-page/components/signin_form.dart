import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/home-page/components/footer.dart';
import 'package:flutter_client/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:flutter_client/client/pages/signin-page/signin-page.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                          onPressed: () {
                            context.popRoute(const SignInScreen());
                          },
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
                                    title: 'Welcome back',
                                    subtitle: 'Ready to generate new cv just fill the details to login.',
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
        await Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
      }

      if (e is WrongPasswordException) {
        await Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
      }

      return;
    }

    await Fluttertoast.showToast(msg: 'Sign in successful...', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.green.withOpacity(0.8), textColor: Colors.white);
    // ignore: use_build_context_synchronously
    ctx.navigateNamedTo('/dashboard');
  }

  // Sign in with google
  void signInWithGoogle(BuildContext ctx) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(clientId: Constants.googleClientId);
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      var accessToken = googleAuth.accessToken!;
      await DatabaseService().continueWithGoogle(accessToken);
      // ignore: use_build_context_synchronously
      ctx.navigateNamedTo('/dashboard');
    }
  }
}
