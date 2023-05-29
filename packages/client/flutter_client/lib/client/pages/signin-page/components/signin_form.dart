import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  // Create controller instances for name, email, and password
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                              'Welcome back ',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: const Text(
                              'Ready to generate new cv just fill the details to login',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                            child: Column(
                              children: [
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
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20)),
                                  child: const Text('Login to account'))),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: OutlinedButton(
                              onPressed: () => {},
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 20, 20, 20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.google),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: const Text('Sign in with google'),
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
                                  text: 'Don\'t have an account? ',
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'SignUp',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      // Add your onPressed logic for SignUp here
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          context.navigateNamedTo('/signup');
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
            height: 500,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                fit: BoxFit.cover,
                'signin_cover.jpg',
                height: double.infinity,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
