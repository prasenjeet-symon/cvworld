import 'package:cvworld/client/datasource/mutation.dart';
import 'package:cvworld/client/datasource/schema.dart';

class FeedbackController {
  FeedbackController();

  // Add feedback
  Future<void> add(Feedback feedback) async {
    ApplicationMutation.getInstance().dispatch(ApplicationMutationData(ApplicationMutationIdentifier.CREATE_FEEDBACK, feedback));
  }
}
