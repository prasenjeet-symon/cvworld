import 'dart:convert';
import 'dart:typed_data';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:uuid/uuid.dart';

import 'network.media.api.dart';

///
///
///
class ApplicationMutationData {
  final ApplicationMutationIdentifier identifier;
  final dynamic data;

  ApplicationMutationData(this.identifier, this.data);
}

///
///
///
///
enum ApplicationMutationIdentifier {
  CREATE_FEEDBACK,
  UPDATE_FEEDBACK,
}

///
///
///
///
enum MutationType {
  create,
  createMany,
  update,
  updateMany,
  delete,
  deleteMany,
}

///
///
///
///
class MutationModelData {
  final MutationModelIdentifier identifier;
  final dynamic data;
  final MutationType type;

  MutationModelData(this.identifier, this.data, this.type);
}

///
///
///
///
enum MutationModelIdentifier {
  FEEDBACK,
}

///
///
///
///
class ModelStore<T extends List> {
  final ModelStoreStatus status;
  final T data;

  ModelStore({
    required this.status,
    required this.data,
  });
}

///
///
///
///
enum ModelStoreStatus {
  booting,
  error,
  ready,
}

extension ModelStoreStatusExtension on ModelStoreStatus {
  String get name {
    switch (this) {
      case ModelStoreStatus.booting:
        return 'booting';
      case ModelStoreStatus.error:
        return 'error';
      case ModelStoreStatus.ready:
        return 'ready';
    }
  }

  static ModelStoreStatus fromName(String name) {
    switch (name) {
      case 'booting':
        return ModelStoreStatus.booting;
      case 'error':
        return ModelStoreStatus.error;
      case 'ready':
        return ModelStoreStatus.ready;
      default:
        return ModelStoreStatus.error;
    }
  }
}

///
///
///
///
///
abstract class Network<T> {
  String toJson();
  dynamic toRecord();
  T deepCopy();
}

class ApiMutationSuccess implements Network<ApiMutationSuccess> {
  final String message;

  ApiMutationSuccess({required this.message});

  static ApiMutationSuccess fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return ApiMutationSuccess.fromRecord(data);
  }

  static ApiMutationSuccess fromRecord(Map<String, dynamic> record) {
    String parsedMessage = record['message'].toString();

    return ApiMutationSuccess(message: parsedMessage);
  }

  @override
  String toJson() {
    return jsonEncode(toRecord());
  }

  @override
  Map<String, dynamic> toRecord() {
    return {
      'message': message,
    };
  }

  @override
  ApiMutationSuccess deepCopy() {
    return ApiMutationSuccess.fromRecord(toRecord());
  }
}

///
///
///
///
class ApiMutationError implements Network<ApiMutationError> {
  final String error;

  ApiMutationError({required this.error});

  static ApiMutationError fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return ApiMutationError.fromRecord(data);
  }

  static ApiMutationError fromRecord(Map<String, dynamic> record) {
    String parsedError = record['error'].toString();

    return ApiMutationError(error: parsedError);
  }

  @override
  String toJson() {
    return jsonEncode(toRecord());
  }

  @override
  Map<String, dynamic> toRecord() {
    return {
      'error': error,
    };
  }

  @override
  ApiMutationError deepCopy() {
    return ApiMutationError.fromRecord(toRecord());
  }
}

///
///
///
/// Authentication
class Authentication implements Network<Authentication> {
  final String token;
  final String userId;
  final String email;
  final String fullName;
  final String timeZone;
  final String? userName;

  Authentication({
    required this.token,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.timeZone,
    required this.userName,
  });

  static Authentication fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return Authentication.fromRecord(data);
  }

  static Authentication fromRecord(Map<String, dynamic> record) {
    String parsedToken = record['token'].toString();
    String parsedUserId = record['userId'].toString();
    String parsedEmail = record['email'].toString();
    String parsedFullName = record['fullName'].toString();
    String parsedTimeZone = record['timeZone'].toString();
    String? parsedUserName = record['userName']?.toString();

    return Authentication(token: parsedToken, userId: parsedUserId, email: parsedEmail, fullName: parsedFullName, timeZone: parsedTimeZone, userName: parsedUserName);
  }

  @override
  String toJson() {
    return jsonEncode(toRecord());
  }

  @override
  Map<String, dynamic> toRecord() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'fullName': fullName,
      'timeZone': timeZone,
      'userName': userName,
    };
  }

  @override
  Authentication deepCopy() {
    return Authentication.fromRecord(toRecord());
  }
}

///
///
///
/// Feedback
class Feedback implements Network<Feedback> {
  final int id;
  final String name;
  final String email;
  final String title;
  final String description;
  final String department;
  final bool isRegistered;
  final String identifier;
  String? attachment;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Default value
  double fileUploadProgress = 0.00;
  Uint8List? feedbackFile;
  String? feedbackFileName;

  Feedback({
    required this.id,
    required this.name,
    required this.email,
    required this.title,
    required this.description,
    required this.department,
    required this.isRegistered,
    required this.identifier,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  static Feedback fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);

    return Feedback.fromRecord(data);
  }

  static Feedback fromRecord(Map<String, dynamic> record) {
    int parsedId = int.parse(record['id'].toString());
    String parsedName = record['name'].toString();
    String parsedEmail = record['email'].toString();
    String parsedTitle = record['title'].toString();
    String parsedDescription = record['description'].toString();
    String parsedDepartment = record['department'].toString();
    bool parsedIsRegistered = bool.parse(record['isRegistered'].toString());
    String parsedIdentifier = record['identifier'].toString();
    String? parsedAttachment = record['attachment']?.toString();
    DateTime parsedCreatedAt = DateTime.parse(record['createdAt'].toString());
    DateTime parsedUpdatedAt = DateTime.parse(record['updatedAt'].toString());

    return Feedback(
      id: parsedId,
      name: parsedName,
      email: parsedEmail,
      title: parsedTitle,
      description: parsedDescription,
      department: parsedDepartment,
      isRegistered: parsedIsRegistered,
      identifier: parsedIdentifier,
      attachment: parsedAttachment,
      createdAt: parsedCreatedAt,
      updatedAt: parsedUpdatedAt,
    );
  }

  @override
  String toJson() {
    return jsonEncode(toRecord());
  }

  @override
  Map<String, dynamic> toRecord() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'title': title,
      'description': description,
      'department': department,
      'isRegistered': isRegistered,
      'identifier': identifier,
      'attachment': attachment,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  @override
  Feedback deepCopy() {
    return Feedback.fromRecord(toRecord());
  }

  /// File upload
  Future<void> uploadFile(Function(double progress) onProgress, Function(dynamic error) onError) async {
    try {
      fileUploadProgress = 0.00;
      onProgress(fileUploadProgress);
      ApiResponse response = await singleCall(NetworkMediaApi().uploadFeedbackFile(feedbackFile, feedbackFileName ?? '${const Uuid().v4()}.jpg'));
      fileUploadProgress = 100;
      attachment = (response.data as ApiMutationSuccess).message;
      onProgress(fileUploadProgress);
    } catch (e) {
      onError(e);
    }
  }
}
