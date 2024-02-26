import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/http/success.manager.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/config.dart';
import 'package:rxdart/rxdart.dart';

class NetworkApi {
  // Authentication related endpoints
  final Uri _uriSignUp = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/sign_up');
  final Uri _uriSignIn = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/sign_in');
  final Uri _uriForgotPassword = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/forgot_password');
  final Uri _uriResetPassword = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/reset_password');
  final Uri _uriGoogleLogin = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/google_login');
  final Uri _uriGoogleSignup = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/google_signup');
  final Uri _uriIsTokenActive = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/is_token_active');
  final Uri _uriIsUsernameTaken = Uri.parse('${ApplicationConfiguration.apiUrl}/server/auth/is_username_taken');

  // Public endpoints
  final Uri _uriFeedback = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api_public/feedback');

  ///
  ///
  /// Get URL of public resource
  static String publicResource(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return path;
    }

    return '${ApplicationConfiguration.apiUrl}/server/media/$path';
  }

  ///
  ///
  ///
  /// Signup with email and password
  Stream<ApiResponse> signup(String email, String password, String fullName, String userName, String timeZone) {
    Map<String, dynamic> body = {'email': email, 'password': password, 'fullName': fullName, 'timeZone': timeZone, 'userName': userName};

    return HttpManager.request(_uriSignUp.toString(), 'POST', body).map((event) {
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
        SuccessManager.getInstance().dispatch('Account created successfully. Welcome!');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  ///
  /// Signin with email and password
  Stream<ApiResponse> signin(String email, String password) {
    Map<String, dynamic> body = {'email': email, 'password': password};

    return HttpManager.request(_uriSignIn.toString(), 'POST', body).map((event) {
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
        SuccessManager.getInstance().dispatch('Welcome back!');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  ///
  /// Forgot password
  Stream<ApiResponse> forgotPassword(String email) {
    Map<String, dynamic> body = {'email': email};

    return HttpManager.request(_uriForgotPassword.toString(), 'POST', body).map((event) {
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
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  ///
  /// Reset password
  Stream<ApiResponse> resetPassword(String userId, String password, String token) {
    Map<String, dynamic> body = {'userId': userId, 'password': password, 'token': token};

    return HttpManager.request(_uriResetPassword.toString(), 'POST', body).map((event) {
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
        SuccessManager.getInstance().dispatch('Password reset successfully. Welcome!');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Google sign in
  Stream<ApiResponse> googleSignIn(String token) {
    Map<String, dynamic> body = {'token': token};

    return HttpManager.request(_uriGoogleLogin.toString(), 'POST', body).map((event) {
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
        SuccessManager.getInstance().dispatch('Welcome back!');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Google sign up
  Stream<ApiResponse> googleSignUp(String token, String timeZone) {
    Map<String, dynamic> body = {'token': token, 'timeZone': timeZone};

    return HttpManager.request(_uriGoogleSignup.toString(), 'POST', body).map((event) {
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
        SuccessManager.getInstance().dispatch('Account created successfully. Welcome!');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  ///
  /// Is token active
  Stream<ApiResponse> isTokenActive() {
    String? token = ApplicationToken.getInstance().getToken;
    Map<String, dynamic> body = {'token': token};

    return HttpManager.request(_uriIsTokenActive.toString(), 'POST', body).map((event) {
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
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  ///
  /// Is username taken
  Stream<ApiResponse> isUsernameTaken(String username) {
    Map<String, dynamic> body = {'username': username};

    return HttpManager.request(_uriIsUsernameTaken.toString(), 'POST', body).map((event) {
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
        // ApiMutationSuccess data = event.data;
        // SuccessManager.getInstance().dispatch(data.message);
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
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
