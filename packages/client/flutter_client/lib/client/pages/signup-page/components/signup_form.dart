import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/home-page/components/footer.dart';
import 'package:flutter_client/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:flutter_client/client/pages/signup-page/components/signup_form_mobile.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                            onPressed: () {
                              context.router.pushAndPopUntil(
                                const HomeRoute(),
                                predicate: (_) => false, // Clear the stack
                              );
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
      Fluttertoast.showToast(msg: 'Please fill all fields', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
      return;
    }

    try {
      await DatabaseService().signUpUserWithEmailAndPassword(email, password, name);
    } catch (e) {
      if (e is RequiredFieldException) {
        await Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
      }

      if (e is UserAlreadyExistsException) {
        await Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
        // ignore: use_build_context_synchronously
        ctx.navigateNamedTo('/signin');
      }

      if (e is WeekPasswordException) {
        await Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
      }

      return;
    }

    await Fluttertoast.showToast(msg: 'Welcome $name', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
    // ignore: use_build_context_synchronously
    ctx.navigateNamedTo('/dashboard');
  }

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
