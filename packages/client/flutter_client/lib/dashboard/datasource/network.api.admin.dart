import 'dart:convert';

import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/config.dart';
import 'package:cvworld/dashboard/datasource/http/error.manager.admin.dart';
import 'package:cvworld/dashboard/datasource/http/http.manager.admin.dart';
import 'package:cvworld/dashboard/datasource/http/success.manager.admin.dart';
import 'package:rxdart/rxdart.dart';

class NetworkApiAdmin {
  // Authentication
  final Uri _uriLogin = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/admin_signin');
  final Uri _uriFeedback = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api_public/feedback');

  ///
  ///
  /// Delete feedback
  Stream<ApiResponse> deleteFeedback(Feedback feedback) {
    return HttpManager.request(_uriFeedback.toString(), 'DELETE', feedback.toRecord()).map((event) {
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
        ApiMutationSuccess data = event.data;
        SuccessManager.getInstance().dispatch(data.message);
      }
    }).doOnData((event) {
      if (event.statusCode != 200) {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Get all feedback
  Stream<ApiResponse> getAllFeedback() {
    return HttpManager.request(_uriFeedback.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        List<dynamic> arrData = jsonDecode(event.data) as List<dynamic>;
        List<Feedback> feedbacks = arrData.map((e) => Feedback.fromRecord(e)).toList();
        return ApiResponse(event.statusCode, feedbacks, event.statusText);
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
      if (event.statusCode != 200) {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  ///
  /// Signin as admin
  Stream<ApiResponse> signInAsAdmin(String email, String password, String timeZone) {
    var body = {"email": email, 'password': password, 'timeZone': timeZone};

    return HttpManager.request(_uriLogin.toString(), 'POST', body).map((event) {
      if (event.statusCode == 200) {
        Authentication data = Authentication.fromJson(event.data);
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
    }).doOnData((event) async {
      if (event.statusCode == 200) {
        Authentication data = event.data;
        await ApplicationToken.getInstance().saveToken(data.token, data.userId);
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }
}
