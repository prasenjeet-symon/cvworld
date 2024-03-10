import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.controller.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/link-sent-component/link-sent-component.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPageWeb extends StatefulWidget {
  const ForgotPasswordPageWeb({super.key});

  @override
  State<ForgotPasswordPageWeb> createState() => _ForgotPasswordPageWebState();
}

class _ForgotPasswordPageWebState extends State<ForgotPasswordPageWeb> {
  ForgotPasswordController controller = ForgotPasswordController();

  bool isLoading = false;
  bool isSent = false;

  @override
  void initState() {
    super.initState();
    NotificationManager.getInstance(ctx: context);
  }

  ///
  ///
  /// Send link
  void sendLink(String email) async {
    setState(() {
      isLoading = true;
      isSent = false;
    });

    controller.sendResetPasswordEmail(email).then((value) {
      if (value.statusCode == 200) {
        if (mounted) {
          setState(() {
            isLoading = false;
            isSent = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            isSent = false;
          });
        }
      }
    });
  }

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
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
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
                            isSent ? const LinkSentComponent(isMobile: false) : ForgotPasswordWebContent(onSubmit: sendLink),
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
class ForgotPasswordWebContent extends StatefulWidget {
  final Function(String email) onSubmit;
  const ForgotPasswordWebContent({super.key, required this.onSubmit});

  @override
  State<ForgotPasswordWebContent> createState() => _ForgotPasswordWebContentState();
}

class _ForgotPasswordWebContentState extends State<ForgotPasswordWebContent> {
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
            ForgotPasswordForm(
              onSubmit: (email) {
                widget.onSubmit(email);
              },
            ),
          ],
        ),
      ),
    );
  }
}
