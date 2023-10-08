import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionOne extends StatelessWidget {
  const SectionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
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
                    children: [SizedBox(width: 300, height: 300, child: SvgPicture.asset('assets/section_1.svg', fit: BoxFit.cover, width: double.infinity, height: double.infinity))],
                  )),
                  const Expanded(child: SectionOneRight()),
                ],
              )),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

class SectionOneRight extends StatelessWidget {
  const SectionOneRight({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            'ONLINE RESUME BUILDER',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
        Container(
          margin: isMobile ? const EdgeInsets.fromLTRB(0, 0, 0, 15) : const EdgeInsets.fromLTRB(0, 0, 150, 15),
          child: Text(
            'You get one first impression. CV World makes it count.',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Text(
            'Make your first impression count with CV World. We understand the importance of a well-crafted CV, and our platform is here to help you stand out. Create professional resumes, showcase your skills, and land your dream job. Start building your future with CV World today',
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
                            child: const Text('Easy to use online resume builder', style: TextStyle(fontWeight: FontWeight.w500)),
                          )
                        : Expanded(
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
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.sensor_occupied_outlined, color: Colors.blue, size: 15),
                    isMobile
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Text('ATS optimized resumes', style: TextStyle(fontWeight: FontWeight.w500)),
                          )
                        : Expanded(
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
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified, color: Colors.blue, size: 15),
                    isMobile
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Text('Trusted by verified resume writers', style: TextStyle(fontWeight: FontWeight.w500)),
                          )
                        : Expanded(
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
    );
  }
}

class SectionOneMobileVersion extends StatelessWidget {
  const SectionOneMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      padding: const EdgeInsets.all(30),
      child: const Column(
        children: [SectionOneRight()],
      ),
    );
  }
}
