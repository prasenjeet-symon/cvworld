import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Create controller instances for name, email, and password
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: Constants.googleClientId);

  Future<void> signUp(BuildContext ctx) async {
    var name = nameController.text;
    var email = emailController.text;
    var password = passwordController.text;

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

  // Sign in with google
  void signInWithGoogle(BuildContext ctx) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      var accessToken = googleAuth.accessToken!;
      await DatabaseService().continueWithGoogle(accessToken);
      // ignore: use_build_context_synchronously
      ctx.navigateNamedTo('/dashboard');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                      context.navigateBack();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  )),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                width: double.infinity,
                child: Column(
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
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: const Text(
                              'Create an account',
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: const Text(
                              'Take first step toward your dream job with cvworld',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                  ),
                                ),
                                TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                  ),
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                  ),
                                  obscureText: true, // Hide the password input
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: ElevatedButton(
                                  onPressed: () => {signUp(context)},
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20)),
                                  child: const Text('Create account'))),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                            child: OutlinedButton(
                              onPressed: () => {signInWithGoogle(context)},
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.google),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: const Text('Sign up with google'),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(0, 25, 0, 50),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'SignIn',
                                      style: const TextStyle(color: Colors.blue),
                                      // Add your onPressed logic for SignUp here
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          context.navigateNamedTo('/signin');
                                          // Add navigation logic for SignUp here
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/signup_cover.webp'),
            ),
          ))
        ],
      ),
    );
  }
}
