// ignore: file_names
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/home-page/components/hero_section.dart';
import 'package:flutter_client/client/pages/home-page/components/section_1.dart';
import 'package:flutter_client/client/pages/home-page/components/section_2.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [HeroSection(), SectionOne(), SectionTwo()],
        ),
      ),
    );
  }
}
