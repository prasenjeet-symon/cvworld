import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
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
    return Text('Hello Mobile');
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram),
                    onPressed: () {},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.youtube),
                    onPressed: () {},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                    onPressed: () {},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                    onPressed: () {},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.discord),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: const Text('Contact Us')),
                Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: const Text('Our Services')),
                Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: const Text('Privacy Policy')),
                Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: const Text('Terms & Condition')),
                Container(margin: const EdgeInsets.fromLTRB(10, 0, 10, 0), child: const Text('Career')),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            child: const Text('Cvworld copyright © 2023 - All rights reserved'),
          )
        ],
      ),
    );
  }
}
