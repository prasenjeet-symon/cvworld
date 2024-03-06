import 'dart:async';

import 'package:cvworld/client/pages/authentication/signup-page/signup-page.controller.dart';
import 'package:cvworld/client/pages/authentication/signup-page/signup-page.mobile.dart';
import 'package:cvworld/client/pages/authentication/signup-page/signup-page.web.dart';
import 'package:cvworld/client/shared/validators/email.validator.dart';
import 'package:cvworld/client/shared/validators/name.validator.dart';
import 'package:cvworld/client/shared/validators/password.validator.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/continue-with-email/continue-with-email.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return constraints.maxWidth > Constants.breakPoint ? const SignUpPageWeb() : const SignUpPageMobile();
    });
  }
}

///
///
/// Heading
class SignUpHeading extends StatelessWidget {
  const SignUpHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Create an Account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }
}

///
///
/// Subheading
class SignUpSubHeading extends StatelessWidget {
  const SignUpSubHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Take the first step toward your dream job with ${ApplicationConfiguration.appName}.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center),
    );
  }
}

///
///
///
/// SignUp Form
class SignUpForm extends StatefulWidget {
  final Function(String fullName, String userName, String email, String password) onSubmit;
  final Function() forgotPassword;

  const SignUpForm({super.key, required this.onSubmit, required this.forgotPassword});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final SignUpPageController _signUpPageController = SignUpPageController();
  late StreamSubscription _subscription;
  bool isUserNameTaken = true;

  @override
  void initState() {
    super.initState();

    _userNameController.text = generateUserId();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Full Name
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: double.infinity,
              child: TextFormField(
                validator: NameValidator.validate,
                keyboardType: TextInputType.name,
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                autofocus: true,
              ),
            ),
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
            // Password
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
            const SizedBox(height: 35),
            // Submit button
            ContinueWithEmail(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(_fullNameController.text, _userNameController.text, _emailController.text, _passwordController.text);
                }
              },
              buttonText: 'CREATE ACCOUNT',
              icon: FontAwesomeIcons.userPlus,
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
/// Already have an account
class AlreadyHaveAnAccount extends StatelessWidget {
  const AlreadyHaveAnAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            context.pushNamed(RouteNames.signin);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: 'Sign In', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
