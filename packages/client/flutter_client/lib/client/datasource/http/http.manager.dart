import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

/// ApplicationToken class
class ApplicationToken {
  static ApplicationToken? _instance;
  late String? _token;
  late String? _userId;
  final _tokenSubject = BehaviorSubject<String?>.seeded(null);
  final _userIdSubject = BehaviorSubject<String?>.seeded(null);
  final _storage = const FlutterSecureStorage();

  ApplicationToken._();

  static ApplicationToken getInstance() {
    _instance ??= ApplicationToken._();
    return _instance!;
  }

  Stream<String?> get observable => _tokenSubject.stream;
  Stream<String?> get userIdObservable => _userIdSubject.stream;

  Future<void> saveToken(String token, String userId) async {
    _token = token;
    _userId = userId;
    _tokenSubject.add(token);
    _userIdSubject.add(userId);
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'userId', value: userId);
  }

  String? get getToken => _token;
  String? get getUserId => _userId;

  Future<void> deleteToken() async {
    _token = null;
    _userId = null;
    _tokenSubject.add(null);
    _userIdSubject.add(null);
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'userId');
  }

  Future<void> bootUp() async {
    _token = await _storage.read(key: 'token');
    _userId = await _storage.read(key: 'userId');
    _tokenSubject.add(_token);
    _userIdSubject.add(_userId);
  }
}

/// HttpManager class
class HttpManager {
  static Future<ApiResponse> makeHttpRequest(String? token, String url, String method, [Map<String, dynamic>? body]) async {
    late http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(
          Uri.parse(url),
          headers: <String, String>{'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        );
        break;
      case 'POST':
        response = await http.post(
          Uri.parse(url),
          headers: <String, String>{'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: body == null ? null : json.encode(body),
        );
        break;
      case 'PUT':
        response = await http.put(
          Uri.parse(url),
          headers: <String, String>{'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: body == null ? null : json.encode(body),
        );
        break;
      case 'DELETE':
        response = await http.delete(
          Uri.parse(url),
          headers: <String, String>{'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: body == null ? null : json.encode(body),
        );
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    final jsonData = json.decode(response.body);
    final statusCode = response.statusCode;
    final statusText = response.reasonPhrase;
    final stringJSON = json.encode(jsonData);

    return ApiResponse(statusCode, stringJSON, statusText ?? 'Unknown error');
  }

  static Stream<ApiResponse> request(String url, String method, [Map<String, dynamic>? body]) {
    String? tokenValue = ApplicationToken.getInstance().getToken;
    return makeHttpRequest(tokenValue, url, method, body).asStream();
  }
}

/// ApiResponse class
class ApiResponse {
  final int statusCode;
  final dynamic data;
  final String statusText;

  ApiResponse(this.statusCode, this.data, this.statusText);
}

/// singleCall function
Future<ApiResponse> singleCall(Stream<ApiResponse> obs) async {
  final result = await obs.first;
  if (result.statusCode != 200) {
    throw Exception('Failed to fetch data');
  }

  return result;
}
