import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
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
import 'package:flutter_client/routes/router.gr.dart';

@RoutePage()
class CvMakerScreen extends StatelessWidget {
  final int? resumeID;
  final String? templateName;

  const CvMakerScreen({super.key, @PathParam() required this.resumeID, @PathParam() required this.templateName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return const CvMakerMobileScreen();
              } else {
                return CvMakerDesktopScreen(resumeID: resumeID == 0 ? null : resumeID!, templateName: templateName!);
              }
            })
          ],
        ),
      ),
    );
  }
}

class CvMakerDesktopScreen extends StatefulWidget {
  final int? resumeID;
  final String? templateName;

  const CvMakerDesktopScreen({super.key, required this.resumeID, required this.templateName});

  @override
  State<CvMakerDesktopScreen> createState() => _CvMakerDesktopScreenState();
}

class _CvMakerDesktopScreenState extends State<CvMakerDesktopScreen> {
  GeneratedResume? oldResume;
  bool isLoading = true;

  final String educationSectionTitle = 'Education';
  final String educationSectionDescription = 'A varied education on your resume sums up the value that your learnings and background will bring to job.';

  final String personalDetailTitle = 'Personal Details';
  final String personalDetailDescription = '';

  final String professionalSummeryTitle = 'Professional Summary';
  final String professionalSummeryDescription = 'Write 2-4 short & energetic sentences to interest the reader! Mention your role, experience & most importantly - your biggest achievements, best qualities and skills.';

  final employmentHisTitle = 'Employment History';
  final String employmentHisDescription = 'Show your relevant experience (last 10 years). Use bullet points to note your achievements, if possible - use numbers/facts (Achieved X, measured by Y, by doing Z).';

  final String websiteLinkTitle = 'Websites & Social Links';
  final String websiteLinkDescription = 'You can add links to websites you want hiring managers to see! Perhaps It will be  a link to your portfolio, LinkedIn profile, or personal website';

  final String skillTitle = 'Skills';
  final String skillDescription = 'Choose 5 important skills that show you fit the position. Make sure they match the key skills mentioned in the job listing (especially when applying via an online system).';

  final String internshipTitle = 'Internship';
  final String internshipDescription = '';

  final String languageTitle = 'Languages';
  final String languageDescription = '';

  List<dynamic> restOfElements = [];

  bool canShowHobbies = false;
  bool canShowCourses = false;
  bool canShowInternship = false;
  bool canShowLanguage = false;

  final GlobalKey<EducationSectionState> educationSection = GlobalKey();
  final GlobalKey<CourseSectionState> courseSection = GlobalKey();
  final GlobalKey<EmploymentHistorySectionState> employmentHis = GlobalKey();
  final GlobalKey<HobbiesSectionState> hobbiesSection = GlobalKey();
  final GlobalKey<InternshipSectionState> internshipSection = GlobalKey();
  final GlobalKey<LanguageSectionState> languageSection = GlobalKey();
  final GlobalKey<PersonalDetailSectionState> personalDetailSection = GlobalKey();
  final GlobalKey<ProfessionalSummaryState> professionSection = GlobalKey();
  final GlobalKey<SkillSectionState> skillsSection = GlobalKey();
  final GlobalKey<WebsiteLinkSectionState> websiteLinksSection = GlobalKey();

  // add hobbies
  void addHobbies() {
    var hobbiesSectionIndex = restOfElements.indexWhere((element) => element is HobbiesSection);
    if (hobbiesSectionIndex == -1) {
      restOfElements.add(HobbiesSection(
        key: hobbiesSection,
        title: 'Hobbies',
        description: '',
        resume: oldResume?.resume,
      ));

      setState(() {});
    }
  }

  // add internship
  void addInternship() {
    var internshipSectionIndex = restOfElements.indexWhere((element) => element is InternshipSection);
    if (internshipSectionIndex == -1) {
      restOfElements.add(InternshipSection(
        key: internshipSection,
        title: 'Internship',
        description: '',
        resume: oldResume?.resume,
      ));
    }
  }

  // add CourseSection
  void addCourse() {
    var courseSectionIndex = restOfElements.indexWhere((element) => element is CourseSection);
    if (courseSectionIndex == -1) {
      restOfElements.add(CourseSection(
        key: courseSection,
        title: 'Course',
        description: '',
        resume: oldResume?.resume,
      ));
    }
  }

  // add LanguageSection
  void addLanguage() {
    var languageSectionIndex = restOfElements.indexWhere((element) => element is LanguageSection);
    if (languageSectionIndex == -1) {
      restOfElements.add(LanguageSection(
        key: languageSection,
        title: languageTitle,
        description: languageDescription,
        resume: oldResume?.resume,
      ));
    }
  }

  Resume getData() {
    // all those that is array
    var employmentHistoryData = employmentHis.currentState?.getData() ?? [];
    var educationSectionData = educationSection.currentState?.getData() ?? [];
    var internshipSectionData = internshipSection.currentState?.getData() ?? [];
    var coursesSectionData = courseSection.currentState?.getData() ?? [];
    var linksSectionData = websiteLinksSection.currentState?.getData() ?? [];
    var languageSectionData = languageSection.currentState?.getData() ?? [];
    var skillsSectionData = skillsSection.currentState?.getData() ?? [];
    // all those that is object or string
    var extraInfo = personalDetailSection.currentState?.getExtraData();
    var hobbiesSectionData = hobbiesSection.currentState?.getData() ?? '';
    var professionalData = professionSection.currentState?.getData();
    var detailsData = personalDetailSection.currentState?.getData();

    return Resume(
      extraInfo?['name'],
      extraInfo?['profession'],
      professionalData['profile'],
      employmentHistoryData,
      educationSectionData,
      internshipSectionData,
      coursesSectionData,
      detailsData!,
      hobbiesSectionData,
      linksSectionData,
      languageSectionData,
      skillsSectionData,
    );
  }

  // fetch the old resume for editing if applicable
  Future<void> fetchResume() async {
    isLoading = true;
    setState(() {});
    if (widget.resumeID.isNull) {
      isLoading = false;
      setState(() {});
      return;
    }

    var oldResumeFetched = await DatabaseService().fetchSingleResume(widget.resumeID ?? 0);
    if (oldResumeFetched.isNull) {
      isLoading = false;
      oldResume = null;
      setState(() {});
      return;
    }

    oldResume = oldResumeFetched;
    isLoading = false;
    setState(() {});
    return;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(), // Loading indicator
              SizedBox(height: 16.0),
              Text('Loading...'), // Optional message
            ],
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // generate the resume
  generateResume(BuildContext ctx) async {
    showLoadingDialog(ctx);

    if (oldResume.isNull || oldResume.isUndefined) {
      var payload = getData();
      var generatedResume = await DatabaseService().generateResume(
        payload,
        widget.templateName ?? '',
      );
      // ignore: use_build_context_synchronously
      hideLoadingDialog(ctx);
      // ignore: use_build_context_synchronously
      ctx.pushRoute(ViewResume(resumeID: generatedResume?.id ?? 0));
    } else {
      var payload = getData();
      await DatabaseService().updateResume(payload, oldResume?.id ?? 0);
      // ignore: use_build_context_synchronously
      hideLoadingDialog(ctx);
      // ignore: use_build_context_synchronously
      ctx.pushRoute(ViewResume(resumeID: oldResume?.id ?? 0));
    }
  }

  @override
  void initState() {
    super.initState();

    fetchResume().then((value) {
      if (widget.resumeID.isDefinedAndNotNull) {
        canShowCourses = true;
        addCourse();
      }

      if (widget.resumeID.isDefinedAndNotNull) {
        canShowInternship = true;
        addInternship();
      }

      if (widget.resumeID.isDefinedAndNotNull) {
        canShowHobbies = true;
        addHobbies();
      }

      if (widget.resumeID.isDefinedAndNotNull) {
        canShowLanguage = true;
        addLanguage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          child: BackButtonApp(onPressed: () {
            context.popRoute(CvMakerRoute(resumeID: widget.resumeID, templateName: widget.templateName));
          }),
        ),
        Positioned(bottom: 30, left: 1, width: 450, child: Image.asset('assets/add-name-image.png', fit: BoxFit.cover)),
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
                    child: const Text('Build Your Future Now', style: TextStyle(fontSize: 45, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                    child: const Text(
                      "You made a great selection! Now let's build your resume for greater future",
                      style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                  PersonalDetailSection(
                    key: personalDetailSection,
                    title: personalDetailTitle,
                    description: personalDetailDescription,
                    resume: oldResume?.resume,
                  ),
                  ProfessionalSummary(
                    key: professionSection,
                    title: professionalSummeryTitle,
                    description: professionalSummeryDescription,
                    resume: oldResume?.resume,
                  ),
                  EmploymentHistorySection(
                    key: employmentHis,
                    title: employmentHisTitle,
                    description: employmentHisDescription,
                    resume: oldResume?.resume,
                  ),
                  EducationSection(
                    key: educationSection,
                    title: educationSectionTitle,
                    description: educationSectionDescription,
                    resume: oldResume?.resume,
                  ),
                  WebsiteLinkSection(
                    key: websiteLinksSection,
                    title: websiteLinkTitle,
                    description: websiteLinkDescription,
                    resume: oldResume?.resume,
                  ),
                  SkillSection(
                    key: skillsSection,
                    title: skillTitle,
                    description: skillDescription,
                    resume: oldResume?.resume,
                  ),
                  ...restOfElements,
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
                                  onPressed: !canShowInternship
                                      ? () {
                                          if (mounted) {
                                            setState(() {
                                              canShowInternship = !canShowInternship;
                                            });
                                            addInternship();
                                          }
                                        }
                                      : null,
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
                                  onPressed: !canShowCourses
                                      ? () {
                                          if (mounted) {
                                            setState(() {
                                              canShowCourses = !canShowCourses;
                                            });
                                            addCourse();
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
                                  onPressed: !canShowLanguage
                                      ? () {
                                          if (mounted) {
                                            setState(() {
                                              canShowLanguage = !canShowLanguage;
                                            });
                                            addLanguage();
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
                                  onPressed: !canShowHobbies
                                      ? () {
                                          if (mounted) {
                                            setState(() {
                                              canShowHobbies = !canShowHobbies;
                                            });
                                            addHobbies();
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
