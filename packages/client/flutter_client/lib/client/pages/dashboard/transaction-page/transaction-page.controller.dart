import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/mutation.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';

class TransactionPageController {
  ///
  ///
  /// Get all transactions
  Stream<ModelStore<List<UserTransaction>>> getTransactions() {
    RootToTransactionMapping mapper = RootToTransactionMapping.getInstance();
    return mapper.get(Constants.rootNodeId).transactions;
  }

  ///
  ///
  /// Refresh
  void refresh() {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.REFRESH_TRANSACTION, null));
  }
}
