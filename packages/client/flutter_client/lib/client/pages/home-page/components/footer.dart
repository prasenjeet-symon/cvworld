import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return const FooterSectionMobile();
      } else {
        return const FooterSectionDesktop();
      }
    });
  }
}

class FooterSectionMobile extends StatelessWidget {
  const FooterSectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F7F8),
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FooterSocialLinks(),
          FooterQuickLinks(),
          FooterAllRightReserved(),
        ],
      ),
    );
  }
}

class FooterSectionDesktop extends StatelessWidget {
  const FooterSectionDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F7F8),
      padding: const EdgeInsets.fromLTRB(150, 50, 150, 50),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FooterSocialLinks(),
          FooterQuickLinks(),
          FooterAllRightReserved(),
        ],
      ),
    );
  }
}

class FooterSocialLinks extends StatelessWidget {
  const FooterSocialLinks({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20, // Adjust the spacing as needed
        runSpacing: 10, // Adjust the run spacing as needed
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram),
            onPressed: () {
              _launchURL('https://instagram.com/cvworld.me');
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.youtube),
            onPressed: () {
              _launchURL('https://www.youtube.com/@cvworld.me.official');
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.facebook),
            onPressed: () {
              _launchURL('https://www.facebook.com/profile.php?id=100068915222324&mibextid=LQQJ4d');
            },
          ),
        ],
      ),
    );
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'Could not launch $url';
  }
}

class FooterAllRightReserved extends StatelessWidget {
  const FooterAllRightReserved({super.key});

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    return Container(
      margin: const EdgeInsets.all(25),
      child: Text('CV World copyright © $currentYear - All rights reserved'),
    );
  }
}

class FooterQuickLinks extends StatelessWidget {
  const FooterQuickLinks({Key? key});

  @override
  Widget build(BuildContext context) {
    return ClickableLinks();
  }
}

class ClickableLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20, // Adjust the spacing as needed
        runSpacing: 10, // Adjust the run spacing as needed
        children: [
          _buildLinkText('Privacy Policy', 'https://merchant.razorpay.com/policy/MUCeXANyEQNJAn/privacy'),
          _buildLinkText('Terms & Condition', 'https://merchant.razorpay.com/policy/MUCeXANyEQNJAn/terms'),
          _buildLinkText('Refund Policy', 'https://merchant.razorpay.com/policy/MUCeXANyEQNJAn/refund'),
        ],
      ),
    );
  }

  Widget _buildLinkText(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.blue),
          children: [
            TextSpan(
              text: text,
              style: TextStyle(decoration: TextDecoration.none),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(url);
                },
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
