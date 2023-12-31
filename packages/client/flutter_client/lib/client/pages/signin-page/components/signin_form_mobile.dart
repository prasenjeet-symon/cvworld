import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/signin-page/components/signin_form.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SigninFormMobile extends StatefulWidget {
  const SigninFormMobile({super.key});

  @override
  State<SigninFormMobile> createState() => _SigninFormMobileState();
}

class _SigninFormMobileState extends State<SigninFormMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 150),
                Heading(
                  title: 'Welcome back',
                  subtitle: 'Ready to generate new cv just fill the details to login.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                SigninForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextAlign textAlign;

  const Heading({
    Key? key,
    required this.title,
    required this.subtitle,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // A title
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // A subtitle
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: textAlign,
        )
      ],
    );
  }
}

// Sign in form
class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign in using the email and password
  void signInEmailAndPassword(BuildContext context) {
    SignInLogic(email: _emailController.text, password: _passwordController.text).signInNow(context);
  }

  // sign in with google
  void signInWithGoogle(BuildContext context) {
    SignInLogic(email: _emailController.text, password: _passwordController.text).signInWithGoogle(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email input bordered input round
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        // Password input
        TextField(
          controller: _passwordController,
          obscureText: true, // This property hides the entered text
          decoration: const InputDecoration(hintText: 'Enter your password', labelText: 'Password', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 40),
        SignInButton(onPressed: () => signInEmailAndPassword(context)),
        const SizedBox(height: 10),
        GoogleSignInButton(onPressed: () => signInWithGoogle(context)),
        const SizedBox(height: 50),
        const SignUpText(),
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({super.key, required this.onPressed});

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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        child: const Text('Login to account'),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.google),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text('Sign in with google'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Don\'t have an account? ',
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'SignUp',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle navigation to SignUp screen here
                    context.pushRoute(const SignUpRoute());
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
