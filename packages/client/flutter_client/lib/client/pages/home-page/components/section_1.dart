import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionOne extends StatelessWidget {
  const SectionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const SectionOneMobileVersion();
      } else {
        return const SectionOneDesktop();
      }
    });
  }
}

class SectionOneDesktop extends StatelessWidget {
  const SectionOneDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: SvgPicture.asset('assets/section_1.svg', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: const Text('Online resume builder', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 150, 15),
                        child: const Text('You get one first impression. CVWorld makes it count.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: const Text(
                          'Make your first impression count with CVWorld. We understand the importance of a well-crafted CV, and our platform is here to help you stand out. Create professional resumes, showcase your skills, and land your dream job. Start building your future with CVWorld today',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.document_scanner_sharp, color: Colors.blue, size: 15),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: const Text('Easy to use online resume builder', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.sensor_occupied_outlined, color: Colors.blue, size: 15),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: const Text('ATS optimized resumes', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified, color: Colors.blue, size: 15),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: const Text('Trusted by verified resume writers', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.navigateNamedTo('/dashboard'),
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
                  )),
                ],
              )),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

///
///
///
///
///
///

class SectionOneMobileVersion extends StatelessWidget {
  const SectionOneMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Hello Mobile');
  }
}
