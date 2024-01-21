import 'package:cvworld/client/pages/make-cv-pages/cv-maker-logic.dart';
import 'package:cvworld/client/pages/make-cv-pages/education-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/employment-history-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/personal-details-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/professional-summry-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/skills-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/website-links-section.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CvMakerScreen extends StatelessWidget {
  final int? resumeID;
  final String? templateName;

  const CvMakerScreen({super.key, required this.resumeID, required this.templateName});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return CvMakerMobile(resumeID: resumeID, templateName: templateName);
      } else {
        return CvMakerDesktop(resumeID: resumeID, templateName: templateName);
      }
    });
  }
}

// Cv Maker desktop screen
class CvMakerDesktop extends StatelessWidget {
  final int? resumeID;
  final String? templateName;

  const CvMakerDesktop({super.key, this.resumeID, this.templateName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: CvMakerBody(resumeID: resumeID, templateName: templateName),
      ),
    );
  }
}

// Cv Maker for mobile
class CvMakerMobile extends StatelessWidget {
  final int? resumeID;
  final String? templateName;

  const CvMakerMobile({super.key, this.resumeID, this.templateName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Maker'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(10), child: SingleChildScrollView(child: CvMakerBody(resumeID: resumeID, templateName: templateName))),
    );
  }
}

class CvMakerBody extends StatefulWidget {
  final int? resumeID;
  final String? templateName;

  const CvMakerBody({super.key, this.resumeID, this.templateName});

  @override
  State<CvMakerBody> createState() => _CvMakerBodyState();
}

class _CvMakerBodyState extends State<CvMakerBody> {
  late CVMakerLogic _logic;

  @override
  void initState() {
    super.initState();

    _logic = CVMakerLogic(widget.resumeID, widget.templateName, () {
      if (mounted) {
        setState(() {});
      }
    });

    _logic.init();
  }

  @override
  Widget build(BuildContext context) {
    if (_logic.isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }

    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Stack(
      children: [
        if (!isMobile)
          Positioned(
            top: 10,
            left: 10,
            child: BackButtonApp(onPressed: () {
              Navigator.pop(context);
            }),
          ),
        if (!isMobile) Positioned(bottom: 30, left: 1, width: 450, child: Image.asset('assets/add-name-image.png', fit: BoxFit.cover)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: isMobile ? MediaQuery.of(context).size.width * 0.95 : MediaQuery.of(context).size.width * 0.5,
              margin: isMobile ? const EdgeInsets.fromLTRB(0, 0, 0, 0) : const EdgeInsets.fromLTRB(0, 100, 0, 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: const Text('Build Your Future Now', style: TextStyle(fontSize: 45, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                    child: const Text("You made a great selection! Now let's build your resume for greater future", style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500)),
                  ),
                  PersonalDetailSection(key: _logic.personalDetailSectionKey, title: _logic.personalDetailTitle, description: _logic.personalDetailDescription, resume: _logic.oldResume?.resume),
                  ProfessionalSummary(key: _logic.professionSectionKey, title: _logic.professionalSummeryTitle, description: _logic.professionalSummeryDescription, resume: _logic.oldResume?.resume),
                  EmploymentHistorySection(key: _logic.employmentHisKey, title: _logic.employmentHisTitle, description: _logic.employmentHisDescription, resume: _logic.oldResume?.resume),
                  EducationSection(key: _logic.educationSectionKey, title: _logic.educationSectionTitle, description: _logic.educationSectionDescription, resume: _logic.oldResume?.resume),
                  WebsiteLinkSection(key: _logic.websiteLinksSectionKey, title: _logic.websiteLinkTitle, description: _logic.websiteLinkDescription, resume: _logic.oldResume?.resume),
                  SkillSection(key: _logic.skillsSectionKey, title: _logic.skillTitle, description: _logic.skillDescription, resume: _logic.oldResume?.resume),
                  ..._logic.restOfElements,
                  Container(
                    margin: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 45, 0, 25),
                          child: const Text('Add Section', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          margin: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(10, 15, 10, 15)),
                                  onPressed: _logic.isInternshipVisible() ? null : () => _logic.addInternship(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_alarm, size: 20),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: const Text('Internships', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(10, 15, 10, 15)),
                                  onPressed: _logic.isCourseVisible() ? null : () => _logic.addCourse(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.book, size: 20),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: const Text('Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(10, 15, 10, 15)),
                                  onPressed: _logic.isLanguageVisible() ? null : () => _logic.addLanguage(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.language, size: 20),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: const Text('Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(10, 15, 10, 15)),
                                  onPressed: _logic.isHobbiesVisible() ? null : () => _logic.addHobbies(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.sports_football, size: 20),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: const Text('Hobbies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 80, 0, 45),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(25)),
                      onPressed: () => {_logic.generateResume(context)},
                      child: const Text('Generate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
