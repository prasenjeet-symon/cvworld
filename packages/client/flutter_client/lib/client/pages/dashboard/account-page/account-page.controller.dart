import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/models/subscription.model.dart';
import 'package:cvworld/client/datasource/models/user.model.dart';
import 'package:cvworld/client/datasource/mutation.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';

class AccountPageController {
  ///
  ///
  /// Get user
  Stream<ModelStore<List<User>>> getUser() {
    RootToUserMapping mapper = RootToUserMapping.getInstance();
    UserModel model = mapper.get(Constants.rootNodeId);
    return model.getUser();
  }

  ///
  ///
  /// Update user
  void updateUser(User user) {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.UPDATE_USER, user));
  }

  ///
  ///
  /// Is subscribed
  Stream<bool> isSubscribed() {
    String? userId = ApplicationToken.getInstance().getUserId;
    UserToSubscriptionMapping mapper = UserToSubscriptionMapping.getInstance();
    SubscriptionModel model = mapper.get(userId ?? '');
    return model.isSubscribed();
  }

  ///
  ///
  /// Get subscription
  Stream<ModelStore<List<UserSubscription>>> getSubscription() {
    String? userId = ApplicationToken.getInstance().getUserId;
    UserToSubscriptionMapping mapper = UserToSubscriptionMapping.getInstance();
    SubscriptionModel model = mapper.get(userId ?? '');
    return model.subscriptions;
  }

  ///
  ///
  ///  Get application subscription plan
  Stream<ModelStore<List<Subscription>>> getSubscriptionPlan() {
    RootToSubscriptionPlanMapping mapper = RootToSubscriptionPlanMapping.getInstance();
    return mapper.get(Constants.rootNodeId).plans;
  }

  ///
  ///
  /// Subscribe Now
  void subscribeNow() {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.SUBSCRIPTION_STATUS_START_LISTENING, null));
  }

  ///
  ///
  /// Cancel Subscription
  void cancelSubscription() {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.CANCEL_SUBSCRIPTION, null));
  }

  ///
  ///
  /// Delete user
  void deleteUser() {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.DELETE_USER, null));
  }
}
