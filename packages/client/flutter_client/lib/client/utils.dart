// a function to determine the page width given the context
import 'dart:convert';
import 'dart:html';
import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

double pageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600
      ? MediaQuery.of(context).size.width * 0.7
      : MediaQuery.of(context).size.width;
}

int flexNumber(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600 ? 1 : 0;
}

class EmploymentHistory {
  final String job;
  final String employer;
  final DateTime startDate;
  final DateTime endDate;
  final String city;
  final String description;

  EmploymentHistory(
    this.job,
    this.employer,
    this.startDate,
    this.endDate,
    this.city,
    this.description,
  );

  toJson() {
    var jsonData = {
      'job': job,
      'employer': employer,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'city': city,
      'description': description
    };

    return jsonData;
  }
}

class Education {
  final String school;
  final DateTime startDate;
  final DateTime endDate;
  final String degree;
  final String city;
  final String description;

  Education(
    this.school,
    this.startDate,
    this.endDate,
    this.degree,
    this.city,
    this.description,
  );

  toJson() {
    var jsonData = {
      'school': school,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'degree': degree,
      'city': city,
      'description': description,
    };

    return jsonData;
  }
}

class Internship {
  final String job;
  final String employer;
  final DateTime startDate;
  final DateTime endDate;
  final String city;
  final String description;

  Internship(
    this.job,
    this.employer,
    this.startDate,
    this.endDate,
    this.city,
    this.description,
  );

  toJson() {
    var jsonData = {
      'job': job,
      'employer': employer,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'city': city,
      'description': description
    };

    return jsonData;
  }
}

class Courses {
  final String course;
  final String institution;
  final DateTime startDate;
  final DateTime endDate;

  Courses(
    this.course,
    this.institution,
    this.startDate,
    this.endDate,
  );

  toJson() {
    var jsonData = {
      'course': course,
      'institution': institution,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String()
    };

    return jsonData;
  }
}

class Details {
  final String email;
  final String phone;
  final String country;
  final String city;
  final String address;
  final String postalCode;
  final String drivingLicense;
  final String nationality;
  final String placeOfBirth;
  final DateTime dateOfBirth;

  Details(
    this.email,
    this.phone,
    this.country,
    this.city,
    this.address,
    this.postalCode,
    this.drivingLicense,
    this.nationality,
    this.placeOfBirth,
    this.dateOfBirth,
  );

  toJson() {
    var jsonData = {
      'email': email,
      'phone': phone,
      'country': country,
      'city': city,
      'address': address,
      'postalCode': postalCode,
      'drivingLicense': drivingLicense,
      'nationality': nationality,
      'placeOfBirth': placeOfBirth,
      'dateOfBirth': dateOfBirth.toIso8601String()
    };

    return jsonData;
  }
}

class Links {
  final String title;
  final String url;

  Links(
    this.title,
    this.url,
  );

  toJson() {
    var jsonData = {'title': title, 'url': url};
    return jsonData;
  }
}

class Skills {
  final String skill;
  final double level;

  Skills(
    this.skill,
    this.level,
  );

  toJson() {
    var jsonData = {'skill': skill, 'level': level};
    return jsonData;
  }
}

class Languages {
  final String language;
  final double level;

  Languages(
    this.language,
    this.level,
  );

  toJson() {
    var jsonData = {'language': language, 'level': level};
    return jsonData;
  }
}

class Resume {
  final String name;
  final String profession;
  final String profile;
  final List<EmploymentHistory> employmentHistory;
  final List<Education> education;
  final List<Internship> internship;
  final List<Courses> courses;
  final Details details;
  final String hobbies;
  final List<Links> links;
  final List<Languages> languages;
  final List<Skills> skills;

  Resume(
    this.name,
    this.profession,
    this.profile,
    this.employmentHistory,
    this.education,
    this.internship,
    this.courses,
    this.details,
    this.hobbies,
    this.links,
    this.languages,
    this.skills,
  );

  factory Resume.fromJson(Map<String, dynamic> json) {
    List<EmploymentHistory> employmentHistory =
        (json['employmentHistory'] as List<dynamic>)
            .map((e) => EmploymentHistory(
                e['job'] as String,
                e['employer'] as String,
                DateTime.parse(e['startDate'] as String),
                DateTime.parse(e['endDate'] as String),
                e['city'] as String,
                e['description'] as String))
            .toList();

    List<Education> education = (json['education'] as List<dynamic>)
        .map((e) => Education(
            e['school'] as String,
            DateTime.parse(e['startDate'] as String),
            DateTime.parse(e['endDate'] as String),
            e['degree'] as String,
            e['city'] as String,
            e['description'] as String))
        .toList();

    List<Internship> internship = (json['internship'] as List<dynamic>)
        .map((e) => Internship(
            e['job'] as String,
            e['employer'] as String,
            DateTime.parse(e['startDate'] as String),
            DateTime.parse(e['endDate'] as String),
            e['city'] as String,
            e['description'] as String))
        .toList();

    List<Courses> courses = (json['courses'] as List<dynamic>)
        .map((e) => Courses(
            e['course'] as String,
            e['institution'] as String,
            DateTime.parse(e['startDate'] as String),
            DateTime.parse(e['endDate'] as String)))
        .toList();

    dynamic detailJson = json['details'];

    Details details = Details(
        detailJson['email'],
        detailJson['phone'],
        detailJson['country'],
        detailJson['city'],
        detailJson['address'],
        detailJson['postalCode'],
        detailJson['drivingLicense'],
        detailJson['nationality'],
        detailJson['placeOfBirth'],
        DateTime.parse(detailJson['dateOfBirth']));

    List<Links> links = (json['links'] as List<dynamic>)
        .map((e) => Links(e['title'], e['url']))
        .toList();

    List<Languages> languages = (json['languages'] as List<dynamic>)
        .map((e) => Languages(e['language'], e['level']))
        .toList();

    List<Skills> skills = (json['skills'] as List<dynamic>)
        .map((e) => Skills(e['skill'], e['level']))
        .toList();

    return Resume(
      json['name'],
      json['profession'],
      json['profile'],
      employmentHistory,
      education,
      internship,
      courses,
      details,
      json['hobbies'],
      links,
      languages,
      skills,
    );
  }

  toJson() {
    var jsonData = {
      'name': name,
      'profession': profession,
      'profile': profile,
      'employmentHistory': employmentHistory.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'internship': internship.map((e) => e.toJson()).toList(),
      'courses': courses.map((e) => e.toJson()).toList(),
      'details': details.toJson(),
      'links': links.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'hobbies': hobbies,
      'languages': languages.map((e) => e.toJson()).toList(),
    };

    return jsonData;
  }
}

class ResumeLink {
  final String imageUrl;
  final String pdfUrl;

  ResumeLink(this.imageUrl, this.pdfUrl);
}

class GeneratedResume {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Resume resumeRow;
  final ResumeLink resume;

  GeneratedResume(
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.resumeRow,
    this.resume,
  );

  factory GeneratedResume.fromJson(Map<String, dynamic> json) {
    return GeneratedResume(
      json['id'],
      json['userId'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
      Resume.fromJson(json['resumeRow']),
      ResumeLink(DatabaseService().publicResource(json['resume']['imageUrl']),
          DatabaseService().publicResource(json['resume']['pdfUrl'])),
    );
  }
}

class SignUpSignInWithEmailAndPassword {
  final String token;

  SignUpSignInWithEmailAndPassword(this.token);

  factory SignUpSignInWithEmailAndPassword.fromJson(Map<String, dynamic> json) {
    return SignUpSignInWithEmailAndPassword(json['token']);
  }
}

class IsLoggedIn {
  final String userId;
  final String email;
  final bool isAdmin;

  IsLoggedIn(this.userId, this.email, this.isAdmin);

  factory IsLoggedIn.fromJson(Map<String, dynamic> json) {
    return IsLoggedIn(json['userId'], json['email'], json['isAdmin']);
  }
}

class GenerateNewResume {
  final String imageUrl;
  final String pdfUrl;
  final int id;

  GenerateNewResume(this.imageUrl, this.pdfUrl, this.id);

  factory GenerateNewResume.fromJson(Map<String, dynamic> json) {
    return GenerateNewResume(
      json['imageUrl'],
      json['pdfUrl'],
      json['id'],
    );
  }
}

class JwtClient extends http.BaseClient {
  late final String jwtToken;
  late final http.Client _inner;

  JwtClient() {
    _inner = http.Client();
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'JWT');
    if (token.isUndefinedOrNull) {
      if (kDebugMode) {
        print('No JWT found!');
      }

      return null;
    } else {
      return token;
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    jwtToken = await getToken() as String;
    request.headers['Authorization'] = 'Bearer $jwtToken';
    request.headers['Content-Type'] = 'application/json';
    return _inner.send(request);
  }

  dispose() {
    _inner.close();
  }
}

class DatabaseService {
  String origin = 'http://localhost:3001';
  late Uri authRoute;
  late Uri apiRoute;
  late Uri signInRoute;
  late Uri signUpRoute;
  late Uri allResumeRoute;
  late Uri singleResumeRoute;
  late Uri isLoggedInRoute;
  late Uri generateResumeRoute;

  DatabaseService() {
    authRoute = Uri.parse('$origin/server/auth');
    apiRoute = Uri.parse('$origin/server/api');
    signInRoute =
        Uri.parse('$origin/server/auth/sign_in_with_email_and_password');
    signUpRoute =
        Uri.parse('$origin/server/auth/sign_up_with_email_and_password');
    allResumeRoute = Uri.parse('$origin/server/api/generated_resumes');
    singleResumeRoute = Uri.parse('$origin/server/api/generated_resume');
    isLoggedInRoute = Uri.parse('$origin/server/auth/session');
    generateResumeRoute = Uri.parse('$origin/server/api/generate');
  }

  publicResource(String path) {
    return '$origin/$path';
  }

  Future<bool> isAuthenticated() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'JWT');
    if (token.isNull) {
      return false;
    } else {
      return true;
    }
  }

  /// Sign in the user using the email and password
  Future<SignUpSignInWithEmailAndPassword?> signInUserWithEmailAndPassword(
      String email, String password) async {
    // Prepare the request body
    var requestBody = {'email': email, 'password': password};
    // Make a POST request with the request body
    var response = await http.post(signInRoute, body: requestBody);
    if (response.statusCode == 200) {
      // POST request successful, parse the response into MyDataModel
      var responseData =
          SignUpSignInWithEmailAndPassword.fromJson(json.decode(response.body));
      // set the JWT
      const storage = FlutterSecureStorage();
      await storage.write(key: 'JWT', value: responseData.token);
      return responseData;
    } else {
      // POST request failed
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }
    }

    return null;
  }

  /// Sign up the user with email and password
  Future<SignUpSignInWithEmailAndPassword?> signUpUserWithEmailAndPassword(
      String email, String password, String name) async {
    var requestBody = {'email': email, 'password': password, 'name': name};
    var response = await http.post(signUpRoute, body: requestBody);
    if (response.statusCode == 200) {
      var responseData =
          SignUpSignInWithEmailAndPassword.fromJson(json.decode(response.body));
      const storage = FlutterSecureStorage();
      await storage.write(key: 'JWT', value: responseData.token);
      return responseData;
    } else {
      // POST request failed
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }
    }
    return null;
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'JWT');
    if (token.isUndefinedOrNull) {
      if (kDebugMode) {
        print('No JWT found!');
      }

      return null;
    } else {
      return token;
    }
  }

  /// Fetch all the generated resumes of the user
  Future<List<GeneratedResume>?> fetchAllGeneratedResumeOfUser() async {
    var client = JwtClient();
    var response = await client.post(allResumeRoute);

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      var responseData = ((decodedJson['generatedResumes']) as List<dynamic>);
      var finalData =
          responseData.map((e) => GeneratedResume.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while fetching all resume');
      }
    }

    return null;
  }

  /// Fetch single resume
  Future<GeneratedResume?> fetchSingleResume(int resumeId) async {
    var client = JwtClient();
    var payload = {'resumeId': resumeId};
    var response =
        await client.post(singleResumeRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      var responseData =
          GeneratedResume.fromJson(decodedData['generatedResume']);

      client.dispose();
      return responseData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while fetching single resume');
      }
    }
    return null;
  }

  /// Is logged in
  Future<IsLoggedIn?> fetchSession() async {
    var payload = {};
    var response = await http.post(isLoggedInRoute, body: payload);
    if (response.statusCode == 200) {
      var responseData = IsLoggedIn.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching is logged in');
      }
      return null;
    }
  }

  /// Generate the resume
  Future<GenerateNewResume?> generateResume(Resume resume) async {
    var payload = resume.toJson();
    var client = JwtClient();
    print('done');
    var response = await client.post(generateResumeRoute,
        body: json.encode({'resume': payload, 'isDummy': 'no'}));
    if (response.statusCode == 200) {
      client.dispose();
      print('done 1');
      var responseData = GenerateNewResume.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while generating resume');
      }
      client.dispose();
      return null;
    }
  }
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var canNavigate = await DatabaseService().isAuthenticated();
    if (!canNavigate) {
      router.navigateNamed('/signin');
      return;
    } else {
      resolver.next(canNavigate);
    }
  }
}

void downloadFile(String url, String fileName) {
  final anchor = AnchorElement(href: url);
  anchor.download = fileName;
  anchor.target = '_blank';

  anchor.click();
}

Future<void> logOutUser(BuildContext context) async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'JWT');
  // ignore: use_build_context_synchronously
  context.navigateNamedTo('/signin');
}

class BackButtonApp extends StatelessWidget {
  final void Function() onPressed;

  const BackButtonApp({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 15)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          SizedBox(width: 8.0),
          Text(
            'Back',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
