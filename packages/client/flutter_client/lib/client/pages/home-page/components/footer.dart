import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
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
            icon: FaIcon(FontAwesomeIcons.instagram),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.youtube),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.facebook),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.twitter),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.discord),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class FooterAllRightReserved extends StatelessWidget {
  const FooterAllRightReserved({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: const Text('CV-World copyright © 2023 - All rights reserved'),
    );
  }
}

class FooterQuickLinks extends StatelessWidget {
  const FooterQuickLinks({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: const Wrap(
        alignment: WrapAlignment.center,
        spacing: 20, // Adjust the spacing as needed
        runSpacing: 10, // Adjust the run spacing as needed
        children: [
          Text('Contact Us'),
          Text('Our Services'),
          Text('Privacy Policy'),
          Text('Terms & Condition'),
          Text('Career'),
        ],
      ),
    );
  }
}
