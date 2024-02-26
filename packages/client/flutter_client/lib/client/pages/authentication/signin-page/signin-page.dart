import 'package:cvworld/client/pages/authentication/signin-page/signin-page.mobile.dart';
import 'package:cvworld/client/pages/authentication/signin-page/signin-page.web.dart';
import 'package:cvworld/client/shared/validators/password.validator.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/continue-with-email/continue-with-email.dart';
import '../../../shared/validators/email.validator.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxWidth > Constants.breakPoint ? const SigninPageWeb() : const SigninPageMobile();
    });
  }
}

///
///
///
/// Signin Heading

///
///
/// Heading
class SigninHeading extends StatelessWidget {
  const SigninHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Welcome back!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }
}

///
///
///
/// Signin Subheading
class SigninSubHeading extends StatelessWidget {
  const SigninSubHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Ready to generate a new CV? Login to your account.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center),
    );
  }
}

///
///
/// Don't have an account
class DoNotHaveAnAccount extends StatelessWidget {
  const DoNotHaveAnAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            context.pushNamed(RouteNames.signup);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: RichText(
              text: const TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: 'Sign Up', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///
///
///
/// Forgot Password
class ForgotPassword extends StatelessWidget {
  final Function() forgotPassword;

  const ForgotPassword({super.key, required this.forgotPassword});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: GestureDetector(
          onTap: forgotPassword,
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text('Forgot Password?', style: TextStyle(color: Colors.blue), textAlign: TextAlign.end),
          ),
        ),
      ),
    );
  }
}

///
///
///
/// Signin Form
class SigninForm extends StatefulWidget {
  final Function(String email, String password) onSubmit;

  const SigninForm({super.key, required this.onSubmit});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: double.infinity,
              child: TextFormField(
                validator: EmailValidator.validate,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: double.infinity,
              child: TextFormField(
                validator: PasswordValidator.validate,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
            ),
            ForgotPassword(forgotPassword: () {
              context.pushNamed(RouteNames.forgotPassword);
            }),
            ContinueWithEmail(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(_emailController.text, _passwordController.text);
                }
              },
              buttonText: 'LOGIN',
              icon: FontAwesomeIcons.userPlus,
            ),
          ],
        ),
      ),
    );
  }
}
