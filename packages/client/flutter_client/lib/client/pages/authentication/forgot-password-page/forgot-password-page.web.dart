import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/link-sent-component/link-sent-component.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPageWeb extends StatelessWidget {
  const ForgotPasswordPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      // Back button
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: BackButtonApp(onPressed: () => Navigator.pop(context)),
                      ),
                      // ForgotPasswordWebContent(),
                      LinkSentComponent(isMobile: false)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

///
///
/// Forgot Password web content
class ForgotPasswordWebContent extends StatelessWidget {
  const ForgotPasswordWebContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ForgotPasswordLogo(),
            const ForgotPasswordHeading(),
            const ForgotPasswordSubHeading(),
            ForgotPasswordForm(onSubmit: (email) {}),
          ],
        ),
      ),
    );
  }
}
