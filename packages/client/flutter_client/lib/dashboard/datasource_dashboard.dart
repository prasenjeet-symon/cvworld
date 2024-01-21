import 'dart:convert';

import 'package:cvworld/client/datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class TokenModel {
  final String token;

  TokenModel(this.token);

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(json['token'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}

class TemplateModel {
  final String imageUrl;
  final int price;

  TemplateModel(this.imageUrl, this.price);

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      DatabaseService().publicResource(json['imageUrl']),
      int.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}

class UpdatePasswordResponse {
  final String message;

  UpdatePasswordResponse(this.message);

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponse(json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class BoughtTemplate {
  final int id;
  final String name;
  final double price; // in paisa
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String eventId;

  BoughtTemplate({
    required this.id,
    required this.name,
    required this.price,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.eventId,
  });

  factory BoughtTemplate.fromJson(Map<String, dynamic> json) {
    return BoughtTemplate(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      price: double.parse(json['price'].toString()),
      userId: int.parse(json['userId'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eventId: json['eventID'] as String,
    );
  }
}

class Subscription {
  final int id;
  final String subscriptionId;
  final String subscriptionLink;
  final String planName;
  final bool isActive;
  final DateTime expireOn;
  final DateTime activatedOn;
  final String cycle;
  final double discount; // in paisa
  final double basePrice; // In paisa
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    required this.id,
    required this.subscriptionId,
    required this.subscriptionLink,
    required this.planName,
    required this.isActive,
    required this.expireOn,
    required this.activatedOn,
    required this.cycle,
    required this.discount,
    required this.basePrice,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: int.parse(json['id'].toString()),
      subscriptionId: json['subscriptionID'] as String,
      subscriptionLink: json['subscriptionLink'] as String,
      planName: json['planName'] as String,
      isActive: bool.parse(json['isActive'].toString()),
      expireOn: DateTime.parse(json['expireOn'] as String),
      activatedOn: DateTime.parse(json['activatedOn'] as String),
      cycle: json['cycle'] as String,
      discount: double.parse(json['discount'].toString()),
      basePrice: double.parse(json['basePrice'].toString()),
      userId: int.parse(json['userId'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class User {
  final int id;
  final String email;
  final String fullName;
  final String timeZone;
  final String profilePicture;
  final String password;
  final String reference;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Subscription? subscription;
  final List<BoughtTemplate>? boughtTemplate; // Using the BoughtTemplate class

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.timeZone,
    required this.profilePicture,
    required this.password,
    required this.reference,
    required this.createdAt,
    required this.updatedAt,
    this.subscription,
    this.boughtTemplate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      timeZone: json['timeZone'] as String,
      profilePicture: DatabaseService().publicResource(json['profilePicture'] as String),
      password: json['password'],
      reference: json['reference'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      subscription: json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null,
      boughtTemplate: json['boughtTemplate'] != null ? (List.from(json['boughtTemplate'])).map((item) => BoughtTemplate.fromJson(item)).toList() : [],
    );
  }
}

class ContactUsMessage {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContactUsMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.isResolved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactUsMessage.fromJson(Map<String, dynamic> json) {
    return ContactUsMessage(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      message: json['message'] as String,
      isResolved: bool.parse(json['isResolved'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class ContactUsMessageUpdate {
  final bool isResolved;
  final int id;

  ContactUsMessageUpdate({
    required this.isResolved,
    required this.id,
  });

  factory ContactUsMessageUpdate.fromJson(Map<String, dynamic> json) {
    return ContactUsMessageUpdate(
      isResolved: bool.parse(json['isResolved'].toString()),
      id: int.parse(json['id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isResolved': isResolved,
      'id': id,
    };
  }
}

class TemplateTransaction {
  final int id;
  final int templateId;
  final String orderId;
  final int amount;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String status;
  final bool isInternational;
  final String method;
  final DateTime createdAt;
  final DateTime updatedAt;

  TemplateTransaction({
    required this.id,
    required this.templateId,
    required this.orderId,
    required this.amount,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.status,
    required this.isInternational,
    required this.method,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemplateTransaction.fromJson(Map<String, dynamic> json) {
    return TemplateTransaction(
      id: int.parse(json['id'].toString()),
      templateId: int.parse(json['templateId'].toString()),
      orderId: json['orderId'] as String,
      amount: int.parse(json['amount'].toString()),
      amountPaid: int.parse(json['amountPaid'].toString()), // in paisa
      amountDue: int.parse(json['amountDue'].toString()), // in paisa
      currency: json['currency'] as String, // INR
      status: json['status'] as String,
      isInternational: bool.parse(json['isInternational'].toString()),
      method: json['method'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateId': templateId,
      'orderId': orderId,
      'amount': amount,
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'currency': currency,
      'status': status,
      'isInternational': isInternational,
      'method': method,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }
}

enum PaymentMethod {
  CASH,
  CARD,
  UPI,
  WALLET,
  NET_BANKING,
}

class CardPaymentSubscription {
  final int id;
  final String last4;
  final String name;
  final String network;
  final CardType type;
  final bool isInternational;
  final int transactionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardPaymentSubscription({
    required this.id,
    required this.last4,
    required this.name,
    required this.network,
    required this.type,
    required this.isInternational,
    required this.transactionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CardPaymentSubscription.fromJson(Map<String, dynamic> json) {
    return CardPaymentSubscription(
      id: int.parse(json['id'].toString()),
      last4: json['last4'] as String,
      name: json['name'] as String,
      network: json['network'] as String,
      type: cardTypeFromString(json['type'] as String),
      isInternational: bool.parse(json['isInternational'].toString()),
      transactionId: int.parse(json['transactionId'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last4': last4,
      'name': name,
      'network': network,
      'type': cardTypeToString(type),
      'isInternational': isInternational,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

enum CardType {
  VISA,
  MASTERCARD,
  AMERICAN_EXPRESS,
  DISCOVER,
  OTHER,
}

CardType cardTypeFromString(String value) {
  switch (value) {
    case 'VISA':
      return CardType.VISA;
    case 'MASTERCARD':
      return CardType.MASTERCARD;
    case 'AMERICAN_EXPRESS':
      return CardType.AMERICAN_EXPRESS;
    case 'DISCOVER':
      return CardType.DISCOVER;
    default:
      return CardType.OTHER;
  }
}

String cardTypeToString(CardType type) {
  switch (type) {
    case CardType.VISA:
      return 'VISA';
    case CardType.MASTERCARD:
      return 'MASTERCARD';
    case CardType.AMERICAN_EXPRESS:
      return 'AMERICAN_EXPRESS';
    case CardType.DISCOVER:
      return 'DISCOVER';
    default:
      return 'OTHER';
  }
}

class UPIPaymentSubscription {
  final int id;
  final int transactionId;
  final String vpa;
  final String email;
  final String mobile;
  final DateTime createdAt;
  final DateTime updatedAt;

  UPIPaymentSubscription({
    required this.id,
    required this.transactionId,
    required this.vpa,
    required this.email,
    required this.mobile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UPIPaymentSubscription.fromJson(Map<String, dynamic> json) {
    return UPIPaymentSubscription(
      id: int.parse(json['id'].toString()),
      transactionId: int.parse(json['transactionId'].toString()),
      vpa: json['vpa'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'vpa': vpa,
      'email': email,
      'mobile': mobile,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SubscriptionTransaction {
  final int id;
  final double amount;
  final PaymentMethod method;
  final String eventID;
  final CardPaymentSubscription? card;
  final UPIPaymentSubscription? upi;
  final int subscriptionId;

  SubscriptionTransaction({
    required this.id,
    required this.amount,
    required this.method,
    required this.eventID,
    this.card,
    this.upi,
    required this.subscriptionId,
  });

  factory SubscriptionTransaction.fromJson(Map<String, dynamic> json) {
    return SubscriptionTransaction(
      id: int.parse(json['id'].toString()),
      amount: double.parse(json['amount'].toString()),
      method: paymentMethodFromString(json['method'] as String),
      eventID: json['eventID'] as String,
      card: json['card'] != null ? CardPaymentSubscription.fromJson(json['card'] as Map<String, dynamic>) : null,
      upi: json['upi'] != null ? UPIPaymentSubscription.fromJson(json['upi'] as Map<String, dynamic>) : null,
      subscriptionId: int.parse(json['subscriptionId'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'method': paymentMethodToString(method),
      'eventID': eventID,
      'card': card?.toJson(),
      'upi': upi?.toJson(),
      'subscriptionId': subscriptionId,
    };
  }
}

PaymentMethod paymentMethodFromString(String value) {
  switch (value) {
    case 'CASH':
      return PaymentMethod.CASH;
    case 'CARD':
      return PaymentMethod.CARD;
    case 'UPI':
      return PaymentMethod.UPI;
    case 'WALLET':
      return PaymentMethod.WALLET;
    case 'NET_BANKING':
      return PaymentMethod.NET_BANKING;
    default:
      throw ArgumentError('Invalid PaymentMethod value: $value');
  }
}

String paymentMethodToString(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.CASH:
      return 'CASH';
    case PaymentMethod.CARD:
      return 'CARD';
    case PaymentMethod.UPI:
      return 'UPI';
    case PaymentMethod.WALLET:
      return 'WALLET';
    case PaymentMethod.NET_BANKING:
      return 'NET_BANKING';
    default:
      throw ArgumentError('Invalid PaymentMethod value: $method');
  }
}

class MarketplaceTemplate {
  final int id;
  final String name;
  final String displayName;
  final String displayDescription;
  final int price; // in paisa
  final String previewImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketplaceTemplate({
    required this.id,
    required this.name,
    required this.displayName,
    required this.displayDescription,
    required this.price,
    required this.previewImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketplaceTemplate.fromJson(Map<String, dynamic> json) {
    return MarketplaceTemplate(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      displayName: json['displayName'],
      displayDescription: json['displayDescription'],
      price: int.parse(json['price'].toString()),
      previewImageUrl: DatabaseService().publicResource(json['previewImgUrl']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'displayDescription': displayDescription,
      'price': price,
      'previewImgUrl': previewImageUrl,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }
}

class Admin {
  final int id;
  final String email;
  final String fullName;
  final String? profilePicture;
  final String password;
  final String reference;
  final DateTime createdAt;
  final DateTime updatedAt;

  Admin({
    required this.id,
    required this.email,
    required this.fullName,
    required this.profilePicture,
    required this.password,
    required this.reference,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: int.parse(json['id'].toString()),
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      profilePicture: json['profilePicture'] as String?,
      password: json['password'] as String,
      reference: json['reference'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'password': password,
      'reference': reference,
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
///

class SubscriptionPlan {
  final int id;
  final String planID;
  final String name;
  final int price;
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
      planID: json['planID'] as String,
      name: json['name'] as String,
      price: int.parse(json['price'].toString()),
      period: json['period'] as String,
      interval: json['interval'] as int,
      currency: json['currency'] as String,
      description: json['description'] as String,
      adminId: json['adminId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

// JWT ADMIN CLIENT
class JwtAdminClient extends http.BaseClient {
  late final String jwtToken;
  late final http.Client _inner;

  JwtAdminClient() {
    _inner = http.Client();
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'JWT_ADMIN');

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

// Logout
Future<void> logoutAdmin() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'JWT_ADMIN');
}

class DashboardDataService {
  late String origin;
  // {{host}}server/auth/sign_in_as_admin
  late Uri signInRoute;
  // {{host}}server/api_admin/reset_password
  late Uri resetPasswordRoute;
  // {{host}}server/api_admin/add_template
  late Uri addTemplateRoute;
  // {{host}}server/api_admin/users
  late Uri usersRoute;
  // {{host}}server/api_admin/contact_us
  late Uri contactUsRoute;
  // {{host}}server/api_admin/contact_us_resolved
  late Uri contactUsResolvedRoute;
  // {{host}}server/api_admin/premium_template_plans
  late Uri getPremiumPlanRoute;
  // {{host}}server/api_admin/update_template_plan
  late Uri updateTemplatePlanRoute;
  // {{host}}server/api_admin/bought_templates
  late Uri getTemplateRoute;
  // {{host}}server/api_admin/generated_resumes
  late Uri generateOrderRoute;
  // {{host}}server/api_admin/bought_templates_transactions
  late Uri getTransactionRoute;
  // {{host}}server/api_admin/subscription_transactions
  late Uri subscriptionTransactionRoute;
  // {{host}}server/api_admin/single_user
  late Uri singleUserRoute;
  // {{host}}server/api_admin/marketplace_templates
  late Uri marketplaceTemplateRoute;
  // {{host}}server/api_admin/update_marketplace_template
  late Uri updateMarketplaceTemplateRoute;
  // {{host}}server/api_admin/single_marketplace_template
  late Uri singleMarketplaceTemplateRoute;
  // {{host}}server/api_admin/single_contact_us_message
  late Uri singleContactUsMessageRoute;
  // {{host}}server/api_admin/admin_details
  late Uri adminDetailsRoute;

  DashboardDataService() {
    origin = ApplicationConfiguration.API_URL;

    signInRoute = Uri.parse('$origin/server/auth/sign_in_as_admin');
    resetPasswordRoute = Uri.parse('$origin/server/api_admin/reset_password');
    addTemplateRoute = Uri.parse('$origin/server/api_admin/add_template');
    usersRoute = Uri.parse('$origin/server/api_admin/users');
    contactUsRoute = Uri.parse('$origin/server/api_admin/contact_us');
    contactUsResolvedRoute = Uri.parse('$origin/server/api_admin/contact_us_resolved');
    getPremiumPlanRoute = Uri.parse('$origin/server/api_admin/premium_template_plans');
    updateTemplatePlanRoute = Uri.parse('$origin/server/api_admin/update_template_plan');
    getTemplateRoute = Uri.parse('$origin/server/api_admin/bought_templates');
    generateOrderRoute = Uri.parse('$origin/server/api_admin/generated_resumes');
    getTransactionRoute = Uri.parse('$origin/server/api_admin/bought_templates_transactions');
    subscriptionTransactionRoute = Uri.parse('$origin/server/api_admin/subscription_transactions');
    singleUserRoute = Uri.parse('$origin/server/api_admin/single_user');
    marketplaceTemplateRoute = Uri.parse('$origin/server/api_admin/marketplace_templates');
    updateMarketplaceTemplateRoute = Uri.parse('$origin/server/api_admin/update_marketplace_template');
    singleMarketplaceTemplateRoute = Uri.parse('$origin/server/api_admin/single_marketplace_template');
    singleContactUsMessageRoute = Uri.parse('$origin/server/api_admin/single_contact_us_message');
    adminDetailsRoute = Uri.parse('$origin/server/api_admin/admin_details');
  }

  // Sign in as admin
  Future<void> signInAsAdmin(String email, String password, BuildContext ctx) async {
    var requestBody = {'email': email, 'password': password};
    final response = await http.post(signInRoute, body: requestBody);

    if (response.statusCode == 401) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(10),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          content: Center(
            child: Text('Wrong password. Please try again.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      );

      return;
    }

    if (response.statusCode == 200) {
      var responseData = TokenModel.fromJson(json.decode(response.body));
      const storage = FlutterSecureStorage();
      await storage.write(key: 'JWT_ADMIN', value: responseData.token);
      await storage.write(key: 'EMAIL_ADMIN', value: email);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(10),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          duration: Duration(seconds: 5),
          content: Center(
            child: Text('Login successful! Welcome!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
        print(response.body);
      }
    }
  }

  // Reset password
  Future<UpdatePasswordResponse?> resetPassword(String password) async {
    var emailAdmin = await const FlutterSecureStorage().read(key: 'EMAIL_ADMIN');
    var requestBody = {'email': emailAdmin, 'password': password};
    var client = JwtAdminClient();
    final response = await client.post(resetPasswordRoute, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      var responseData = UpdatePasswordResponse.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Add template
  Future<TemplateModel?> addTemplate(String name, int price) async {
    var requestBody = {'name': name, 'price': price}; // price in paisa ( 1 paisa = 100 ) ( int )
    var client = JwtAdminClient();
    final response = await client.post(addTemplateRoute, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      var responseData = TemplateModel.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get users
  Future<List<User>?> getUsers() async {
    var client = JwtAdminClient();
    final response = await client.get(usersRoute);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var responseData = List<Map<String, dynamic>>.from(jsonData).map((item) => User.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('GET request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get contact us messages
  Future<List<ContactUsMessage>?> getContactUsMessages() async {
    var client = JwtAdminClient();
    final response = await client.get(contactUsRoute);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => ContactUsMessage.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('GET request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // contact us messages resolved
  Future<ContactUsMessageUpdate?> contactUsMessagesResolved(int id) async {
    var client = JwtAdminClient();
    final response = await client.post(contactUsResolvedRoute, body: json.encode({'id': id}));

    if (response.statusCode == 200) {
      var responseData = ContactUsMessageUpdate.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get premium plan
  Future<List<SubscriptionPlan>?> getPremiumPlan() async {
    var client = JwtAdminClient();
    final response = await client.get(getPremiumPlanRoute);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => SubscriptionPlan.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('GET request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // update the template plan
  Future<UpdatePasswordResponse?> updateTemplatePlan(String planID, int price, String name, String? description) async {
    var client = JwtAdminClient();
    var requestBody = {'planID': planID, 'price': price, 'name': name, 'description': description};
    final response = await client.post(updateTemplatePlanRoute, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      var responseData = UpdatePasswordResponse.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get bought templates
  Future<List<BoughtTemplate>?> getBoughtTemplates(String reference) async {
    var client = JwtAdminClient();
    var body = {'reference': reference};

    final response = await client.post(getTemplateRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => BoughtTemplate.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // fetch all the generated resume
  Future<List<GeneratedResume>?> getGeneratedResumes(String reference) async {
    var client = JwtAdminClient();
    var body = {'reference': reference};

    final response = await client.post(generateOrderRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => GeneratedResume.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get transaction of bought templates
  Future<List<TemplateTransaction>?> getTransactionOfBoughtTemplates(String reference) async {
    var client = JwtAdminClient();
    var body = {'reference': reference};

    final response = await client.post(getTransactionRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => TemplateTransaction.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get subscription transactions
  Future<List<SubscriptionTransaction>?> getSubscriptionTransactions(String reference) async {
    var client = JwtAdminClient();
    var body = {'reference': reference};

    final response = await client.post(subscriptionTransactionRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => SubscriptionTransaction.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get single user
  Future<User?> getSingleUser(String reference) async {
    var client = JwtAdminClient();
    var body = {'reference': reference};

    final response = await client.post(singleUserRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var responseData = User.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get marketplace templates
  Future<List<MarketplaceTemplate>?> getMarketplaceTemplates() async {
    var client = JwtAdminClient();
    final response = await client.get(marketplaceTemplateRoute);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var listData = List<Map<String, dynamic>>.from(jsonData);
      var responseData = listData.map((item) => MarketplaceTemplate.fromJson(item)).toList();
      return responseData;
    } else {
      if (kDebugMode) {
        print('GET request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Update marketplace template
  Future<UpdatePasswordResponse?> updateMarketplaceTemplate(int id, String name, int price) async {
    var client = JwtAdminClient();
    var requestBody = {'id': id, 'name': name, 'price': price};

    final response = await client.post(updateMarketplaceTemplateRoute, body: json.encode(requestBody));
    if (response.statusCode == 200) {
      var responseData = UpdatePasswordResponse.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get single marketplace template
  Future<MarketplaceTemplate?> getSingleMarketplaceTemplate(int id) async {
    var client = JwtAdminClient();
    var body = {'id': id};

    final response = await client.post(singleMarketplaceTemplateRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var responseData = MarketplaceTemplate.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get single marketplace template
  Future<ContactUsMessage?> getSingleContactUsMessage(int id) async {
    var client = JwtAdminClient();
    var body = {'id': id};

    final response = await client.post(singleContactUsMessageRoute, body: json.encode(body));
    if (response.statusCode == 200) {
      var responseData = ContactUsMessage.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }

  // Get the Admin Details
  Future<Admin?> getAdminDetails() async {
    var client = JwtAdminClient();
    final response = await client.post(adminDetailsRoute);

    if (response.statusCode == 200) {
      var responseData = Admin.fromJson(json.decode(response.body));
      return responseData;
    } else {
      if (kDebugMode) {
        print('POST request failed with status code: ${response.statusCode}');
      }

      return null;
    }
  }
}
