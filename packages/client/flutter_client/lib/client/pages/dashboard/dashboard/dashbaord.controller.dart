import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/models/subscription.model.dart';
import 'package:cvworld/client/datasource/models/user.model.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';

class DashboardController {
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
  /// Is subscribed
  Stream<bool> isSubscribed() {
    String? userId = ApplicationToken.getInstance().getUserId;
    UserToSubscriptionMapping mapper = UserToSubscriptionMapping.getInstance();
    SubscriptionModel model = mapper.get(userId ?? '');
    return model.isSubscribed();
  }
}
