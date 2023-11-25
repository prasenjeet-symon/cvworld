import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return const SectionTwoMobile();
      } else {
        return const SectionTwoDesktop();
      }
    });
  }
}

class SectionTwoDesktop extends StatelessWidget {
  const SectionTwoDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Row(children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                const Expanded(child: SectionTwoLeft()),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [SizedBox(width: 300, height: 300, child: SvgPicture.asset('assets/section_2.svg', fit: BoxFit.cover, width: double.infinity, height: double.infinity))],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ]));
  }
}

class SectionTwoLeft extends StatelessWidget {
  const SectionTwoLeft({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text('QUICK RESUME BUILDER', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400), textAlign: isMobile ? TextAlign.center : TextAlign.left),
        ),
        Container(
          margin: isMobile ? const EdgeInsets.fromLTRB(0, 0, 0, 10) : const EdgeInsets.fromLTRB(0, 0, 150, 15),
          child: Text('Effortlessly create a stunning professional resume', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600), textAlign: isMobile ? TextAlign.center : TextAlign.left),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Text(
            'Our online resume builder simplifies the process of crafting a standout resume. With user-friendly templates and intuitive tools, you can create a polished and professional resume in just a few minutes. Impress potential employers with a visually appealing and well-structured resume that highlights your skills and experience. Start building your resume today and take the next step towards landing your dream job.',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
            crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.document_scanner_sharp, color: Colors.blue, size: 15),
                    isMobile
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Text('Job-specific resumes', style: TextStyle(fontWeight: FontWeight.w500)),
                          )
                        : Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: const Text('Job-specific resumes', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.sensor_occupied_outlined, color: Colors.blue, size: 15),
                    isMobile
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Text('Optimized templates and text', style: TextStyle(fontWeight: FontWeight.w500)),
                          )
                        : Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: const Text('Optimized templates and text', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified, color: Colors.blue, size: 15),
                    isMobile
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Text('Industry best practices', style: TextStyle(fontWeight: FontWeight.w500)),
                          )
                        : Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: const Text('Industry best practices', style: TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => context.pushNamed(RouteNames.dashboard),
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), padding: const EdgeInsets.fromLTRB(20, 15, 20, 15)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Build Resume', style: TextStyle(fontSize: 11)),
              Icon(Icons.arrow_right, color: Colors.white, size: 18),
            ],
          ),
        )
      ],
    );
  }
}

class SectionTwoMobile extends StatelessWidget {
  const SectionTwoMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6EEE8),
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      padding: const EdgeInsets.all(30),
      child: const Column(
        children: [SectionTwoLeft()],
      ),
    );
  }
}
