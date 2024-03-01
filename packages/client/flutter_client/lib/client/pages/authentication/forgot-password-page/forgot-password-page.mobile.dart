import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.controller.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/forgot-password-page.web.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/link-sent-component/link-sent-component.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPageMobile extends StatefulWidget {
  const ForgotPasswordPageMobile({super.key});

  @override
  State<ForgotPasswordPageMobile> createState() => _ForgotPasswordPageMobileState();
}

class _ForgotPasswordPageMobileState extends State<ForgotPasswordPageMobile> {
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

    await controller.sendResetPasswordEmail(email);

    setState(() {
      isLoading = false;
      isSent = true;
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
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
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
