import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:flutter_client/client/pages/signup-page/components/signup_form.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpFormMobile extends StatefulWidget {
  const SignUpFormMobile({super.key});

  @override
  State<SignUpFormMobile> createState() => _SignUpFormMobileState();
}

class _SignUpFormMobileState extends State<SignUpFormMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 120),
                  Heading(
                    title: 'Create an account',
                    subtitle: 'Take your first step toward your dream job with cvworld',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  SignUpForm()
                ],
              ),
            )),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Signup with email and password
  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    SignUpLogic(name: nameController.text, email: emailController.text, password: passwordController.text).signUp(context);
  }

  // Sing up with google
  Future<void> signUpWithGoogle(BuildContext context) async {
    SignUpLogic(name: nameController.text, email: emailController.text, password: passwordController.text).signInWithGoogle(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name field
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        // Email field
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        // Password field
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
          obscureText: true, // Hide the password input
        ),
        const SizedBox(height: 40),
        CreateAccountButton(
          onPressed: () => signUpWithEmailAndPassword(context),
          buttonText: 'Create an account',
        ),
        const SizedBox(height: 10),
        SingUpWithGoogle(
          onPressed: () => signUpWithGoogle(context),
          buttonText: 'Sign up with Google',
          icon: FontAwesomeIcons.google,
        ),
        const SizedBox(height: 50),
        AlreadyHaveAccount(mainText: 'Already have an account', linkedText: ' Sign in?', onTap: () => context.pushRoute(const SignInRoute()))
      ],
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CreateAccountButton({super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(20), // Use a single value for all sides
        ),
        child: Text(buttonText),
      ),
    );
  }
}

class SingUpWithGoogle extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData icon;

  const SingUpWithGoogle({super.key, required this.onPressed, required this.buttonText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          padding: const EdgeInsets.all(20), // Use a single value for all sides
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(buttonText),
            )
          ],
        ),
      ),
    );
  }
}

class AlreadyHaveAccount extends StatelessWidget {
  final String mainText;
  final String linkedText;
  final VoidCallback onTap;
  final Color mainTextColor;
  final Color linkedTextColor;

  const AlreadyHaveAccount({super.key, required this.mainText, required this.linkedText, required this.onTap, this.mainTextColor = Colors.black, this.linkedTextColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: mainText,
            style: TextStyle(color: mainTextColor),
            children: [
              TextSpan(
                text: linkedText,
                style: TextStyle(color: linkedTextColor),
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
