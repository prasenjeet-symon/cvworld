import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

@RoutePage()
class SignInDashboardPage extends StatefulWidget {
  const SignInDashboardPage({super.key});

  @override
  State<SignInDashboardPage> createState() => _SignInDashboardPageState();
}

class _SignInDashboardPageState extends State<SignInDashboardPage> {
  final SignInPageLogic signInPageLogic = SignInPageLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.only(top: 200),
          child: Center(
            child: Column(children: [
              // Welcome to CV World
              const Text('Welcome to CV World', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              SignInForm(emailController: signInPageLogic.emailController, passwordController: signInPageLogic.passwordController, onSignInPressed: signInPageLogic.signInWithEmailAndPassword)
            ]),
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

class SignInForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function(BuildContext) onSignInPressed;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.onSignInPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EmailInput(emailController: emailController),
          const SizedBox(height: 15),
          PasswordInputWithToggle(passwordController: passwordController),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onSignInPressed(context);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

// Signin Page Logic
class SignInPageLogic {
  // email text editing controller
  final TextEditingController emailController = TextEditingController();
  // password text editing controller
  final TextEditingController passwordController = TextEditingController();

  // sign in with email and password
  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    // prepare the request body
    final String email = emailController.text;
    final String password = passwordController.text;
    await DashboardDataService().signInAsAdmin(email, password, context);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green, // Use a green color for success
        content: Center(
          child: Text(
            'Login successful! Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    // ignore: use_build_context_synchronously
    context.navigateNamedTo('/admin/dashboard');
  }
}
