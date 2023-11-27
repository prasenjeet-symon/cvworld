import 'dart:convert';
import 'dart:io';

import 'package:cvworld/client/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' show FlutterSecureStorage;

import 'package:http/http.dart' as http;

import '../config.dart';

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
    var jsonData = {'job': job, 'employer': employer, 'startDate': startDate.toUtc().toIso8601String(), 'endDate': endDate.toUtc().toIso8601String(), 'city': city, 'description': description};
    return jsonData;
  }

  // factory fromJson
  factory EmploymentHistory.fromJson(Map<String, dynamic> json) {
    return EmploymentHistory(
      json['job'],
      json['employer'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      json['city'],
      json['description'],
    );
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
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'degree': degree,
      'city': city,
      'description': description,
    };

    return jsonData;
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      json['school'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      json['degree'],
      json['city'],
      json['description'],
    );
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
    var jsonData = {'job': job, 'employer': employer, 'startDate': startDate.toUtc().toIso8601String(), 'endDate': endDate.toUtc().toIso8601String(), 'city': city, 'description': description};
    return jsonData;
  }

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      json['job'],
      json['employer'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      json['city'],
      json['description'],
    );
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
    var jsonData = {'course': course, 'institution': institution, 'startDate': startDate.toUtc().toIso8601String(), 'endDate': endDate.toUtc().toIso8601String()};
    return jsonData;
  }

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      json['course'],
      json['institution'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
    );
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
      'dateOfBirth': dateOfBirth.toUtc().toIso8601String()
    };

    return jsonData;
  }

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      json['email'],
      json['phone'],
      json['country'],
      json['city'],
      json['address'],
      json['postalCode'],
      json['drivingLicense'],
      json['nationality'],
      json['placeOfBirth'],
      DateTime.parse(json['dateOfBirth']),
    );
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

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(json['title'], json['url']);
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

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(json['skill'], double.parse(json['level'].toString()));
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

  factory Languages.fromJson(Map<String, dynamic> json) {
    return Languages(json['language'], double.parse(json['level'].toString()));
  }
}

class Resume {
  final String profilePicture;
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
    this.profilePicture,
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
    List<EmploymentHistory> employmentHistory = json['employmentHistory'] != null ? List.from(json['employmentHistory']).map((e) => EmploymentHistory.fromJson(e)).toList() : [];
    List<Education> education = json['education'] != null ? List.from(json['education']).map((e) => Education.fromJson(e)).toList() : [];
    List<Internship> internship = json['internship'] != null ? List.from(json['internship']).map((e) => Internship.fromJson(e)).toList() : [];
    List<Courses> courses = json['courses'] != null ? List.from(json['courses']).map((e) => Courses.fromJson(e)).toList() : [];

    dynamic detailJson = json['details'];
    Details details = Details.fromJson(detailJson);

    List<Links> links = json['links'] != null ? List.from(json['links']).map((e) => Links.fromJson(e)).toList() : [];
    List<Languages> languages = json['languages'] != null ? List.from(json['languages']).map((e) => Languages.fromJson(e)).toList() : [];
    List<Skills> skills = json['skills'] != null ? List.from(json['skills']).map((e) => Skills.fromJson(e)).toList() : [];

    return Resume(
      json['profilePicture'] != null ? DatabaseService().publicResource(json['profilePicture']) : '',
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
      'profilePicture': profilePicture,
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

  toJson() {
    var jsonData = {'imageUrl': imageUrl, 'pdfUrl': pdfUrl};
    return jsonData;
  }

  factory ResumeLink.fromJson(Map<String, dynamic> json) {
    return ResumeLink(DatabaseService().publicResource(json['imageUrl']), DatabaseService().publicResource(json['pdfUrl']));
  }
}

class GeneratedResume {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Resume resume;
  final ResumeLink resumeLink;
  final String templateName;

  GeneratedResume(
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.resume,
    this.resumeLink,
    this.templateName,
  );

  factory GeneratedResume.fromJson(Map<String, dynamic> json) {
    return GeneratedResume(
      int.parse(json['id'].toString()),
      int.parse(json['userId'].toString()),
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
      Resume.fromJson(json['resume']),
      ResumeLink.fromJson(json),
      json['templateName'],
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'resume': resume.toJson(),
      'imageUrl': resumeLink.imageUrl,
      'pdfUrl': resumeLink.pdfUrl,
      'templateName': templateName
    };

    return jsonData;
  }
}

class SignUpSignInWithEmailAndPassword {
  final String token;

  SignUpSignInWithEmailAndPassword(this.token);

  factory SignUpSignInWithEmailAndPassword.fromJson(Map<String, dynamic> json) {
    return SignUpSignInWithEmailAndPassword(json['token']);
  }

  toJson() {
    var jsonData = {'token': token};
    return jsonData;
  }
}

// sign in / sign up with google

class IsLoggedIn {
  final String userId;
  final String email;
  final bool isAdmin;

  IsLoggedIn(this.userId, this.email, this.isAdmin);

  factory IsLoggedIn.fromJson(Map<String, dynamic> json) {
    return IsLoggedIn(json['userId'], json['email'], bool.parse(json['isAdmin'].toString()));
  }

  toJson() {
    var jsonData = {'userId': userId, 'email': email, 'isAdmin': isAdmin};
    return jsonData;
  }
}

class GenerateNewResume {
  final String imageUrl;
  final String pdfUrl;
  final int id;

  GenerateNewResume(this.imageUrl, this.pdfUrl, this.id);

  factory GenerateNewResume.fromJson(Map<String, dynamic> json) {
    return GenerateNewResume(
      DatabaseService().publicResource(json['imageUrl']),
      DatabaseService().publicResource(json['pdfUrl']),
      int.parse(json['id'].toString()),
    );
  }

  toJson() {
    var jsonData = {'imageUrl': imageUrl, 'pdfUrl': pdfUrl, 'id': id};
    return jsonData;
  }
}

// for user details
class UserDetails {
  final int id;
  // profession
  final String profession;
  // name
  final String name;
  // email
  final String email;
  // phone
  final String phone;
  // country
  final String country;
  // city
  final String city;
  // address
  final String address;
  // postalCode
  final String postalCode;
  // drivingLicense
  final String drivingLicense;
  // nationality
  final String nationality;
  // placeOfBirth
  final String placeOfBirth;
  // dateOfBirth
  final DateTime dateOfBirth;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserDetails(
    this.id,
    this.profession,
    this.name,
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
    this.createdAt,
    this.updatedAt,
  );

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      int.parse(json['id'].toString()),
      json['profession'],
      json['name'],
      json['email'],
      json['phone'],
      json['country'],
      json['city'],
      json['address'],
      json['postalCode'],
      json['drivingLicense'],
      json['nationality'],
      json['placeOfBirth'],
      DateTime.parse(json['dateOfBirth']),
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'profession': profession,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'city': city,
      'address': address,
      'postalCode': postalCode,
      'drivingLicense': drivingLicense,
      'nationality': nationality,
      'placeOfBirth': placeOfBirth,
      'dateOfBirth': dateOfBirth.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// For the user skill
class UserSkill {
  // id
  final int id;
  // skill
  final String skill;
  // level
  final double level;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserSkill(
    this.id,
    this.skill,
    this.level,
    this.createdAt,
    this.updatedAt,
  );

  factory UserSkill.fromJson(Map<String, dynamic> json) {
    return UserSkill(
      int.parse(json['id'].toString()),
      json['skill'],
      double.parse(json['level'].toString()),
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'skill': skill,
      'level': level,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user hobby
class UserHobby {
  // id
  final int id;
  // hobby
  final String hobby;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserHobby(
    this.id,
    this.hobby,
    this.createdAt,
    this.updatedAt,
  );

  factory UserHobby.fromJson(Map<String, dynamic> json) {
    return UserHobby(
      int.parse(json['id'].toString()),
      json['hobby'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'hobby': hobby,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user professional summary
class UserProfessionalSummary {
  // id
  final int id;
  // profile
  final String profile;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserProfessionalSummary(
    this.id,
    this.profile,
    this.createdAt,
    this.updatedAt,
  );

  factory UserProfessionalSummary.fromJson(Map<String, dynamic> json) {
    return UserProfessionalSummary(
      int.parse(json['id'].toString()),
      json['profile'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'profile': profile,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user language
class UserLanguage {
  // id
  final int id;
  // language
  final String language;
  // level
  final double level;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserLanguage(
    this.id,
    this.language,
    this.level,
    this.createdAt,
    this.updatedAt,
  );

  factory UserLanguage.fromJson(Map<String, dynamic> json) {
    return UserLanguage(
      int.parse(json['id'].toString()),
      json['language'],
      double.parse(json['level'].toString()),
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'language': language,
      'level': level,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user course
class UserCourse {
  // id
  final int id;
  // course
  final String course;
  // institution
  final String institution;
  // startDate
  final DateTime startDate;
  // endDate
  final DateTime endDate;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserCourse(
    this.id,
    this.course,
    this.institution,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  );

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      int.parse(json['id'].toString()),
      json['course'],
      json['institution'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'course': course,
      'institution': institution,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user education
class UserEducation {
  // id
  final int id;
  // school
  final String school;
  // startDate
  final DateTime startDate;
  // endDate
  final DateTime endDate;
  // degree
  final String degree;
  // city
  final String city;
  // description
  final String description;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserEducation(
    this.id,
    this.school,
    this.startDate,
    this.endDate,
    this.degree,
    this.city,
    this.description,
    this.createdAt,
    this.updatedAt,
  );

  factory UserEducation.fromJson(Map<String, dynamic> json) {
    return UserEducation(
      int.parse(json['id'].toString()),
      json['school'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      json['degree'],
      json['city'],
      json['description'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'school': school,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'degree': degree,
      'city': city,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user employment history
class UserEmployment {
  // id
  final int id;
  // job
  final String job;
  // employer
  final String employer;
  // startDate
  final DateTime startDate;
  // endDate
  final DateTime endDate;
  // city
  final String city;
  // description
  final String description;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserEmployment(
    this.id,
    this.job,
    this.employer,
    this.startDate,
    this.endDate,
    this.city,
    this.description,
    this.createdAt,
    this.updatedAt,
  );

  factory UserEmployment.fromJson(Map<String, dynamic> json) {
    return UserEmployment(
      int.parse(json['id'].toString()),
      json['job'],
      json['employer'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      json['city'],
      json['description'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'job': job,
      'employer': employer,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'city': city,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user internship
class UserInternship {
  // id
  final int id;
  // job
  final String job;
  // employer
  final String employer;
  // startDate
  final DateTime startDate;
  // endDate
  final DateTime endDate;
  // city
  final String city;
  // description
  final String description;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserInternship(
    this.id,
    this.job,
    this.employer,
    this.startDate,
    this.endDate,
    this.city,
    this.description,
    this.createdAt,
    this.updatedAt,
  );

  factory UserInternship.fromJson(Map<String, dynamic> json) {
    return UserInternship(
      int.parse(json['id'].toString()),
      json['job'],
      json['employer'],
      DateTime.parse(json['startDate']),
      DateTime.parse(json['endDate']),
      json['city'],
      json['description'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'job': job,
      'employer': employer,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'city': city,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user link
class UserLink {
  // id
  final int id;
  // title
  final String title;
  // url
  final String url;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserLink(
    this.id,
    this.title,
    this.url,
    this.createdAt,
    this.updatedAt,
  );

  factory UserLink.fromJson(Map<String, dynamic> json) {
    return UserLink(
      int.parse(json['id'].toString()),
      json['title'],
      json['url'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'title': title,
      'url': url,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user subscription
class UserSubscription {
  // id
  final int id;
  // planName
  final String planName;
  // isActive
  final bool isActive;
  // expireOn
  final DateTime expireOn;
  // activatedOn
  final DateTime activatedOn;
  // cycle
  final String cycle;
  // discount
  final double discount;
  // basePrice
  final double basePrice;
  // createdAt
  final DateTime createdAt;
  // updatedAt
  final DateTime updatedAt;

  UserSubscription(
    this.id,
    this.planName,
    this.isActive,
    this.expireOn,
    this.activatedOn,
    this.cycle,
    this.discount,
    this.basePrice,
    this.createdAt,
    this.updatedAt,
  );

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      int.parse(json['id'].toString()),
      json['planName'],
      bool.parse(json['isActive'].toString()),
      DateTime.parse(json['expireOn']),
      DateTime.parse(json['activatedOn']),
      json['cycle'],
      double.parse(json['discount'].toString()),
      double.parse(json['basePrice'].toString()),
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'planName': planName,
      'isActive': isActive,
      'expireOn': expireOn.toUtc().toIso8601String(),
      'activatedOn': activatedOn.toUtc().toIso8601String(),
      'cycle': cycle,
      'discount': discount,
      'basePrice': basePrice,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };

    return jsonData;
  }
}

// for the user
class User {
  // id
  final int id;
  // createdAt
  final DateTime createdAt;
  // email
  final String email;
  // fullName
  final String fullName;
  // timeZone
  final String timeZone;
  // profilePicture
  final String profilePicture;
  // reference
  final String reference;
  // updatedAt
  final DateTime updatedAt;
  // subscription
  final UserSubscription? subscription;

  User(
    this.id,
    this.createdAt,
    this.email,
    this.fullName,
    this.timeZone,
    this.profilePicture,
    this.reference,
    this.updatedAt,
    this.subscription,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      int.parse(json['id'].toString()),
      DateTime.parse(json['createdAt']),
      json['email'],
      json['fullName'],
      json['timeZone'],
      DatabaseService().publicResource(json['profilePicture']),
      json['reference'],
      DateTime.parse(json['updatedAt']),
      json['subscription'] == null ? null : UserSubscription.fromJson(json['subscription']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'email': email,
      'fullName': fullName,
      'timeZone': timeZone,
      'profilePicture': profilePicture,
      'reference': reference,
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'subscription': subscription?.toJson(),
    };

    return jsonData;
  }
}

// Delete documents
class DeleteDocuments {
  // id
  final int id;

  DeleteDocuments(this.id);

  factory DeleteDocuments.fromJson(Map<String, dynamic> json) {
    return DeleteDocuments(int.parse(json['id'].toString()));
  }

  toJson() {
    var jsonData = {'id': id};
    return jsonData;
  }
}

// Contact us
class ContactUs {
  // id
  final int id;
  // createdAt
  final DateTime createdAt;
  // email
  final String email;
  // isResolved
  final bool isResolved;
  // message
  final String message;
  // name
  final String name;
  // updatedAt
  final DateTime updatedAt;
  // phone
  final String phone;

  ContactUs(
    this.id,
    this.createdAt,
    this.email,
    this.isResolved,
    this.message,
    this.name,
    this.updatedAt,
    this.phone,
  );

  factory ContactUs.fromJson(Map<String, dynamic> json) {
    return ContactUs(
      int.parse(json['id'].toString()),
      DateTime.parse(json['createdAt']),
      json['email'],
      bool.parse(json['isResolved'].toString()),
      json['message'],
      json['name'],
      DateTime.parse(json['updatedAt']),
      json['phone'],
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'email': email,
      'isResolved': isResolved,
      'message': message,
      'name': name,
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'phone': phone,
    };

    return jsonData;
  }
}

// For is bought response
class IsBought {
  final bool isBought;

  IsBought(this.isBought);

  factory IsBought.fromJson(Map<String, dynamic> json) {
    return IsBought(bool.parse(json['isBought'].toString()));
  }

  toJson() {
    var jsonData = {'isBought': isBought};
    return jsonData;
  }
}

// For the template marketplace
class TemplateMarketPlace {
  final int id;
  final String name;
  final String displayName;
  final String displayDescription;
  final double price;
  final String previewImgUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFree;
  final bool isBought;

  TemplateMarketPlace({
    required this.id,
    required this.name,
    required this.displayName,
    required this.displayDescription,
    required this.price,
    required this.previewImgUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isFree,
    required this.isBought,
  });

  factory TemplateMarketPlace.fromJson(Map<String, dynamic> json) {
    return TemplateMarketPlace(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      displayName: json['displayName'],
      displayDescription: json['displayDescription'],
      price: double.parse(json['price'].toString()),
      previewImgUrl: DatabaseService().publicResource(json['previewImgUrl']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isFree: bool.parse(json['isFree'].toString()),
      isBought: bool.parse(json['isBought'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'displayDescription': displayDescription,
      'price': price,
      'previewImgUrl': previewImgUrl,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'isFree': isFree,
      'isBought': isBought,
    };
  }
}

// For the order
class TemplateOrder {
  final String id;
  final String entity;
  final double amount;
  final double amountPaid;
  final double amountDue;
  final String currency;
  final String? receipt;
  final String? offerId;
  final String status;
  final int attempts;
  final Map<String, dynamic> notes;
  final DateTime createdAt;

  TemplateOrder({
    required this.id,
    required this.entity,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    this.receipt,
    this.offerId,
    required this.status,
    required this.attempts,
    required this.notes,
    required this.createdAt,
  });

  factory TemplateOrder.fromJson(Map<String, dynamic> json) {
    return TemplateOrder(
      id: json['id'],
      entity: json['entity'],
      amount: double.parse(json['amount'].toString()),
      amountPaid: double.parse(json['amount_paid'].toString()),
      amountDue: double.parse(json['amount_due'].toString()),
      currency: json['currency'],
      receipt: json['receipt'],
      offerId: json['offer_id'],
      status: json['status'],
      attempts: int.parse(json['attempts'].toString()),
      notes: json['notes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity': entity,
      'amount': amount,
      'amount_paid': amountPaid,
      'amount_due': amountDue,
      'currency': currency,
      'receipt': receipt,
      'offer_id': offerId,
      'status': status,
      'attempts': attempts,
      'notes': notes,
      'created_at': createdAt.millisecondsSinceEpoch ~/ 1000,
    };
  }
}

class SubscriptionPlan {
  final int id;
  final String planID;
  final String name;
  final double price;
  final String period;
  final int interval;
  final String currency;
  final String description;
  final int adminId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.planID,
    required this.name,
    required this.price,
    required this.period,
    required this.interval,
    required this.currency,
    required this.description,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: int.parse(json['id'].toString()),
      planID: json['planID'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      period: json['period'],
      interval: int.parse(json['interval'].toString()),
      currency: json['currency'],
      description: json['description'],
      adminId: int.parse(json['adminId'].toString()),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planID': planID,
      'name': name,
      'price': price,
      'period': period,
      'interval': interval,
      'currency': currency,
      'description': description,
      'adminId': adminId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }
}

///
///
///
///
///
///
///
///
class JwtClient extends http.BaseClient {
  late final String jwtToken;
  late final http.Client _inner;

  JwtClient() {
    _inner = http.Client();
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'JWT');

    if (token == null) {
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

///
///
///
///
///
///
///
///
///
///
class DatabaseService {
  late String origin;
  late Uri authRoute;
  late Uri apiRoute;
  late Uri signInRoute;
  late Uri signUpRoute;
  late Uri allResumeRoute;
  late Uri singleResumeRoute;
  late Uri isLoggedInRoute;
  late Uri generateResumeRoute;
  // add_update_user_details
  late Uri addUpdateUserDetailsRoute;
  // user_details
  late Uri userDetailsRoute;
  // add_update_user_skill
  late Uri addUpdateUserSkillRoute;
  // delete_user_skill
  late Uri deleteUserSkillRoute;
  // user_skills
  late Uri userSkillsRoute;
  // get_user_hobby
  late Uri getUserHobbyRoute;
  // add_update_user_hobby
  late Uri addUpdateUserHobbyRoute;
  // delete_user_hobby
  late Uri deleteUserHobbyRoute;
  // get_user_professional_summary
  late Uri getUserProfessionalSummaryRoute;
  // add_update_user_professional_summary
  late Uri addUpdateUserProfessionalSummaryRoute;
  // delete_user_professional_summary
  late Uri deleteUserProfessionalSummaryRoute;
  // get_user_languages
  late Uri getUserLanguagesRoute;
  // add_update_user_language
  late Uri addUpdateUserLanguageRoute;
  // delete_user_language
  late Uri deleteUserLanguageRoute;
  // get_user_courses
  late Uri getUserCoursesRoute;
  // add_update_user_course
  late Uri addUpdateUserCourseRoute;
  // delete_user_course
  late Uri deleteUserCourseRoute;
  // get_user_educations
  late Uri getUserEducationsRoute;
  // add_update_user_education
  late Uri addUpdateUserEducationRoute;
  // delete_user_education
  late Uri deleteUserEducationRoute;
  // get_user_employment_histories
  late Uri getUserEmploymentHistoriesRoute;
  // add_update_user_employment_history
  late Uri addUpdateUserEmploymentHistoryRoute;
  // delete_user_employment_history
  late Uri deleteUserEmploymentHistoryRoute;
  // get_user_internships
  late Uri getUserInternshipsRoute;
  // add_update_user_internship
  late Uri addUpdateUserInternshipRoute;
  // delete_user_internship
  late Uri deleteUserInternshipRoute;
  // get_user_links
  late Uri getUserLinksRoute;
  // add_update_user_link
  late Uri addUpdateUserLinkRoute;
  // delete_user_link
  late Uri deleteUserLinkRoute;
  // get_user_subscription
  late Uri getUserSubscriptionRoute;
  // add_update_user_subscription
  late Uri addUpdateUserSubscriptionRoute;
  // delete_user_subscription
  late Uri deleteUserSubscriptionRoute;
  // update_user_profile_picture
  late Uri updateUserProfilePictureRoute;
  // get_user
  late Uri getUserRoute;
  // update_resume
  late Uri updateResumeRoute;
  // delete_resume
  late Uri deleteResumeRoute;
  // continue_with_google
  late Uri continueWithGoogleRoute;
  // server/api_public/contact_us
  late Uri contactUsRoute;
  // is_template_bought
  late Uri isTemplateBoughtRoute;
  // get_marketplace_templates
  late Uri getMarketplaceTemplatesRoute;
  // generate_order
  late Uri generateOrderRoute;
  // create_subscription
  late Uri createSubscriptionRoute;
  // cancel_subscription
  late Uri cancelSubscriptionRoute;
  // get_premium_plan
  late Uri getPremiumPlanRoute;
  // server/api/template/templt_p_1?token={{TOKEN}}
  late Uri getTemplateRoute;

  DatabaseService() {
    // const apiBaseUrl = 'https://native-humorous-mule.ngrok-free.app';
    // const localBaseUrl = 'http://localhost:8081';
    //origin = 'https://cvworld.me';
    origin = ApplicationConfiguration.API_URL;

    authRoute = Uri.parse('$origin/server/auth');
    apiRoute = Uri.parse('$origin/server/api');
    signInRoute = Uri.parse('$origin/server/auth/sign_in_with_email_and_password');
    signUpRoute = Uri.parse('$origin/server/auth/sign_up_with_email_and_password');
    allResumeRoute = Uri.parse('$origin/server/api/generated_resumes');
    singleResumeRoute = Uri.parse('$origin/server/api/generated_resume');
    isLoggedInRoute = Uri.parse('$origin/server/auth/session');
    generateResumeRoute = Uri.parse('$origin/server/api/generate');
    addUpdateUserDetailsRoute = Uri.parse('$origin/server/api/add_update_user_details');
    userDetailsRoute = Uri.parse('$origin/server/api/user_details');
    addUpdateUserSkillRoute = Uri.parse('$origin/server/api/add_update_user_skill');
    deleteUserSkillRoute = Uri.parse('$origin/server/api/delete_user_skill');
    userSkillsRoute = Uri.parse('$origin/server/api/user_skills');
    getUserHobbyRoute = Uri.parse('$origin/server/api/get_user_hobby');
    addUpdateUserHobbyRoute = Uri.parse('$origin/server/api/add_update_user_hobby');
    deleteUserHobbyRoute = Uri.parse('$origin/server/api/delete_user_hobby');
    getUserProfessionalSummaryRoute = Uri.parse('$origin/server/api/get_user_professional_summary');
    addUpdateUserProfessionalSummaryRoute = Uri.parse('$origin/server/api/add_update_user_professional_summary');
    deleteUserProfessionalSummaryRoute = Uri.parse('$origin/server/api/delete_user_professional_summary');
    getUserLanguagesRoute = Uri.parse('$origin/server/api/get_user_languages');
    addUpdateUserLanguageRoute = Uri.parse('$origin/server/api/add_update_user_language');
    deleteUserLanguageRoute = Uri.parse('$origin/server/api/delete_user_language');
    getUserCoursesRoute = Uri.parse('$origin/server/api/get_user_courses');
    addUpdateUserCourseRoute = Uri.parse('$origin/server/api/add_update_user_course');
    deleteUserCourseRoute = Uri.parse('$origin/server/api/delete_user_course');
    getUserEducationsRoute = Uri.parse('$origin/server/api/get_user_educations');
    addUpdateUserEducationRoute = Uri.parse('$origin/server/api/add_update_user_education');
    deleteUserEducationRoute = Uri.parse('$origin/server/api/delete_user_education');
    getUserEmploymentHistoriesRoute = Uri.parse('$origin/server/api/get_user_employment_histories');
    addUpdateUserEmploymentHistoryRoute = Uri.parse('$origin/server/api/add_update_user_employment_history');
    deleteUserEmploymentHistoryRoute = Uri.parse('$origin/server/api/delete_user_employment_history');
    getUserInternshipsRoute = Uri.parse('$origin/server/api/get_user_internships');
    addUpdateUserInternshipRoute = Uri.parse('$origin/server/api/add_update_user_internship');
    deleteUserInternshipRoute = Uri.parse('$origin/server/api/delete_user_internship');
    getUserLinksRoute = Uri.parse('$origin/server/api/get_user_links');
    addUpdateUserLinkRoute = Uri.parse('$origin/server/api/add_update_user_link');
    deleteUserLinkRoute = Uri.parse('$origin/server/api/delete_user_link');
    getUserSubscriptionRoute = Uri.parse('$origin/server/api/get_user_subscription');
    addUpdateUserSubscriptionRoute = Uri.parse('$origin/server/api/add_update_user_subscription');
    deleteUserSubscriptionRoute = Uri.parse('$origin/server/api/delete_user_subscription');
    updateUserProfilePictureRoute = Uri.parse('$origin/server/api/media/update_user_profile_picture');
    getUserRoute = Uri.parse('$origin/server/api/get_user');
    updateResumeRoute = Uri.parse('$origin/server/api/update_resume');
    deleteResumeRoute = Uri.parse('$origin/server/api/delete_resume');
    continueWithGoogleRoute = Uri.parse('$origin/server/auth/continue_with_google');
    contactUsRoute = Uri.parse('$origin/server/api_public/contact_us');
    isTemplateBoughtRoute = Uri.parse('$origin/server/api/is_template_bought');
    getMarketplaceTemplatesRoute = Uri.parse('$origin/server/api/get_marketplace_templates');
    generateOrderRoute = Uri.parse('$origin/server/api/generate_order');
    createSubscriptionRoute = Uri.parse('$origin/server/api/create_subscription');
    cancelSubscriptionRoute = Uri.parse('$origin/server/api/cancel_subscription');
    getPremiumPlanRoute = Uri.parse('$origin/server/api/get_premium_plan');
  }

  publicResource(String path) {
    // if http or https then just return
    if (path.startsWith('http') || path.startsWith('https')) {
      return path;
    }

    return '$origin/server/media/$path';
  }

  Future<bool> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'JWT');
    return true;
  }

  Future<bool> isAuthenticated() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'JWT');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isTutorialCompleted() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'IS_TUTORIAL_COMPLETED');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  void downloadAndSavePdf(String pdfUrl, BuildContext context) async {
    try {
      // Add the downloaded file to the device's media gallery (Android only)
      if (Platform.isAndroid) {
        await FileDownloader.downloadFile(
          url: pdfUrl,
          onDownloadCompleted: (String path) {
            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF file saved to gallery'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 5),
                margin: EdgeInsets.all(10),
                dismissDirection: DismissDirection.horizontal,
              ),
            );
          },
          onDownloadError: (errorMessage) {
            // Show an error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
                margin: const EdgeInsets.all(10),
                dismissDirection: DismissDirection.horizontal,
              ),
            );
          },
        );
      }
    } catch (e) {
      // Show an error message if there was an exception
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // set is tutorial completed
  Future<void> setTutorialCompleted() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'IS_TUTORIAL_COMPLETED', value: 'true');
  }

  /// Sign in the user using the email and password
  Future<SignUpSignInWithEmailAndPassword?> signInUserWithEmailAndPassword(String email, String password) async {
    // Prepare the request body
    var requestBody = {'email': email, 'password': password};
    // Make a POST request with the request body
    var response = await http.post(signInRoute, body: requestBody);
    if (response.statusCode == 200) {
      // POST request successful, parse the response into MyDataModel
      var responseData = SignUpSignInWithEmailAndPassword.fromJson(json.decode(response.body));
      // set the JWT
      const storage = FlutterSecureStorage();
      await storage.write(key: 'JWT', value: responseData.token);
      return responseData;
    } else {
      // POST request failed
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      if (response.statusCode == 400) {
        // All input field is required
        throw RequiredFieldException('All input fields are required');
      }

      if (response.statusCode == 402) {
        // no such user
        throw NoUserException('No such user');
      }

      if (response.statusCode == 403) {
        // wrong password
        throw WrongPasswordException('Wrong password');
      }
    }

    return null;
  }

  /// Sign up the user with email and password
  Future<SignUpSignInWithEmailAndPassword?> signUpUserWithEmailAndPassword(String email, String password, String name) async {
    var requestBody = {'email': email, 'password': password, 'name': name, 'timeZone': await getCurrentTimeZone()};
    var response = await http.post(signUpRoute, body: requestBody);

    if (response.statusCode == 200) {
      var responseData = SignUpSignInWithEmailAndPassword.fromJson(json.decode(response.body));
      const storage = FlutterSecureStorage();
      await storage.write(key: 'JWT', value: responseData.token);
      return responseData;
    } else {
      // POST request failed
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      if (response.statusCode == 400) {
        // All input fields are required
        throw RequiredFieldException('All input fields are required');
      }

      if (response.statusCode == 402) {
        // user is already registered
        throw UserAlreadyExistsException('User already exists');
      }

      // for the weak password
      if (response.statusCode == 403) {
        throw WeekPasswordException('Password is too weak');
      }

      return null;
    }
  }

  // continue with google
  Future<SignUpSignInWithEmailAndPassword?> continueWithGoogle(String googleToken) async {
    var response = await http.post(continueWithGoogleRoute, body: {'google_token': googleToken, 'timeZone': await getCurrentTimeZone()});
    if (response.statusCode == 200) {
      var responseData = SignUpSignInWithEmailAndPassword.fromJson(json.decode(response.body));
      const storage = FlutterSecureStorage();
      await storage.write(key: 'JWT', value: responseData.token);
      return responseData;
    } else {
      return null;
    }
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'JWT');
    if (token == null) {
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
      var responseData = List<Map<String, dynamic>>.from(decodedJson);
      var finalData = responseData.map((e) => GeneratedResume.fromJson(e)).toList();
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
    var response = await client.post(singleResumeRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      var responseData = GeneratedResume.fromJson(decodedData);

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
  Future<GenerateNewResume?> generateResume(Resume resume, String templateName) async {
    var payload = resume.toJson();
    var client = JwtClient();

    var response = await client.post(generateResumeRoute, body: json.encode({'templateName': templateName, 'resume': payload, 'isDummy': 'no'}));
    if (response.statusCode == 200) {
      client.dispose();

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

  // add_update_user_details
  Future<UserDetails?> addUpdateUserDetails(UserDetails userDetails) async {
    var payload = userDetails.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserDetailsRoute, body: json.encode({'personalDetails': payload}));

    if (response.statusCode == 200) {
      client.dispose();

      var responseData = UserDetails.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user details');
      }

      client.dispose();
      return null;
    }
  }

  // user_details
  Future<UserDetails?> fetchUserDetails() async {
    var client = JwtClient();

    var response = await client.post(userDetailsRoute);

    if (response.statusCode == 200) {
      var responseData = UserDetails.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user details');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_skill
  Future<UserSkill?> addUpdateUserSkill(UserSkill userSkill) async {
    var payload = userSkill.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserSkillRoute, body: json.encode({"skill": payload}));

    if (response.statusCode == 200) {
      client.dispose();

      var responseData = UserSkill.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user skill');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_skill
  Future<DeleteDocuments?> deleteUserSkill(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserSkillRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      client.dispose();
      return null;
    }
  }

  // user_skills
  Future<List<UserSkill>?> fetchUserSkills() async {
    var client = JwtClient();

    var response = await client.post(userSkillsRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserSkill.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user skills');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_hobby
  Future<UserHobby?> fetchUserHobby() async {
    var client = JwtClient();

    var response = await client.post(getUserHobbyRoute);
    if (response.statusCode == 200) {
      var responseData = UserHobby.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user hobbies');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_hobby
  Future<UserHobby?> addUpdateUserHobby(UserHobby userHobby) async {
    var payload = userHobby.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserHobbyRoute, body: json.encode({"hobby": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserHobby.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user hobbies');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_hobby
  Future<DeleteDocuments?> deleteUserHobby(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserHobbyRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user hobbies');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_professional_summary
  Future<UserProfessionalSummary?> fetchUserProfessionalSummary() async {
    var client = JwtClient();

    var response = await client.post(getUserProfessionalSummaryRoute);

    if (response.statusCode == 200) {
      var responseData = UserProfessionalSummary.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user professional summary');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_professional_summary
  Future<UserProfessionalSummary?> addUpdateUserProfessionalSummary(UserProfessionalSummary userProfessionalSummary) async {
    var payload = userProfessionalSummary.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserProfessionalSummaryRoute, body: json.encode({"professionalSummary": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserProfessionalSummary.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user professional summary');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_professional_summary
  Future<DeleteDocuments?> deleteUserProfessionalSummary(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserProfessionalSummaryRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user professional summary');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_languages
  Future<List<UserLanguage>?> fetchUserLanguages() async {
    var client = JwtClient();

    var response = await client.post(getUserLanguagesRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserLanguage.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user languages');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_language
  Future<UserLanguage?> addUpdateUserLanguage(UserLanguage userLanguage) async {
    var payload = userLanguage.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserLanguageRoute, body: json.encode({"language": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserLanguage.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user language');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_language
  Future<DeleteDocuments?> deleteUserLanguage(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserLanguageRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user language');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_courses
  Future<List<UserCourse>?> fetchUserCourses() async {
    var client = JwtClient();

    var response = await client.post(getUserCoursesRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserCourse.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user courses');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_course
  Future<UserCourse?> addUpdateUserCourse(UserCourse userCourse) async {
    var payload = userCourse.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserCourseRoute, body: json.encode({'course': payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserCourse.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user course');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_course
  Future<DeleteDocuments?> deleteUserCourse(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserCourseRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user course');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_educations
  Future<List<UserEducation>?> fetchUserEducations() async {
    var client = JwtClient();

    var response = await client.post(getUserEducationsRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserEducation.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user educations');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_education
  Future<UserEducation?> addUpdateUserEducation(UserEducation userEducation) async {
    var payload = userEducation.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserEducationRoute, body: json.encode({"education": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserEducation.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user education');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_education
  Future<DeleteDocuments?> deleteUserEducation(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();
    var response = await client.post(deleteUserEducationRoute, body: json.encode(payload));
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user education');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_employment_histories
  Future<List<UserEmployment>?> fetchUserEmploymentHistories() async {
    var client = JwtClient();
    var response = await client.post(getUserEmploymentHistoriesRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserEmployment.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user employment histories');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_employment_history
  Future<UserEmployment?> addUpdateUserEmploymentHistory(UserEmployment userEmployment) async {
    var payload = userEmployment.toJson();
    var client = JwtClient();
    var response = await client.post(addUpdateUserEmploymentHistoryRoute, body: json.encode({"employmentHistory": payload}));
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserEmployment.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user employment history');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_employment_history
  Future<DeleteDocuments?> deleteUserEmploymentHistory(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();
    var response = await client.post(deleteUserEmploymentHistoryRoute, body: json.encode(payload));
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user employment history');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_internships
  Future<List<UserInternship>?> fetchUserInternships() async {
    var client = JwtClient();
    var response = await client.post(getUserInternshipsRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserInternship.fromJson(e)).toList();

      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user internships');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_internship
  Future<UserInternship?> addUpdateUserInternship(UserInternship userInternship) async {
    var payload = userInternship.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserInternshipRoute, body: json.encode({"internship": payload}));
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserInternship.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user internship');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_internship
  Future<DeleteDocuments?> deleteUserInternship(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserInternshipRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user internship');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_links
  Future<List<UserLink>?> fetchUserLinks() async {
    var client = JwtClient();

    var response = await client.post(getUserLinksRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => UserLink.fromJson(e)).toList();

      client.dispose();
      return finalData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user links');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_link
  Future<UserLink?> addUpdateUserLink(UserLink userLink) async {
    var payload = userLink.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserLinkRoute, body: json.encode({"link": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserLink.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user link');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_link
  Future<DeleteDocuments?> deleteUserLink(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserLinkRoute, body: json.encode(payload));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user link');
      }

      client.dispose();
      return null;
    }
  }

  // get_user_subscription
  Future<UserSubscription?> fetchUserSubscription() async {
    var client = JwtClient();

    var response = await client.post(getUserSubscriptionRoute);
    if (response.statusCode == 200) {
      var responseData = UserSubscription.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user subscription');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_subscription
  Future<UserSubscription?> addUpdateUserSubscription(UserSubscription userSubscription) async {
    var payload = userSubscription.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserSubscriptionRoute, body: json.encode({"subscription": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserSubscription.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while adding/update user subscription');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_subscription
  Future<DeleteDocuments?> deleteUserSubscription(DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserSubscriptionRoute, body: json.encode(payload));
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting user subscription');
      }

      client.dispose();
      return null;
    }
  }

  // get_user
  Future<User?> fetchUser() async {
    var client = JwtClient();

    var response = await client.post(getUserRoute);
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = User.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while fetching user');
      }

      client.dispose();
      return null;
    }
  }

  Future<User?> updateUserProfilePicture(
    String fileName,
    Uint8List? imageBytes,
  ) async {
    try {
      if (imageBytes == null) {
        throw Exception('Image bytes are missing');
      }

      // Multi-part request
      var request = http.MultipartRequest('POST', updateUserProfilePictureRoute);

      // Create a multipart file from the bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'profilePicture',
        imageBytes,
        filename: fileName,
      );

      // Add the multipart file to the request
      request.files.add(multipartFile);

      // Get the bearer token from your JWT client
      var client = JwtClient();
      var bearerToken = await client.getToken();

      // Set the 'Authorization' header with the bearer token
      request.headers['Authorization'] = 'Bearer $bearerToken';

      print('Sending the request...');

      // Send the request and get the response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Received response with status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var user = await fetchUser(); // Implement fetchUser to get the updated user
        return user;
      } else {
        print('Failed to update user profile picture. Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during updating user profile picture: $e');
      return null;
    }
  }

  // update_resume
  Future<GeneratedResume?> updateResume(Resume resume, int id) async {
    var payload = resume.toJson();
    var client = JwtClient();

    var finalPayload = json.encode({'id': id, 'resume': payload});

    var response = await client.post(updateResumeRoute, body: finalPayload);
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = GeneratedResume.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while updating resume');
      }

      client.dispose();
      return null;
    }
  }

  // Delete resume
  Future<DeleteDocuments?> deleteResume(int id) async {
    var client = JwtClient();
    var payload = {'id': id};
    var response = await client.post(deleteResumeRoute, body: json.encode(payload));
    if (response.statusCode == 200) {
      client.dispose();
      var responseData = DeleteDocuments.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('Something went wrong while deleting resume');
      }

      client.dispose();
      return null;
    }
  }

  // server/api_public/contact_us
  Future<ContactUs?> contactUs(String name, String email, String message, String phone) async {
    var payload = {'name': name, 'email': email, 'message': message, 'phone': phone};

    var response = await http.post(contactUsRoute, body: (payload));
    if (response.statusCode == 200) {
      var responseData = ContactUs.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print(response.body);
      }

      if (kDebugMode) {
        print('Something went wrong while sending contact us');
      }

      return null;
    }
  }

  // isTemplateBoughtRoute
  Future<IsBought?> isTemplateBought(String templateName) async {
    var client = JwtClient();
    var response = await client.post(isTemplateBoughtRoute, body: json.encode({'templateName': templateName}));
    if (response.statusCode == 200) {
      var responseData = IsBought.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while checking if template is bought');
      }

      return null;
    }
  }

  // getMarketplaceTemplatesRoute
  Future<List<TemplateMarketPlace>?> getMarketplaceTemplates() async {
    var client = JwtClient();
    var response = await client.post(getMarketplaceTemplatesRoute);
    if (response.statusCode == 200) {
      var responseData = List<Map<String, dynamic>>.from(json.decode(response.body));
      var finalData = responseData.map((e) => TemplateMarketPlace.fromJson(e)).toList();
      client.dispose();
      return finalData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while fetching marketplace templates');
      }

      return null;
    }
  }

  // generateOrderRoute
  Future<TemplateOrder?> generateOrder(String nameOfTemplate) async {
    var client = JwtClient();
    var response = await client.post(generateOrderRoute, body: json.encode({'nameOfTemplate': nameOfTemplate}));
    if (response.statusCode == 200) {
      var responseData = TemplateOrder.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while generating order');
      }

      return null;
    }
  }

  // createSubscriptionRoute
  Future<String?> createSubscription(String planName) async {
    var client = JwtClient();
    var response = await client.post(createSubscriptionRoute, body: json.encode({'planName': planName}));
    if (response.statusCode == 200) {
      var responseData = DatabaseService().publicResource(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while creating subscription');
      }

      return null;
    }
  }

  // cancel_subscription
  Future<void> cancelSubscription() async {
    var client = JwtClient();
    var response = await client.post(cancelSubscriptionRoute);
    if (response.statusCode == 200) {
      client.dispose();
      return;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while canceling subscription');
      }

      return;
    }
  }

  // get_premium_plan
  Future<SubscriptionPlan?> getPremiumPlan() async {
    var client = JwtClient();
    var response = await client.post(getPremiumPlanRoute);
    if (response.statusCode == 200) {
      var responseData = SubscriptionPlan.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      client.dispose();
      if (kDebugMode) {
        print('Something went wrong while fetching premium plan');
      }

      return null;
    }
  }

  Future<Uri> buyTemplate(String templateName) async {
    var token = await getToken();
    if (token == null) {
      return Uri.parse('');
    }

    var url = Uri.parse('$origin/server/api/template/$templateName');

    // Create a new Map to hold the query parameters and include the 'token'
    var queryParams = {'token': token, 'hostName': '$origin/'};
    url = url.replace(queryParameters: queryParams);

    return url;
  }
}
