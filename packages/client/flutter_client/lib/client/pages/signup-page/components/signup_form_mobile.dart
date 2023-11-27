import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:cvworld/client/pages/signup-page/components/signup_form.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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
                    title: 'Create an Account',
                    subtitle: 'Take the first step toward your dream job with CV World.',
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
        EmailPasswordForm(emailController: emailController, nameController: nameController, passwordController: passwordController, onSubmit: signUpWithEmailAndPassword),
        const SizedBox(height: 10),
        SingUpWithGoogle(
          onPressed: () => signUpWithGoogle(context),
          buttonText: 'Sign Up with Google',
          icon: FontAwesomeIcons.google,
        ),
        const SizedBox(height: 50),
        AlreadyHaveAccount(mainText: 'Already have an account?', linkedText: ' Sign In', onTap: () => context.goNamed(RouteNames.signin))
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

///
///
///
///
///

class NameInput extends StatefulWidget {
  final TextEditingController nameController;

  NameInput({required this.nameController});

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  String? _validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }

    // Check if the name contains only letters and spaces.
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    // Check if the name is at least 2 characters long.
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    // Check if the name doesn't consist of only spaces.
    if (value.trim().isEmpty) {
      return 'Name cannot consist of only spaces';
    }

    return null; // Name is valid
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.nameController,
      decoration: const InputDecoration(
        hintText: 'Enter Your Full Name',
        labelText: 'Full Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) => _validateName(value!),
    );
  }
}

class EmailPasswordForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final void Function(BuildContext) onSubmit;

  EmailPasswordForm({
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.onSubmit,
  });

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          NameInput(nameController: widget.nameController), // Include NameInput
          const SizedBox(height: 10),
          EmailInput(emailController: widget.emailController),
          const SizedBox(height: 10),
          PasswordInputWithToggle(passwordController: widget.passwordController),
          const SizedBox(height: 40),
          CreateAccountButton(
              buttonText: 'CREATE ACCOUNT',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(context);
                }
              }),
        ],
      ),
    );
  }
}
