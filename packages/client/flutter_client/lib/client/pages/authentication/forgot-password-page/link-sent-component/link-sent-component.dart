import 'package:cvworld/client/pages/authentication/forgot-password-page/link-sent-component/link-sent-component.mobile.dart';
import 'package:cvworld/client/pages/authentication/forgot-password-page/link-sent-component/link-sent-component.web.dart';
import 'package:flutter/material.dart';

class LinkSentComponent extends StatelessWidget {
  final bool isMobile;

  const LinkSentComponent({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return const LinkSentComponentMobile();
    } else {
      return const LinkSentComponentWeb();
    }
  }
}

///
///
/// Link sent component logo
class LinkSentComponentLogo extends StatelessWidget {
  const LinkSentComponentLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Image.asset('assets/email-sent.png', width: 150, height: 150),
    );
  }
}

///
///
/// Link sent component heading
class LinkSentComponentHeading extends StatelessWidget {
  const LinkSentComponentHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: const Text('Link sent successfully', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
    );
  }
}

///
///
///
/// Link sent component subheading
class LinkSentComponentSubHeading extends StatelessWidget {
  const LinkSentComponentSubHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      width: double.infinity,
      child: Text('Please check your email for the link to reset your password.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey.shade700), textAlign: TextAlign.center),
    );
  }
}
