import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/make-cv-pages/courses-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/education-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/employment-history-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/hobbie-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/internship-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/language-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/personal-details-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/professional-summry-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/skills-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/website-links-section.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CVMakerLogic {
  final String educationSectionTitle = 'Education';
  final String educationSectionDescription = 'A varied education on your resume sums up the value that your learnings and background will bring to the job.';

  final String personalDetailTitle = 'Personal Details';
  final String personalDetailDescription = 'Fill in your personal details such as name, contact information, address, etc.';

  final String professionalSummeryTitle = 'Professional Summary';
  final String professionalSummeryDescription = 'Write 2-4 short & energetic sentences to interest the reader! Mention your role, experience & most importantly - your biggest achievements, best qualities, and skills.';

  final employmentHisTitle = 'Employment History';
  final String employmentHisDescription = 'Show your relevant experience (last 10 years). Use bullet points to note your achievements. If possible, use numbers/facts (Achieved X, measured by Y, by doing Z).';

  final String websiteLinkTitle = 'Websites & Social Links';
  final String websiteLinkDescription = 'You can add links to websites you want hiring managers to see! Perhaps it will be a link to your portfolio, LinkedIn profile, or personal website.';

  final String skillTitle = 'Skills';
  final String skillDescription = 'Choose 5 important skills that show you fit the position. Make sure they match the key skills mentioned in the job listing (especially when applying via an online system).';

  final String internshipTitle = 'Internship';
  final String internshipDescription = 'Include any relevant internships or training experiences you have had.';

  final String languageTitle = 'Languages';
  final String languageDescription = 'List any languages you are proficient in, along with your level of fluency.';

  final String hobbyTitle = 'Hobbies';
  final String hobbyDescription = 'List any hobbies you have.';

  final String courseTitle = 'Courses';
  final String courseDescription = 'List any courses you have taken.';

  final int? resumeID;
  final String? templateName;
  final Function setStateCallback;

  GeneratedResume? oldResume;
  bool isLoading = true;

  List<dynamic> restOfElements = [];

  CVMakerLogic(this.resumeID, this.templateName, this.setStateCallback);

  final GlobalKey<EducationSectionState> educationSectionKey = GlobalKey();
  final GlobalKey<CourseSectionState> courseSectionKey = GlobalKey();
  final GlobalKey<EmploymentHistorySectionState> employmentHisKey = GlobalKey();
  final GlobalKey<HobbiesSectionState> hobbiesSectionKey = GlobalKey();
  final GlobalKey<InternshipSectionState> internshipSectionKey = GlobalKey();
  final GlobalKey<LanguageSectionState> languageSectionKey = GlobalKey();
  final GlobalKey<PersonalDetailSectionState> personalDetailSectionKey = GlobalKey();
  final GlobalKey<ProfessionalSummaryState> professionSectionKey = GlobalKey();
  final GlobalKey<SkillSectionState> skillsSectionKey = GlobalKey();
  final GlobalKey<WebsiteLinkSectionState> websiteLinksSectionKey = GlobalKey();

  // add hobbies
  void addHobbies() {
    var hobbiesSectionIndex = restOfElements.indexWhere((element) => element is HobbiesSection);
    if (hobbiesSectionIndex == -1) {
      restOfElements.add(HobbiesSection(
        key: hobbiesSectionKey,
        title: hobbyTitle,
        description: hobbyDescription,
        resume: oldResume?.resume,
      ));
    }

    setStateCallback();
  }

  // add internship
  void addInternship() {
    var internshipSectionIndex = restOfElements.indexWhere((element) => element is InternshipSection);
    if (internshipSectionIndex == -1) {
      restOfElements.add(InternshipSection(
        key: internshipSectionKey,
        title: internshipTitle,
        description: internshipDescription,
        resume: oldResume?.resume,
      ));
    }

    setStateCallback();
  }

  // add CourseSection
  void addCourse() {
    var courseSectionIndex = restOfElements.indexWhere((element) => element is CourseSection);
    if (courseSectionIndex == -1) {
      restOfElements.add(CourseSection(
        key: courseSectionKey,
        title: courseTitle,
        description: courseDescription,
        resume: oldResume?.resume,
      ));

      setStateCallback();
    }
  }

  // add LanguageSection
  void addLanguage() {
    var languageSectionIndex = restOfElements.indexWhere((element) => element is LanguageSection);
    if (languageSectionIndex == -1) {
      restOfElements.add(LanguageSection(
        key: languageSectionKey,
        title: languageTitle,
        description: languageDescription,
        resume: oldResume?.resume,
      ));
    }

    setStateCallback();
  }

  // fetch the old resume for editing if applicable
  Future<void> fetchResume() async {
    isLoading = true;
    setStateCallback();

    try {
      if (resumeID != null && resumeID != 0) {
        var oldResumeFetched = await DatabaseService().fetchSingleResume(resumeID!);

        if (oldResumeFetched != null) {
          oldResume = oldResumeFetched;
        }
      }
    } catch (e) {
      // Handle any errors that occur during fetching the old resume
      if (kDebugMode) {
        print('Error fetching old resume: $e');
      }
    } finally {
      isLoading = false;
      setStateCallback();
    }
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

  Future<Resume> getData() async {
    // Get data from various sections or provide default values
    var employmentHistoryData = employmentHisKey.currentState?.getData() ?? [];
    var educationSectionData = educationSectionKey.currentState?.getData() ?? [];
    var internshipSectionData = internshipSectionKey.currentState?.getData() ?? [];
    var coursesSectionData = courseSectionKey.currentState?.getData() ?? [];
    var linksSectionData = websiteLinksSectionKey.currentState?.getData() ?? [];
    var languageSectionData = languageSectionKey.currentState?.getData() ?? [];
    var skillsSectionData = skillsSectionKey.currentState?.getData() ?? [];

    // Get extra info from PersonalDetailSection
    var extraInfo = personalDetailSectionKey.currentState?.getExtraData();

    // Get hobbies section data or an empty string if it's null
    var hobbiesSectionData = hobbiesSectionKey.currentState?.getData() ?? '';

    // Get professional data
    var professionalData = professionSectionKey.currentState?.getData();

    // Get details data
    var detailsData = personalDetailSectionKey.currentState?.getData();

    // Check for null values and handle them gracefully
    var name = extraInfo?['name'] ?? '';
    var profession = extraInfo?['profession'] ?? '';
    var profile = professionalData?['profile'] ?? '';
    var details = detailsData!; // Replace 'PersonalDetails()' with the default constructor of your 'PersonalDetails' class

    var user = await DatabaseService().fetchUser();
    var profilePicture = DatabaseService().publicResource(user!.profilePicture!) as String;

    // Create and return the Resume object
    return Resume(
      profilePicture,
      name,
      profession,
      profile,
      employmentHistoryData,
      educationSectionData,
      internshipSectionData,
      coursesSectionData,
      details,
      hobbiesSectionData,
      linksSectionData,
      languageSectionData,
      skillsSectionData,
    );
  }

  // generate the resume
  generateResume(BuildContext ctx) async {
    showLoadingDialog(ctx);
    int resumeID;

    try {
      var payload = await getData();

      if (oldResume == null) {
        var generatedResume = await DatabaseService().generateResume(
          payload,
          templateName ?? '',
        );

        resumeID = generatedResume?.id ?? 0;
      } else {
        await DatabaseService().updateResume(payload, oldResume?.id ?? 0);
        resumeID = oldResume?.id ?? 0;
      }

      // ignore: use_build_context_synchronously
      hideLoadingDialog(ctx);
      // ignore: use_build_context_synchronously
      ctx.pushNamed(
        RouteNames.dashboardViewResume,
        pathParameters: {"resumeID": resumeID.toString()},
      );
    } catch (err) {
      // Handle any errors
      if (kDebugMode) {
        print('Error generating resume: $err');
      }
    } finally {}
  }

  // init
  init() async {
    await fetchResume();
    if (oldResume != null) {
      addCourse();
      addInternship();
      addHobbies();
      addLanguage();
    }
  }

  // is internship visible
  bool isInternshipVisible() {
    var internshipSectionIndex = restOfElements.indexWhere((element) => element is InternshipSection);
    return internshipSectionIndex != -1;
  }

  // is hobbies visible
  bool isHobbiesVisible() {
    var hobbiesSectionIndex = restOfElements.indexWhere((element) => element is HobbiesSection);
    return hobbiesSectionIndex != -1;
  }

  // is language visible
  bool isLanguageVisible() {
    var languageSectionIndex = restOfElements.indexWhere((element) => element is LanguageSection);
    return languageSectionIndex != -1;
  }

  // is skills visible
  bool isSkillsVisible() {
    var skillsSectionIndex = restOfElements.indexWhere((element) => element is SkillSection);
    return skillsSectionIndex != -1;
  }

  // is education visible
  bool isEducationVisible() {
    var educationSectionIndex = restOfElements.indexWhere((element) => element is EducationSection);
    return educationSectionIndex != -1;
  }

  // is course visible
  bool isCourseVisible() {
    var courseSectionIndex = restOfElements.indexWhere((element) => element is CourseSection);
    return courseSectionIndex != -1;
  }

  // dispose
  void dispose() {}
}
