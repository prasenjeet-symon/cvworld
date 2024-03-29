import 'package:cvworld/client/pages/home-page/components/footer.dart';
import 'package:cvworld/client/pages/home-page/components/header.dart';
import 'package:cvworld/client/pages/home-page/components/hero_section.dart';
import 'package:cvworld/client/pages/home-page/components/section_1.dart';
import 'package:cvworld/client/pages/home-page/components/section_2.dart';
import 'package:flutter/material.dart';
import './components/feedback/feedback.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ScrollController scrollController = ScrollController();
  // final GlobalKey<PriceSectionState> pricingSectionKey = GlobalKey();

  void scrollToPricingSection() {
    // final RenderBox? renderBox = pricingSectionKey.currentContext?.findRenderObject() as RenderBox?;
    // if (renderBox != null) {
    //   final offsetY = renderBox.localToGlobal(Offset.zero).dy;
    //   scrollController.animateTo(
    //     offsetY,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.ease,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //controller: scrollController,
        child: Column(
          children: [
            HeaderSection(pricingSectionCallback: () => scrollToPricingSection()),
            const HeroSection(),
            const SectionOne(),
            const SectionTwo(),
            // PriceSection(
            //   key: pricingSectionKey,
            // ),
            const FooterSection()
          ],
        ),
      ),
      floatingActionButton: const FeedbackComponent(),
    );
  }
}
