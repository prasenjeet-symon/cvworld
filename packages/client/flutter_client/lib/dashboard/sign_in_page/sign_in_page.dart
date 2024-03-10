import 'dart:async';

import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:cvworld/dashboard/datasource/http/http.manager.admin.dart';
import 'package:cvworld/dashboard/sign_in_page/dashboard-signin.controller.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInDashboardPage extends StatefulWidget {
  const SignInDashboardPage({super.key});

  @override
  State<SignInDashboardPage> createState() => _SignInDashboardPageState();
}

class _SignInDashboardPageState extends State<SignInDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.only(top: 200),
          child: const Center(
            child: Column(
              children: [
                Text('Welcome to CV World', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(height: 50),
                SignInForm(),
              ],
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
///

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DashboardSigninController controller = DashboardSigninController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = ApplicationToken.getInstance().observable.listen((event) {
      if (event != null) {
        context.goNamed(RouteNames.adminDashboard);
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
    return Form(
      key: formKey,
      child: Column(
        children: [
          EmailInput(emailController: emailController),
          const SizedBox(height: 15),
          PasswordInputWithToggle(passwordController: passwordController, canValidate: false),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.signInWithEmailAndPassword(emailController.text, passwordController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
