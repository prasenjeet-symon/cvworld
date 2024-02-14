import 'package:cvworld/dashboard/datasource/models/feedback.model.admin.dart';

///
///
///
/// Root to feedback mapping
class RootToFeedbackMapping {
  static RootToFeedbackMapping? _instance;
  final Map<String, FeedbackModel> _rootToFeedback = <String, FeedbackModel>{};

  static RootToFeedbackMapping getInstance() {
    _instance ??= RootToFeedbackMapping();
    return _instance!;
  }

  // Get
  FeedbackModel get(String nodeId) {
    if (_rootToFeedback.containsKey(nodeId)) {
      return _rootToFeedback[nodeId]!;
    } else {
      var feedback = FeedbackModel(nodeId: nodeId);
      _rootToFeedback[nodeId] = feedback;
      return feedback;
    }
  }

  // Dispose
  void dispose() {
    _rootToFeedback.clear();
  }
}
