import 'package:cvworld/client/pages/authentication/reset-password-page/reset-password-page.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class ResetPasswordPageWeb extends StatelessWidget {
  final String token;
  final String userId;

  const ResetPasswordPageWeb({super.key, required this.token, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
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
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const ResetPasswordLogo(),
                              const ResetPasswordHeading(),
                              const ResetPasswordSubHeading(),
                              ResetPasswordForm(token: token, userId: userId),
                            ],
                          ),
                        ),
                      )
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
