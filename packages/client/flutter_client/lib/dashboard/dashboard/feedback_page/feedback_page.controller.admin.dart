import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/dashboard/datasource/mapping.admin.dart';
import 'package:cvworld/dashboard/datasource/models/feedback.model.admin.dart';
import 'package:cvworld/dashboard/datasource/mutation.admin.dart';
import 'package:cvworld/dashboard/datasource/schema.admin.dart';

class FeedbackPageControllerAdmin {
  ///
  ///
  /// Get all feedback
  Stream<ModelStore<List<Feedback>>> getAllFeedback() {
    RootToFeedbackMapping mapping = RootToFeedbackMapping.getInstance();
    FeedbackModel model = mapping.get('');
    return model.getAll();
  }

  ///
  ///
  /// Search
  void search(String query) {
    RootToFeedbackMapping mapping = RootToFeedbackMapping.getInstance();
    FeedbackModel model = mapping.get('');
    model.search(query);
  }

  ///
  ///
  ///
  /// Delete feedback
  void deleteFeedback(Feedback feedback) {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationDataAdmin(ApplicationMutationIdentifierAdmin.DELETE_FEEDBACK, feedback));
  }
}
