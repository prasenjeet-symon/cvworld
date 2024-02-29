import 'dart:convert';

import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/http/success.manager.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/config.dart';
import 'package:rxdart/rxdart.dart';

class NetworkApi {
  // Authentication endpoints
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

  // Protected endpoints
  final Uri _uriUser = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api/user');
  final Uri _uriUserTransaction = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api/user/transaction');
  final Uri _uriUserSubscription = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api/user/subscription');
  final Uri _uriTemplate = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api/template');
  final Uri _uriUserFavorite = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api/user/favorite');
  final Uri _uriSubscription = Uri.parse('${ApplicationConfiguration.apiUrl}/server/api/subscription');

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

  ///
  ///
  /// Get user
  Stream<ApiResponse> getUser() {
    return HttpManager.request(_uriUser.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        User data = User.fromJson(event.data);
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
        SuccessManager.getInstance().dispatch('User fetched successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Delete user
  Stream<ApiResponse> deleteUser() {
    return HttpManager.request(_uriUser.toString(), 'DELETE').map((event) {
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
        SuccessManager.getInstance().dispatch('User deleted successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Update user
  Stream<ApiResponse> updateUser(User user) {
    return HttpManager.request(_uriUser.toString(), 'PUT', user.toRecord()).map((event) {
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
        SuccessManager.getInstance().dispatch('User updated successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Get user's transaction
  Stream<ApiResponse> getUserTransaction() {
    return HttpManager.request(_uriUserTransaction.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        List<UserTransaction> data = (jsonDecode(event.data) as List).map((e) => UserTransaction.fromRecord(e)).toList();
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
        SuccessManager.getInstance().dispatch('User transactions fetched successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Get user's subscription
  Stream<ApiResponse> getUserSubscription() {
    return HttpManager.request(_uriUserSubscription.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        UserSubscription data = UserSubscription.fromJson(event.data);
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
        SuccessManager.getInstance().dispatch('User subscription fetched successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Get all templates
  Stream<ApiResponse> getTemplates() {
    return HttpManager.request(_uriTemplate.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        List<Template> data = (jsonDecode(event.data) as List).map((e) => Template.fromRecord(e)).toList();
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
        SuccessManager.getInstance().dispatch('Templates fetched successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Add template as favorite
  Stream<ApiResponse> addTemplateToFavorites(String templateName) {
    return HttpManager.request(_uriUserFavorite.toString(), 'POST', {'templateName': templateName}).map((event) {
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
        SuccessManager.getInstance().dispatch('Template added to favorites successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  // Remove template from favorite
  Stream<ApiResponse> removeTemplateFromFavorites(String templateName) {
    return HttpManager.request(_uriUserFavorite.toString(), 'DELETE', {'templateName': templateName}).map((event) {
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
        SuccessManager.getInstance().dispatch('Template removed from favorites successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Get user's favorite templates
  Stream<ApiResponse> getUserFavoriteTemplates() {
    return HttpManager.request(_uriUserFavorite.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        List<Template> data = (jsonDecode(event.data) as List).map((e) => Template.fromRecord(e)).toList();
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
        SuccessManager.getInstance().dispatch('User favorite templates fetched successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Get application subscription plan
  Stream<ApiResponse> getSubscriptionPlan() {
    return HttpManager.request(_uriSubscription.toString(), 'GET').map((event) {
      if (event.statusCode == 200) {
        Subscription data = Subscription.fromJson(event.data);
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
        SuccessManager.getInstance().dispatch('Subscription plan fetched successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }

  ///
  ///
  /// Cancel user's subscription
  Stream<ApiResponse> cancelSubscription() {
    return HttpManager.request(_uriUserSubscription.toString(), 'DELETE').map((event) {
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
        SuccessManager.getInstance().dispatch('Subscription canceled successfully.');
      } else {
        ApiMutationError data = event.data;
        ErrorManager.getInstance().dispatch(data.error);
      }
    });
  }
}
