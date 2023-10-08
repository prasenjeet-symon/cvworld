import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const HeroSectionMobile();
      } else {
        return const HeroSectionDesktop();
      }
    });
  }
}

class HeroSectionMobile extends StatelessWidget {
  const HeroSectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F7F8),
      padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
      child: const HeroSectionLeft(),
    );
  }
}

class HeroSectionDesktop extends StatelessWidget {
  const HeroSectionDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F7F8),
      padding: const EdgeInsets.fromLTRB(150, 100, 150, 100),
      child: Row(
        children: [
          const Expanded(child: HeroSectionLeft()),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SizedBox(width: 400, height: 400, child: SvgPicture.asset('assets/hero_1.svg', fit: BoxFit.cover, width: double.infinity, height: double.infinity))],
            ),
          )
        ],
      ),
    );
  }
}

class HeroSectionLeft extends StatelessWidget {
  const HeroSectionLeft({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;
    return Column(
      mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 20), child: const Text('ELEVATE YOUR POTENTIAL')),
            Container(
              margin: isMobile ? const EdgeInsets.fromLTRB(0, 0, 0, 20) : const EdgeInsets.fromLTRB(0, 0, 200, 20),
              child: RichText(
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                text: const TextSpan(
                  text: 'Put your ',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'dream career',
                      style: TextStyle(color: Colors.blue, fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' within reach', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Container(
              margin: isMobile ? const EdgeInsets.fromLTRB(0, 0, 0, 20) : const EdgeInsets.fromLTRB(0, 0, 200, 20),
              child: Text('Stand out among job seekers with our best in class online resume builder. Ready to aspire higher?', style: const TextStyle(height: 1.5), textAlign: isMobile ? TextAlign.center : TextAlign.left),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ElevatedButton(
                onPressed: () {
                  context.navigateNamedTo('/dashboard');
                },
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), padding: const EdgeInsets.fromLTRB(40, 20, 40, 20)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start Now', style: TextStyle(fontSize: 16)),
                    Icon(Icons.arrow_right, color: Colors.white, size: 22),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
