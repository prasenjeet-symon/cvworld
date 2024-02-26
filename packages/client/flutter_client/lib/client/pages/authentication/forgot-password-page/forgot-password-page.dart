import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.mobile.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.web.dart';
import 'package:cvworld/client/shared/continue-with-email/continue-with-email.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        // Mobile
        return const ForgotPasswordPageMobile();
      } else {
        // Desktop
        return const ForgotPasswordPageWeb();
      }
    });
  }
}

///
///
///
/// Forgot password logo
class ForgotPasswordLogo extends StatelessWidget {
  const ForgotPasswordLogo({super.key});

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
/// Forgot password heading
class ForgotPasswordHeading extends StatelessWidget {
  const ForgotPasswordHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Forgot Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }
}

///
///
///
/// Forgot password subheading
class ForgotPasswordSubHeading extends StatelessWidget {
  const ForgotPasswordSubHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: Text('Enter your email and we will send you a link to reset your password.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey.shade600), textAlign: TextAlign.center),
    );
  }
}

///
///
///
/// Forgot password form
class ForgotPasswordForm extends StatefulWidget {
  final Function(String email) onSubmit;

  const ForgotPasswordForm({super.key, required this.onSubmit});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Submit button
            ContinueWithEmail(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(_emailController.text);
                }
              },
              buttonText: 'Send Link',
              icon: Icons.email,
            ),
          ],
        ),
      ),
    );
  }
}
