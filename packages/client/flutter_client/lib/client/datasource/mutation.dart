import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/models/feedback.model.dart';
import 'package:cvworld/client/datasource/models/subscription.model.dart';
import 'package:cvworld/client/datasource/models/transaction.model.dart';
import 'package:cvworld/client/datasource/models/user.model.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

class ApplicationMutation {
  static ApplicationMutation? _instance;

  final Subject<ApplicationMutationData> _mutation = PublishSubject<ApplicationMutationData>();

  ApplicationMutation._() {
    _mutation.listen((value) {
      ApplicationMutationIdentifier identifier = value.identifier;

      switch (identifier) {
        case ApplicationMutationIdentifier.CREATE_FEEDBACK:
          MutationQueue.getInstance().add(_addFeedback(value.data as Feedback));
          break;

        case ApplicationMutationIdentifier.ADD_FAVORITE:
          MutationQueue.getInstance().add(_addFavorite(value.data as Template));
          break;

        case ApplicationMutationIdentifier.REMOVE_FAVORITE:
          MutationQueue.getInstance().add(_removeFavorite(value.data as Template));
          break;

        case ApplicationMutationIdentifier.DELETE_USER:
          MutationQueue.getInstance().add(_deleteUser());
          break;

        case ApplicationMutationIdentifier.UPDATE_USER:
          MutationQueue.getInstance().add(_updateUser(value.data as User));
          break;

        // SUBSCRIPTION_STATUS_START_LISTENING
        case ApplicationMutationIdentifier.SUBSCRIPTION_STATUS_START_LISTENING:
          MutationQueue.getInstance().add(_subscriptionStatusStartListening());
          break;

        // CANCEL_SUBSCRIPTION
        case ApplicationMutationIdentifier.CANCEL_SUBSCRIPTION:
          MutationQueue.getInstance().add(_cancelSubscription());
          break;

        // ADD_DEFAULT_TEMPLATE
        case ApplicationMutationIdentifier.ADD_DEFAULT_TEMPLATE:
          MutationQueue.getInstance().add(_addDefaultTemplate(value.data as Template));
          break;

        // REMOVE_DEFAULT_TEMPLATE
        case ApplicationMutationIdentifier.REMOVE_DEFAULT_TEMPLATE:
          MutationQueue.getInstance().add(_removeDefaultTemplate(value.data as Template));
          break;

        // REFRESH_TRANSACTION
        case ApplicationMutationIdentifier.REFRESH_TRANSACTION:
          MutationQueue.getInstance().add(_refreshTransaction());
          break;

        case ApplicationMutationIdentifier.UPDATE_FEEDBACK:
          break;
      }
    });
  }

  ///
  ///
  /// Add new feedback
  static Future<void> Function() _addFeedback(Feedback feedback) {
    return () async {
      RootToFeedbackMapping mapper = RootToFeedbackMapping.getInstance();
      FeedbackModel model = mapper.get('');
      await model.add(feedback);
    };
  }

  ///
  ///
  /// Add to favorite
  static Future<void> Function() _addFavorite(Template template) {
    return () async {
      String? userId = ApplicationToken.getInstance().getUserId;
      await UserToFavoriteMapping.getInstance().get(userId ?? '').addToFavorite(template);
    };
  }

  ///
  ///
  /// Remove from favorite
  static Future<void> Function() _removeFavorite(Template template) {
    return () async {
      String? userId = ApplicationToken.getInstance().getUserId;
      await UserToFavoriteMapping.getInstance().get(userId ?? '').removeFromFavorite(template);
    };
  }

  ///
  ///
  /// Delete user
  static Future<void> Function() _deleteUser() {
    return () async {
      RootToUserMapping mapper = RootToUserMapping.getInstance();
      UserModel model = mapper.get(Constants.rootNodeId);
      await model.deleteUser();
    };
  }

  ///
  ///
  /// Update user
  static Future<void> Function() _updateUser(User user) {
    return () async {
      RootToUserMapping mapper = RootToUserMapping.getInstance();
      UserModel model = mapper.get(Constants.rootNodeId);
      await model.updateUser(user);
    };
  }

  ///
  ///
  /// _subscriptionStatusStartListening
  static Future<void> Function() _subscriptionStatusStartListening() {
    return () async {
      String? userId = ApplicationToken.getInstance().getUserId;
      UserToSubscriptionMapping mapper = UserToSubscriptionMapping.getInstance();
      SubscriptionModel model = mapper.get(userId ?? '');
      await model.keepListening();
    };
  }

  /// _cancelSubscription
  static Future<void> Function() _cancelSubscription() {
    return () async {
      String? userId = ApplicationToken.getInstance().getUserId;
      UserToSubscriptionMapping mapper = UserToSubscriptionMapping.getInstance();
      SubscriptionModel model = mapper.get(userId ?? '');
      await model.cancelSubscription();
    };
  }

  ///
  ///
  /// Add default template
  static Future<void> Function() _addDefaultTemplate(Template template) {
    return () async {
      UserToFavoriteMapping mapper = UserToFavoriteMapping.getInstance();
      String? userId = ApplicationToken.getInstance().getUserId;
      await mapper.get(userId ?? '').addToDefault(template);
    };
  }

  ///
  ///
  /// Remove default template
  static Future<void> Function() _removeDefaultTemplate(Template template) {
    return () async {
      UserToFavoriteMapping mapper = UserToFavoriteMapping.getInstance();
      String? userId = ApplicationToken.getInstance().getUserId;
      // await mapper.get(userId ?? '').removeFromFavorite(template);
    };
  }

  ///
  ///
  /// _refreshTransaction
  static Future<void> Function() _refreshTransaction() {
    return () async {
      RootToTransactionMapping mapper = RootToTransactionMapping.getInstance();
      TransactionModel model = mapper.get(Constants.rootNodeId);
      await model.refresh();
    };
  }

  static ApplicationMutation getInstance() {
    _instance ??= ApplicationMutation._();
    return _instance!;
  }

  // Dispatch
  void dispatch(ApplicationMutationData data) {
    _mutation.add(data);
  }
}

///
///
///
///
/// Mutation Queue , with RxDart
class MutationQueue {
  final PublishSubject<Future<void> Function()> _queue = PublishSubject<Future<void> Function()>();

  MutationQueue._() {
    _queue.stream.asyncMap((event) {
      return _mutate(event);
    }).listen((event) {
      if (kDebugMode) {
        print('Mutation Queue Rx Done');
      }
    });
  }

  static final MutationQueue _instance = MutationQueue._();

  static getInstance() {
    return _instance;
  }

  void add(Future<void> Function() future) {
    _queue.add(future);
  }

  Future<void> _mutate(Future<void> Function() future) async {
    try {
      await future();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
