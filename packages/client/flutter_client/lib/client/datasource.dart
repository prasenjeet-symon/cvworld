import 'dart:convert';
import 'dart:io';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'city': city,
      'description': description
    };

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
    var jsonData = {
      'job': job,
      'employer': employer,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'city': city,
      'description': description
    };

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
    var jsonData = {
      'course': course,
      'institution': institution,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String()
    };

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
    return Skills(json['skill'], json['level']);
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
    return Languages(json['language'], json['level']);
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

  toJson() {
    var jsonData = {'imageUrl': imageUrl, 'pdfUrl': pdfUrl};
    return jsonData;
  }

  factory ResumeLink.fromJson(Map<String, dynamic> json) {
    return ResumeLink(json['imageUrl'], json['pdfUrl']);
  }
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

  toJson() {
    var jsonData = {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'resumeRow': resumeRow.toJson(),
      'resume': resume.toJson(),
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

class IsLoggedIn {
  final String userId;
  final String email;
  final bool isAdmin;

  IsLoggedIn(this.userId, this.email, this.isAdmin);

  factory IsLoggedIn.fromJson(Map<String, dynamic> json) {
    return IsLoggedIn(json['userId'], json['email'], json['isAdmin']);
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
      json['imageUrl'],
      json['pdfUrl'],
      json['id'],
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
      json['id'],
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
      'dateOfBirth': toUtcJsonDateTimeFromDateTime(dateOfBirth),
      'createdAt': toUtcJsonDateTimeFromDateTime(createdAt),
      'updatedAt': toUtcJsonDateTimeFromDateTime(updatedAt),
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
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
      json['id'],
      json['planName'],
      json['isActive'],
      DateTime.parse(json['expireOn']),
      DateTime.parse(json['activatedOn']),
      json['cycle'],
      json['discount'],
      json['basePrice'],
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
  // profilePicture
  final String profilePicture;
  // reference
  final String reference;
  // updatedAt
  final DateTime updatedAt;
  // subscription
  final UserSubscription subscription;

  User(
    this.id,
    this.createdAt,
    this.email,
    this.fullName,
    this.profilePicture,
    this.reference,
    this.updatedAt,
    this.subscription,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      DateTime.parse(json['createdAt']),
      json['email'],
      json['fullName'],
      DatabaseService().publicResource(json['profilePicture']),
      json['reference'],
      DateTime.parse(json['updatedAt']),
      UserSubscription.fromJson(json['subscription']),
    );
  }

  toJson() {
    var jsonData = {
      'id': id,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'email': email,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'reference': reference,
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'subscription': subscription.toJson(),
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
    return DeleteDocuments(json['id']);
  }

  toJson() {
    var jsonData = {'id': id};
    return jsonData;
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

    if (token.isNull) {
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
  String origin = 'http://localhost:8080';
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
    addUpdateUserDetailsRoute =
        Uri.parse('$origin/server/api/add_update_user_details');
    userDetailsRoute = Uri.parse('$origin/server/api/user_details');
    addUpdateUserSkillRoute =
        Uri.parse('$origin/server/api/add_update_user_skill');
    deleteUserSkillRoute = Uri.parse('$origin/server/api/delete_user_skill');
    userSkillsRoute = Uri.parse('$origin/server/api/user_skills');
    getUserHobbyRoute = Uri.parse('$origin/server/api/get_user_hobby');
    addUpdateUserHobbyRoute =
        Uri.parse('$origin/server/api/add_update_user_hobby');
    deleteUserHobbyRoute = Uri.parse('$origin/server/api/delete_user_hobby');
    getUserProfessionalSummaryRoute =
        Uri.parse('$origin/server/api/get_user_professional_summary');
    addUpdateUserProfessionalSummaryRoute =
        Uri.parse('$origin/server/api/add_update_user_professional_summary');
    deleteUserProfessionalSummaryRoute =
        Uri.parse('$origin/server/api/delete_user_professional_summary');
    getUserLanguagesRoute = Uri.parse('$origin/server/api/get_user_languages');
    addUpdateUserLanguageRoute =
        Uri.parse('$origin/server/api/add_update_user_language');
    deleteUserLanguageRoute =
        Uri.parse('$origin/server/api/delete_user_language');
    getUserCoursesRoute = Uri.parse('$origin/server/api/get_user_courses');
    addUpdateUserCourseRoute =
        Uri.parse('$origin/server/api/add_update_user_course');
    deleteUserCourseRoute = Uri.parse('$origin/server/api/delete_user_course');
    getUserEducationsRoute =
        Uri.parse('$origin/server/api/get_user_educations');
    addUpdateUserEducationRoute =
        Uri.parse('$origin/server/api/add_update_user_education');
    deleteUserEducationRoute =
        Uri.parse('$origin/server/api/delete_user_education');
    getUserEmploymentHistoriesRoute =
        Uri.parse('$origin/server/api/get_user_employment_histories');
    addUpdateUserEmploymentHistoryRoute =
        Uri.parse('$origin/server/api/add_update_user_employment_history');
    deleteUserEmploymentHistoryRoute =
        Uri.parse('$origin/server/api/delete_user_employment_history');
    getUserInternshipsRoute =
        Uri.parse('$origin/server/api/get_user_internships');
    addUpdateUserInternshipRoute =
        Uri.parse('$origin/server/api/add_update_user_internship');
    deleteUserInternshipRoute =
        Uri.parse('$origin/server/api/delete_user_internship');
    getUserLinksRoute = Uri.parse('$origin/server/api/get_user_links');
    addUpdateUserLinkRoute =
        Uri.parse('$origin/server/api/add_update_user_link');
    deleteUserLinkRoute = Uri.parse('$origin/server/api/delete_user_link');
    getUserSubscriptionRoute =
        Uri.parse('$origin/server/api/get_user_subscription');
    addUpdateUserSubscriptionRoute =
        Uri.parse('$origin/server/api/add_update_user_subscription');
    deleteUserSubscriptionRoute =
        Uri.parse('$origin/server/api/delete_user_subscription');
    updateUserProfilePictureRoute =
        Uri.parse('$origin/server/api/media/update_user_profile_picture');
    getUserRoute = Uri.parse('$origin/server/api/get_user');
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

    var response = await client.post(generateResumeRoute,
        body: json.encode({'resume': payload, 'isDummy': 'no'}));
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

    var response = await client.post(addUpdateUserDetailsRoute,
        body: json.encode({'personalDetails': payload}));

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

    var response = await client.post(addUpdateUserSkillRoute,
        body: json.encode({"skill": payload}));

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

    var response =
        await client.post(deleteUserSkillRoute, body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
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

    var response = await client.post(addUpdateUserHobbyRoute,
        body: json.encode({"hobby": payload}));

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

    var response =
        await client.post(deleteUserHobbyRoute, body: json.encode(payload));

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
      var responseData =
          UserProfessionalSummary.fromJson(json.decode(response.body));
      client.dispose();
      return responseData;
    } else {
      print(response.body);
      if (kDebugMode) {
        print('Something went wrong while fetching user professional summary');
      }

      client.dispose();
      return null;
    }
  }

  // add_update_user_professional_summary
  Future<UserProfessionalSummary?> addUpdateUserProfessionalSummary(
      UserProfessionalSummary userProfessionalSummary) async {
    var payload = userProfessionalSummary.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserProfessionalSummaryRoute,
        body: json.encode({"professionalSummary": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData =
          UserProfessionalSummary.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print(
            'Something went wrong while adding/update user professional summary');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_professional_summary
  Future<DeleteDocuments?> deleteUserProfessionalSummary(
      DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserProfessionalSummaryRoute,
        body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
      var finalData =
          responseData.map((e) => UserLanguage.fromJson(e)).toList();
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

    var response = await client.post(addUpdateUserLanguageRoute,
        body: json.encode({"language": payload}));

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

    var response =
        await client.post(deleteUserLanguageRoute, body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
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

    var response = await client.post(addUpdateUserCourseRoute,
        body: json.encode({'course': payload}));

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

    var response =
        await client.post(deleteUserCourseRoute, body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
      var finalData =
          responseData.map((e) => UserEducation.fromJson(e)).toList();
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
  Future<UserEducation?> addUpdateUserEducation(
      UserEducation userEducation) async {
    var payload = userEducation.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserEducationRoute,
        body: json.encode({"education": payload}));

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

    var response =
        await client.post(deleteUserEducationRoute, body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
      var finalData =
          responseData.map((e) => UserEmployment.fromJson(e)).toList();

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
  Future<UserEmployment?> addUpdateUserEmploymentHistory(
      UserEmployment userEmployment) async {
    var payload = userEmployment.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserEmploymentHistoryRoute,
        body: json.encode({"employmentHistory": payload}));

    if (response.statusCode == 200) {
      client.dispose();
      var responseData = UserEmployment.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print(
            'Something went wrong while adding/update user employment history');
      }

      client.dispose();
      return null;
    }
  }

  // delete_user_employment_history
  Future<DeleteDocuments?> deleteUserEmploymentHistory(
      DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserEmploymentHistoryRoute,
        body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
      var finalData =
          responseData.map((e) => UserInternship.fromJson(e)).toList();

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
  Future<UserInternship?> addUpdateUserInternship(
      UserInternship userInternship) async {
    var payload = userInternship.toJson();

    var client = JwtClient();

    var response = await client.post(addUpdateUserInternshipRoute,
        body: json.encode({"internship": payload}));

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

    var response = await client.post(deleteUserInternshipRoute,
        body: json.encode(payload));

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
      var responseData = (json.decode(response.body) as List<dynamic>);
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

    var response = await client.post(addUpdateUserLinkRoute,
        body: json.encode({"link": payload}));

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

    var response =
        await client.post(deleteUserLinkRoute, body: json.encode(payload));

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
  Future<UserSubscription?> addUpdateUserSubscription(
      UserSubscription userSubscription) async {
    var payload = userSubscription.toJson();
    var client = JwtClient();

    var response = await client.post(addUpdateUserSubscriptionRoute,
        body: json.encode({"subscription": payload}));

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
  Future<DeleteDocuments?> deleteUserSubscription(
      DeleteDocuments delete) async {
    var payload = delete.toJson();
    var client = JwtClient();

    var response = await client.post(deleteUserSubscriptionRoute,
        body: json.encode(payload));

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

  // media/update_user_profile_picture receive a file
  Future<User?> updateUserProfilePicture(
    File file,
  ) async {
    // multi part request
    var multipartRequest =
        http.MultipartRequest('POST', updateUserProfilePictureRoute);
    multipartRequest.files
        .add(await http.MultipartFile.fromPath('file', file.path));

    var response =
        await http.Response.fromStream(await multipartRequest.send());

    if (response.statusCode == 200) {
      var user = await fetchUser();
      return user;
    } else {
      if (kDebugMode) {
        print('Something went wrong while updating user profile picture');
      }

      return null;
    }
  }
}
