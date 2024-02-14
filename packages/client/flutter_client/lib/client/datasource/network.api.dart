import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/http/success.manager.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/config.dart';
import 'package:rxdart/rxdart.dart';

class NetworkApi {
  final Uri _uriSignInWithEmailAndPassword = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/sign_in_with_email_and_password');
  final Uri _uriFeedback = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api_public/feedback');

  static String publicResource(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return path;
    }

    return '${ApplicationConfiguration.apiUrl}/server/media/$path';
  }

  ///
  ///
  /// Add new feedback
  Stream<ApiResponse> addFeedback(Feedback feedback) {
    return HttpManager.request(_uriFeedback.toString(), 'POST', feedback.toRecord()).map((event) {
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
        SuccessManager.getInstance().dispatch('Feedback sent successfully. Thank you!');
      } else {
        ErrorManager.getInstance().dispatch('Failed to send feedback. Please try again.');
      }
    });
  }
}
