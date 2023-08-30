import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

@RoutePage()
class AdminChangePasswordPage extends StatefulWidget {
  const AdminChangePasswordPage({super.key});

  @override
  State<AdminChangePasswordPage> createState() => _AdminChangePasswordPageState();
}

class _AdminChangePasswordPageState extends State<AdminChangePasswordPage> {
  final AdminChangePasswordLogic adminChangePasswordLogic = AdminChangePasswordLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 500,
        margin: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BackButtonApp(onPressed: () {
              context.popRoute(const AdminChangePasswordPage());
            }),
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Big Heading "Change Password"
                const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 35),
                // New Password
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                  ),
                  obscureText: true,
                  controller: adminChangePasswordLogic.passwordController,
                ),
                const SizedBox(height: 10),
                // Confirm Password
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter your confirm password',
                  ),
                  obscureText: true,
                  controller: adminChangePasswordLogic.confirmPasswordController,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    adminChangePasswordLogic.changePassword();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                      backgroundColor: Colors.blue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      )),
                  child: const Text('Change Password'),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class AdminChangePasswordLogic {
  // password controller
  final TextEditingController passwordController = TextEditingController();
  // confirm password controller
  final TextEditingController confirmPasswordController = TextEditingController();

  // change password
  Future<void> changePassword() async {
    var password = passwordController.text;
    var confirmPassword = confirmPasswordController.text;

    // check for the password
    if (password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: 'Empty fields...', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white);
      return;
    }

    // check for the password
    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Password not match...', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white);
      return;
    }

    // update password
    await DashboardDataService().resetPassword(confirmPassword);
    return;
  }
}
