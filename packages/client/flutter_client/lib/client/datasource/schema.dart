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
  ADD_FAVORITE,
  REMOVE_FAVORITE,
  DELETE_USER,
  UPDATE_USER,
  SUBSCRIPTION_STATUS_START_LISTENING,
  CANCEL_SUBSCRIPTION,
  ADD_DEFAULT_TEMPLATE,
  REMOVE_DEFAULT_TEMPLATE,
  REFRESH_TRANSACTION
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
enum MutationModelIdentifier { FEEDBACK, USER, TRANSACTION, SUBSCRIPTION, TEMPLATE, FAVORITE, SUBSCRIPTION_PLAN }

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

///
///
///
/// User
class User implements Network<User> {
  String email;
  String fullName;
  String? profilePicture;
  String timeZone;
  String reference;
  String userName;
  bool isEmailVerified;
  bool isDeleted;

  // Default value
  double fileUploadProgress = 0.00;
  Uint8List? profilePictureFile;
  String? profilePictureFileName;

  User({
    required this.email,
    required this.fullName,
    required this.profilePicture,
    required this.timeZone,
    required this.reference,
    required this.userName,
    required this.isEmailVerified,
    required this.isDeleted,
  });

  static User fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return User.fromRecord(data);
  }

  static User fromRecord(Map<String, dynamic> record) {
    String parsedEmail = record['email'].toString();
    String parsedFullName = record['fullName'].toString();
    String? parsedProfilePicture = record['profilePicture']?.toString();
    String parsedTimeZone = record['timeZone'].toString();
    String parsedReference = record['reference'].toString();
    String parsedUserName = record['userName'].toString();
    bool parsedIsEmailVerified = bool.parse(record['isEmailVerified'].toString());
    bool parsedIsDeleted = bool.parse(record['isDeleted'].toString());

    return User(
      email: parsedEmail,
      fullName: parsedFullName,
      profilePicture: parsedProfilePicture,
      timeZone: parsedTimeZone,
      reference: parsedReference,
      userName: parsedUserName,
      isEmailVerified: parsedIsEmailVerified,
      isDeleted: parsedIsDeleted,
    );
  }

  @override
  String toJson() {
    return jsonEncode(toRecord());
  }

  @override
  Map<String, dynamic> toRecord() {
    return {
      'email': email,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'timeZone': timeZone,
      'reference': reference,
      'userName': userName,
      'isEmailVerified': isEmailVerified,
      'isDeleted': isDeleted,
    };
  }

  @override
  User deepCopy() {
    return User.fromRecord(toRecord());
  }

  // Profile picture upload
  Future<void> uploadProfilePicture(Function(double progress) onProgress, Function(dynamic error) onError) async {
    try {
      fileUploadProgress = 50.00;
      onProgress(fileUploadProgress);
      ApiResponse response = await singleCall(NetworkMediaApi().uploadProfilePicture(profilePictureFile, profilePictureFileName ?? '${const Uuid().v4()}.jpg'));
      fileUploadProgress = 100;
      profilePicture = (response.data as ApiMutationSuccess).message;
      onProgress(fileUploadProgress);
    } catch (e) {
      onError(e);
    }
  }
}

///
///
///
/// User's Subscription
class UserSubscription implements Network<UserSubscription> {
  int id;
  String subscriptionID;
  String subscriptionLink;
  String planName;
  bool isActive;
  DateTime expireOn;
  DateTime activatedOn;
  String cycle;
  double discount;
  double basePrice;
  DateTime createdAt;
  DateTime updatedAt;

  UserSubscription({
    required this.id,
    required this.subscriptionID,
    required this.subscriptionLink,
    required this.planName,
    required this.isActive,
    required this.expireOn,
    required this.activatedOn,
    required this.cycle,
    required this.discount,
    required this.basePrice,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserSubscription fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return UserSubscription.fromRecord(data);
  }

  static UserSubscription fromRecord(Map<String, dynamic> record) {
    int parsedId = int.parse(record['id'].toString());
    String parsedSubscriptionID = record['subscriptionID'].toString();
    String parsedSubscriptionLink = record['subscriptionLink'].toString();
    String parsedPlanName = record['planName'].toString();
    bool parsedIsActive = bool.parse(record['isActive'].toString());
    DateTime parsedExpireOn = DateTime.parse(record['expireOn']);
    DateTime parsedActivatedOn = DateTime.parse(record['activatedOn']);
    String parsedCycle = record['cycle'].toString();
    double parsedDiscount = double.parse(record['discount'].toString());
    double parsedBasePrice = double.parse(record['basePrice'].toString());
    DateTime parsedCreatedAt = DateTime.parse(record['createdAt']);
    DateTime parsedUpdatedAt = DateTime.parse(record['updatedAt']);

    return UserSubscription(
      id: parsedId,
      subscriptionID: parsedSubscriptionID,
      subscriptionLink: parsedSubscriptionLink,
      planName: parsedPlanName,
      isActive: parsedIsActive,
      expireOn: parsedExpireOn,
      activatedOn: parsedActivatedOn,
      cycle: parsedCycle,
      discount: parsedDiscount,
      basePrice: parsedBasePrice,
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
      'subscriptionID': subscriptionID,
      'subscriptionLink': subscriptionLink,
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
  }

  @override
  UserSubscription deepCopy() {
    return UserSubscription.fromRecord(toRecord());
  }
}

///
///
/// User's transaction
class UserTransaction implements Network<UserTransaction> {
  int id;
  String orderId;
  int amount;
  int amountPaid;
  int amountDue;
  String currency;
  String status;
  bool isInternational;
  String method;
  String templateName;
  double templatePrice;
  DateTime createdAt;
  DateTime updatedAt;

  UserTransaction({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.status,
    required this.isInternational,
    required this.method,
    required this.templateName,
    required this.templatePrice,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserTransaction fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return UserTransaction.fromRecord(data);
  }

  static UserTransaction fromRecord(Map<String, dynamic> record) {
    int parsedId = int.parse(record['id'].toString());
    String parsedOrderId = record['orderId'].toString();
    int parsedAmount = int.parse(record['amount'].toString());
    int parsedAmountPaid = int.parse(record['amountPaid'].toString());
    int parsedAmountDue = int.parse(record['amountDue'].toString());
    String parsedCurrency = record['currency'].toString();
    String parsedStatus = record['status'].toString();
    bool parsedIsInternational = bool.parse(record['isInternational'].toString());
    String parsedMethod = record['method'].toString();
    String parsedTemplateName = record['templateName'].toString();
    double parsedTemplatePrice = double.parse(record['templatePrice'].toString());
    DateTime parsedCreatedAt = DateTime.parse(record['createdAt']);
    DateTime parsedUpdatedAt = DateTime.parse(record['updatedAt']);

    return UserTransaction(
      id: parsedId,
      orderId: parsedOrderId,
      amount: parsedAmount,
      amountPaid: parsedAmountPaid,
      amountDue: parsedAmountDue,
      currency: parsedCurrency,
      status: parsedStatus,
      isInternational: parsedIsInternational,
      method: parsedMethod,
      templateName: parsedTemplateName,
      templatePrice: parsedTemplatePrice,
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
      'orderId': orderId,
      'amount': amount,
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'currency': currency,
      'status': status,
      'isInternational': isInternational,
      'method': method,
      'templateName': templateName,
      'templatePrice': templatePrice,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  @override
  UserTransaction deepCopy() {
    return UserTransaction.fromRecord(toRecord());
  }
}

///
///
///
/// Application template
class Template implements Network<Template> {
  int id;
  String name;
  String displayName;
  String displayDescription;
  double price; // Price in paisa
  String previewImgUrl;
  DateTime createdAt;
  DateTime updatedAt;

  // Default value
  bool isMyFavourite = false;
  bool isMyDefault = false;

  Template({
    required this.id,
    required this.name,
    required this.displayName,
    required this.displayDescription,
    required this.price,
    required this.previewImgUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  static Template fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return Template.fromRecord(data);
  }

  static Template fromRecord(Map<String, dynamic> record) {
    int parsedId = int.parse(record['id'].toString());
    String parsedName = record['name'].toString();
    String parsedDisplayName = record['displayName'].toString();
    String parsedDisplayDescription = record['displayDescription'].toString();
    double parsedPrice = double.parse(record['price'].toString());
    String parsedPreviewImgUrl = record['previewImgUrl'].toString();
    DateTime parsedCreatedAt = DateTime.parse(record['createdAt']);
    DateTime parsedUpdatedAt = DateTime.parse(record['updatedAt']);

    return Template(
      id: parsedId,
      name: parsedName,
      displayName: parsedDisplayName,
      displayDescription: parsedDisplayDescription,
      price: parsedPrice,
      previewImgUrl: parsedPreviewImgUrl,
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
      'displayName': displayName,
      'displayDescription': displayDescription,
      'price': price,
      'previewImgUrl': previewImgUrl,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  @override
  Template deepCopy() {
    return Template.fromRecord(toRecord());
  }
}

///
///
/// Subscription
class Subscription implements Network<Subscription> {
  int id;
  String planID;
  String name;
  double price;
  String period;
  int interval;
  String currency;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Subscription({
    required this.id,
    required this.planID,
    required this.name,
    required this.price,
    required this.period,
    required this.interval,
    required this.currency,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  static Subscription fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return Subscription.fromRecord(data);
  }

  static Subscription fromRecord(Map<String, dynamic> record) {
    int parsedId = int.parse(record['id'].toString());
    String parsedPlanID = record['planID'].toString();
    String parsedName = record['name'].toString();
    double parsedPrice = double.parse(record['price'].toString());
    String parsedPeriod = record['period'].toString();
    int parsedInterval = int.parse(record['interval'].toString());
    String parsedCurrency = record['currency'].toString();
    String parsedDescription = record['description'].toString();
    DateTime parsedCreatedAt = DateTime.parse(record['createdAt']);
    DateTime parsedUpdatedAt = DateTime.parse(record['updatedAt']);

    return Subscription(
      id: parsedId,
      planID: parsedPlanID,
      name: parsedName,
      price: parsedPrice,
      period: parsedPeriod,
      interval: parsedInterval,
      currency: parsedCurrency,
      description: parsedDescription,
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
      'planID': planID,
      'name': name,
      'price': price,
      'period': period,
      'interval': interval,
      'currency': currency,
      'description': description,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  @override
  Subscription deepCopy() {
    return Subscription.fromRecord(toRecord());
  }
}
