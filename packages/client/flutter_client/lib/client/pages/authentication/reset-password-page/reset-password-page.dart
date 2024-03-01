import 'dart:async';

import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/pages/authentication/reset-password-page/reset-password-page.controller.dart';
import 'package:cvworld/client/pages/authentication/reset-password-page/reset-password-page.mobile.dart';
import 'package:cvworld/client/pages/authentication/reset-password-page/reset-password-page.web.dart';
import 'package:cvworld/client/shared/continue-with-email/continue-with-email.dart';
import 'package:cvworld/client/shared/validators/password.validator.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;
  final String userId;

  const ResetPasswordPage({super.key, required this.token, required this.userId});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < Constants.breakPoint) {
          return ResetPasswordPageMobile(
            token: token,
            userId: userId,
          );
        } else {
          return ResetPasswordPageWeb(
            token: token,
            userId: userId,
          );
        }
      },
    );
  }
}

///
///
///
/// Reset password logo
class ResetPasswordLogo extends StatelessWidget {
  const ResetPasswordLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Image.asset('assets/logo.png', width: 150, height: 150),
    );
  }
}

///
///
/// Reset password heading
class ResetPasswordHeading extends StatelessWidget {
  const ResetPasswordHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Reset Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }
}

///
///
///
/// Reset password subheading
class ResetPasswordSubHeading extends StatelessWidget {
  const ResetPasswordSubHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: Text('Enter your new password.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey.shade700), textAlign: TextAlign.center),
    );
  }
}

///
///
/// Reset password form
class ResetPasswordForm extends StatefulWidget {
  final String token;
  final String userId;

  const ResetPasswordForm({super.key, required this.token, required this.userId});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ResetPasswordPageController _controller = ResetPasswordPageController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ApplicationToken.getInstance().observable.listen((event) {
      if (event != null) {
        context.goNamed(RouteNames.dashboard);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: double.infinity,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: PasswordValidator.validate,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: double.infinity,
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                validator: PasswordValidator.validate,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ContinueWithEmail(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
                    ErrorManager.getInstance().dispatch('Password does not match');
                    return;
                  }

                  _controller.resetPassword(widget.userId, _passwordController.text, widget.token);
                }
              },
              buttonText: 'Reset Password',
              icon: FontAwesomeIcons.refresh,
            )
          ],
        ),
      ),
    );
  }
}
