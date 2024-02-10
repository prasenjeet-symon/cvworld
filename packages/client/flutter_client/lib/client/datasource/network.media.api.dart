import 'dart:convert';
import 'dart:typed_data';

import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/http/success.manager.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class NetworkMediaApi {
  final Uri _uriUploadFeedbackFile = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api_public/upload_feedback_file');

  static String publicResource(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return path;
    }

    return '${ApplicationConfiguration.apiUrl}/server/media/$path';
  }

  ///
  ///
  ///
  /// Upload feedback file no more than 1 MB
  Stream<ApiResponse> uploadFeedbackFile(Uint8List? imageBytes, String fileName) {
    if (imageBytes == null) {
      return const Stream<ApiResponse>.empty();
    }

    http.MultipartRequest request = http.MultipartRequest('POST', _uriUploadFeedbackFile);

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'feedbackFile',
      imageBytes,
      filename: fileName,
    );

    request.files.add(multipartFile);

    return request.send().asStream().switchMap((streamedResponse) {
      return http.Response.fromStream(streamedResponse).asStream();
    }).map((response) {
      var statusCode = response.statusCode;
      var statusText = response.reasonPhrase;
      final jsonData = json.decode(response.body);
      final stringJSON = json.encode(jsonData);

      return ApiResponse(statusCode, stringJSON, statusText ?? 'Unknown error');
    }).map((event) {
      if (event.statusCode == 200) {
        ApiMutationSuccess data = ApiMutationSuccess.fromJson(event.data);
        return ApiResponse(event.statusCode, data, event.statusText);
      } else {
        return event;
      }
    }).map((event) {
      if (event.statusCode != 200) {
        ApiMutationError data = ApiMutationError.fromJson(event.data);
        return ApiResponse(event.statusCode, data, event.statusText);
      } else {
        return event;
      }
    }).doOnData((event) {
      if (event.statusCode == 200) {
        SuccessManager.getInstance().dispatch('Feedback file uploaded successfully.');
      } else {
        ErrorManager.getInstance().dispatch('Failed to upload feedback file. Please try again.');
      }
    });
  }
}
