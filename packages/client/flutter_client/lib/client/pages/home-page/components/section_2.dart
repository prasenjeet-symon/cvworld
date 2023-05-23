import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const SectionTwoMobile();
      } else {
        return const SectionTwoDesktop();
      }
    });
  }
}

class SectionTwoMobile extends StatelessWidget {
  const SectionTwoMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Mobie');
  }
}

class SectionTwoDesktop extends StatelessWidget {
  const SectionTwoDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 100, 0, 100),
        child: Row(children: [
          Expanded(
            child: SizedBox(),
            flex: 1,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        'Quick Resume Builder',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 150, 15),
                      child: Text(
                          'Effortlessly Create a Stunning Professional Resume',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Text(
                          'Our online resume builder simplifies the process of crafting a standout resume. With user-friendly templates and intuitive tools, you can create a polished and professional resume in just a few minutes. Impress potential employers with a visually appealing and well-structured resume that highlights your skills and experience. Start building your resume today and take the next step towards landing your dream job.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.5)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.document_scanner_sharp,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Job-specific resumes',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sensor_occupied_outlined,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Optimized templates and text',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'Industry best practices',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Build Resume', style: TextStyle(fontSize: 11)),
                          Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ))
                  ],
                )),
                Expanded(
                    child: SvgPicture.asset(
                  'assets/section_1.svg',
                  fit: BoxFit.cover,
                )),
              ],
            ),
            flex: 7,
          ),
          Expanded(
            child: SizedBox(),
            flex: 1,
          ),
        ]));
  }
}
