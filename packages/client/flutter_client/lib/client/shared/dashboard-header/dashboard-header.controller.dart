import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/models/user.model.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';

class DashboardHeaderController {
  ///
  ///
  /// Get current user
  Stream<ModelStore<List<User>>> getUser() {
    RootToUserMapping mapper = RootToUserMapping.getInstance();
    UserModel model = mapper.get(Constants.rootNodeId);
    return model.getUser();
  }
}
