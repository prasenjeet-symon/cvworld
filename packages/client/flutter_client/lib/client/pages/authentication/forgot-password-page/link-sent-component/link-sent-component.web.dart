import 'package:cvworld/client/pages/authentication/forgot-password-page/link-sent-component/link-sent-component.dart';
import 'package:cvworld/client/shared/continue-with-email/continue-with-email.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LinkSentComponentWeb extends StatelessWidget {
  const LinkSentComponentWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const LinkSentComponentLogo(),
            const LinkSentComponentHeading(),
            const LinkSentComponentSubHeading(),
            const SizedBox(height: 10),
            ContinueWithEmail(
              onPressed: () {
                Navigator.pop(context);
              },
              buttonText: 'Back to Login',
              icon: FontAwesomeIcons.arrowRotateLeft,
            ),
          ],
        ),
      ),
    );
  }
}
