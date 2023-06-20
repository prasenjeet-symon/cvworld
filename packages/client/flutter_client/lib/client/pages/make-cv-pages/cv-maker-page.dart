import 'dart:convert';
import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/courses-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/education-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/employment-history-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/hobbie-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/internship-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/language-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/personal-details-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/professional-summry-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/skills-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/website-links-section.dart';
import 'package:flutter_client/client/utils.dart';

@RoutePage()
class CvMakerScreen extends StatelessWidget {
  const CvMakerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return const CvMakerMobileScreen();
              } else {
                return const CvMakerDesktopScreen();
              }
            })
          ],
        ),
      ),
    );
  }
}

class CvMakerDesktopScreen extends StatefulWidget {
  const CvMakerDesktopScreen({super.key});

  @override
  State<CvMakerDesktopScreen> createState() => _CvMakerDesktopScreenState();
}

class _CvMakerDesktopScreenState extends State<CvMakerDesktopScreen> {
  bool isLoading = false;
  final String educationSectionTitle = 'Education';
  final String educationSectionDescription =
      'A varied education on your resume sums up the value that your learnings and background will bring to job.';
  final String personalDetailTitle = 'Personal Details';
  final String personalDetailDescription = '';
  final String professionalSummeryTitle = 'Professional Summary';
  final String professionalSummeryDescription =
      'Write 2-4 short & energetic sentences to interest the reader! Mention your role, experience & most importantly - your biggest achievements, best qualities and skills.';
  final employmentHisTitle = 'Employment History';
  final String employmentHisDescription =
      'Show your relevant experience (last 10 years). Use bullet points to note your achievements, if possible - use numbers/facts (Achieved X, measured by Y, by doing Z).';
  final String websiteLinkTitle = 'Websites & Social Links';
  final String websiteLinkDescription =
      'You can add links to websites you want hiring managers to see! Perhaps It will be  a link to your portfolio, LinkedIn profile, or personal website';
  final String skillTitle = 'Skills';
  final String skillDescription =
      'Choose 5 important skills that show you fit the position. Make sure they match the key skills mentioned in the job listing (especially when applying via an online system).';
  final String internshipTitle = 'Internship';
  final String internshipDescription = '';
  final String languageTitle = 'Languages';
  final String languageDescription = '';

  bool canShowHobbies = false;
  bool canShowCourses = false;
  bool canShowInternship = false;
  bool canShowLanguage = false;

  // keys
  final GlobalKey<EducationSectionState> educationSection = GlobalKey();
  final GlobalKey<CourseSectionState> courseSection = GlobalKey();
  final GlobalKey<EmploymentHistorySectionState> employmentHis = GlobalKey();
  final GlobalKey<HobbiesSectionState> hobbiesSection = GlobalKey();
  final GlobalKey<InternshipSectionState> internshipSection = GlobalKey();
  final GlobalKey<LanguageSectionState> languageSection = GlobalKey();
  final GlobalKey<PersonalDetailSectionState> personalDetailSection =
      GlobalKey();
  final GlobalKey<ProfessionalSummaryState> professionSection = GlobalKey();
  final GlobalKey<SkillSectionState> skillsSection = GlobalKey();
  final GlobalKey<WebsiteLinkSectionState> websiteLinksSection = GlobalKey();

  Resume getData() {
    var employmentHistoryData = employmentHis.currentState?.getData() ?? [];
    var educationSectionData = educationSection.currentState?.getData() ?? [];
    var internshipSectionData = internshipSection.currentState?.getData() ?? [];
    var coursesSectionData = courseSection.currentState?.getData() ?? [];
    var linksSectionData = websiteLinksSection.currentState?.getData() ?? [];
    var languageSectionData = languageSection.currentState?.getData() ?? [];
    var skillsSectionData = skillsSection.currentState?.getData() ?? [];

    var extraInfo = personalDetailSection.currentState?.getExtraData();
    var hobbiesSectionData = hobbiesSection.currentState?.getData() ?? '';
    var professionalData = professionSection.currentState?.getData();
    var detailsData = personalDetailSection.currentState?.getData();

    return Resume(
      extraInfo['name'],
      extraInfo['profession'],
      professionalData['profile'],
      employmentHistoryData,
      educationSectionData,
      internshipSectionData,
      coursesSectionData,
      detailsData,
      hobbiesSectionData,
      linksSectionData,
      languageSectionData,
      skillsSectionData,
    );
  }

  // generate the resume
  generateResume(BuildContext ctx) async {
    isLoading = true;
    setState(() {});

    var payload = getData();
    var generatedResume = await DatabaseService().generateResume(payload);

    isLoading = false;
    setState(() {});

    // ignore: use_build_context_synchronously
    ctx.navigateNamedTo('/dashboard/view-resume/${generatedResume?.id}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          child: BackButtonApp(onPressed: () {
            context.back();
          }),
        ),
        Positioned(
            bottom: 30,
            left: 1,
            width: 450,
            child: Image.asset(
              'assets/add-name-image.png',
              fit: BoxFit.cover,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              width: 600,
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: const Text(
                      'Build Your Future Now',
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                    child: const Text(
                      "You made a great selection! Now let's build your resume for greater future",
                      style: TextStyle(
                          fontSize: 16.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                  PersonalDetailSection(
                    key: personalDetailSection,
                    title: personalDetailTitle,
                    description: personalDetailDescription,
                  ),
                  ProfessionalSummary(
                    key: professionSection,
                    title: professionalSummeryTitle,
                    description: professionalSummeryDescription,
                  ),
                  EmploymentHistorySection(
                    key: employmentHis,
                    title: employmentHisTitle,
                    description: employmentHisDescription,
                  ),
                  EducationSection(
                    key: educationSection,
                    title: educationSectionTitle,
                    description: educationSectionDescription,
                  ),
                  WebsiteLinkSection(
                    key: websiteLinksSection,
                    title: websiteLinkTitle,
                    description: websiteLinkDescription,
                  ),
                  SkillSection(
                    key: skillsSection,
                    title: skillTitle,
                    description: skillDescription,
                  ),
                  if (canShowInternship)
                    InternshipSection(
                      key: internshipSection,
                      title: internshipTitle,
                      description: internshipDescription,
                    ),
                  if (canShowCourses)
                    CourseSection(
                      key: courseSection,
                      title: 'Courses',
                      description: '',
                    ),
                  if (canShowLanguage)
                    LanguageSection(
                      key: languageSection,
                      title: languageTitle,
                      description: languageDescription,
                    ),
                  if (canShowHobbies)
                    HobbiesSection(
                      key: hobbiesSection,
                      title: 'Hobbies',
                      description: '',
                    ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 45, 0, 25),
                          child: const Text(
                            'Add Section',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15)),
                                  onPressed: !canShowInternship
                                      ? () => {
                                            if (mounted)
                                              {
                                                setState(() {
                                                  canShowInternship =
                                                      !canShowInternship;
                                                })
                                              }
                                          }
                                      : null,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_alarm,
                                        size: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: const Text(
                                          'Internships',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15)),
                                  onPressed: !canShowCourses
                                      ? () => {
                                            if (mounted)
                                              {
                                                setState(() {
                                                  canShowCourses =
                                                      !canShowCourses;
                                                })
                                              }
                                          }
                                      : null,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.book,
                                        size: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: const Text(
                                          'Courses',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15)),
                                  onPressed: !canShowLanguage
                                      ? () => {
                                            if (mounted)
                                              {
                                                setState(() {
                                                  canShowLanguage =
                                                      !canShowLanguage;
                                                })
                                              }
                                          }
                                      : null,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.language,
                                        size: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: const Text(
                                          'Language',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15)),
                                  onPressed: !canShowHobbies
                                      ? () => {
                                            if (mounted)
                                              {
                                                setState(() {
                                                  canShowHobbies =
                                                      !canShowHobbies;
                                                })
                                              }
                                          }
                                      : null,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.sports_football,
                                        size: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        child: const Text(
                                          'Hobbies',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(25),
                        // Add any other custom styles here
                      ),
                      onPressed: () {
                        // Handle button press
                        generateResume(context);
                      },
                      child: const Text(
                        'Generate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

class CvMakerMobileScreen extends StatelessWidget {
  const CvMakerMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Hello Mobile');
  }
}
