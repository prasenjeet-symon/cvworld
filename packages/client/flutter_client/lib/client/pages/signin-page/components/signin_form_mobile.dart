import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/pages/signin-page/components/signin_form.dart';
import 'package:cvworld/routes/router.gr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SigninFormMobile extends StatefulWidget {
  const SigninFormMobile({super.key});

  @override
  State<SigninFormMobile> createState() => _SigninFormMobileState();
}

class _SigninFormMobileState extends State<SigninFormMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 150),
                Heading(
                  title: 'Welcome back!',
                  subtitle: ' Ready to generate a new CV? Login to your account.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                SigninForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextAlign textAlign;

  const Heading({
    Key? key,
    required this.title,
    required this.subtitle,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // A title
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        // A subtitle
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: textAlign,
        )
      ],
    );
  }
}

// Sign in form
class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign in using the email and password
  void signInEmailAndPassword(BuildContext context) {
    SignInLogic(email: _emailController.text, password: _passwordController.text).signInNow(context);
  }

  // sign in with google
  void signInWithGoogle(BuildContext context) {
    SignInLogic(email: _emailController.text, password: _passwordController.text).signInWithGoogle(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailPasswordForm(emailController: _emailController, passwordController: _passwordController, onSubmit: signInEmailAndPassword),
        const SizedBox(height: 10),
        GoogleSignInButton(onPressed: () => signInWithGoogle(context)),
        const SizedBox(height: 50),
        const SignUpText(),
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({super.key, required this.onPressed});

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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        child: const Text('LOGIN'),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.google),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Don’t have an account yet? ',
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle navigation to SignUp screen here
                    context.pushRoute(const SignUpRoute());
                  },
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
class PasswordInputWithToggle extends StatefulWidget {
  final TextEditingController passwordController;
  bool canValidate = true;

  PasswordInputWithToggle({super.key, required this.passwordController, this.canValidate = true});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordInputWithToggleState createState() => _PasswordInputWithToggleState();
}

class _PasswordInputWithToggleState extends State<PasswordInputWithToggle> {
  bool _isPasswordVisible = false;

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }

    if (!widget.canValidate) {
      return null;
    }

    //Check if the password is at least 8 characters long.
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check if the password contains at least one uppercase letter.
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check if the password contains at least one lowercase letter.
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check if the password contains at least one digit (number).
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }

    // Check if the password contains at least one special character.
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    // If all criteria are met, consider the password valid.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        labelText: 'Password',
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
      validator: (value) => _validatePassword(value!),
    );
  }
}

///
///
///
///
/// Email input
class EmailInput extends StatelessWidget {
  final TextEditingController emailController;

  const EmailInput({super.key, required this.emailController});

  String? _validateEmail(String value) {
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: 'Enter your email',
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) => _validateEmail(value!),
    );
  }
}

class EmailPasswordForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function(BuildContext) onSubmit;

  EmailPasswordForm({
    required this.emailController,
    required this.passwordController,
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
          EmailInput(emailController: widget.emailController),
          const SizedBox(height: 10),
          PasswordInputWithToggle(passwordController: widget.passwordController),
          const SizedBox(height: 40),
          SignInButton(onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(context);
            }
          }),
        ],
      ),
    );
  }
}
