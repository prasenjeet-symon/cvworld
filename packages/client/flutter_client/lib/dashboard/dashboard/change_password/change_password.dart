import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              Navigator.pop(context);
            }),
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Big Heading "Change Password"
                const Text('Change Password', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                const SizedBox(height: 35),
                AdminChangePasswordForm(
                  newPasswordController: adminChangePasswordLogic.passwordController,
                  confirmPasswordController: adminChangePasswordLogic.confirmPasswordController,
                  onPasswordChange: () => adminChangePasswordLogic.changePassword(context),
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
  Future<void> changePassword(BuildContext context) async {
    var password = passwordController.text;
    var confirmPassword = confirmPasswordController.text;

    // check for the password
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              'Passwords do not match. Please try again.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      return;
    }

    await DashboardDataService().resetPassword(confirmPassword);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green, // Use a green color for success
        content: Center(
          child: Text(
            'Password updated successfully!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    // Logout
    await logoutAdmin();
    // ignore: use_build_context_synchronously
    context.pushNamed(RouteNames.adminSignin);
    return;
  }
}

///
///
///
///
///
///
class AdminPasswordInputWithToggle extends StatefulWidget {
  final TextEditingController passwordController;
  final String labelText; // Add labelText as an input parameter

  const AdminPasswordInputWithToggle({
    Key? key,
    required this.passwordController,
    required this.labelText,
  }) : super(key: key);

  @override
  _AdminPasswordInputWithToggleState createState() => _AdminPasswordInputWithToggleState();
}

class _AdminPasswordInputWithToggleState extends State<AdminPasswordInputWithToggle> {
  bool _isPasswordVisible = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    // Use the provided labelText in validation messages
    if (value.length < 8) {
      return '${widget.labelText} must be at least 8 characters long';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return '${widget.labelText} must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return '${widget.labelText} must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return '${widget.labelText} must contain at least one digit';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return '${widget.labelText} must contain at least one special character';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Enter your ${widget.labelText.toLowerCase()}',
        labelText: widget.labelText, // Use the provided labelText
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: _validatePassword,
    );
  }
}

///
///
///
///
///
class AdminChangePasswordForm extends StatefulWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final void Function() onPasswordChange;

  const AdminChangePasswordForm({Key? key, required this.newPasswordController, required this.confirmPasswordController, required this.onPasswordChange}) : super(key: key);

  @override
  _AdminChangePasswordFormState createState() => _AdminChangePasswordFormState();
}

class _AdminChangePasswordFormState extends State<AdminChangePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AdminPasswordInputWithToggle(
            labelText: 'New Password',
            passwordController: widget.newPasswordController,
          ),
          const SizedBox(height: 10),
          AdminPasswordInputWithToggle(
            labelText: 'Confirm Password',
            passwordController: widget.confirmPasswordController,
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onPasswordChange();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
}
