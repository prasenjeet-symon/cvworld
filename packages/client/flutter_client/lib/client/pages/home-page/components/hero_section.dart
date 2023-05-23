import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
    return Text('Mobile');
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
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: const Text('Elevate your potential'),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 200, 20),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Put Your ',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: 'dream career',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: ' within reach',
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 200, 20),
                        child: const Text(
                          'Stand out amoung job seekers with our best in class online resume builder. Ready to aspire higher ?',
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: ElevatedButton(
                            onPressed: () {
                              // Button action
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(40, 20, 40, 20)),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Start Now',
                                    style: TextStyle(fontSize: 16)),
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/hero_1.svg',
                    fit: BoxFit.cover, width: 400)
              ],
            ))
          ],
        ));
  }
}
