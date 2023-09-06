import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';
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
              const Text('Welcome to CV-World', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              // Input email and password
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: signInPageLogic.emailController,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                controller: signInPageLogic.passwordController,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    signInPageLogic.signInWithEmailAndPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  child: const Text('Sign In'))
            ]),
          ),
        ),
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
    // check for the email and password
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      // alert
      Fluttertoast.showToast(msg: 'Empty fields...', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white);
      return;
    }

    // prepare the request body
    final String email = emailController.text;
    final String password = passwordController.text;

    // sign in
    await DashboardDataService().signInAsAdmin(email, password);
    // navigate
    // /admin/dashboard
    // ignore: use_build_context_synchronously
    context.navigateNamedTo('/admin/dashboard');
  }
}
