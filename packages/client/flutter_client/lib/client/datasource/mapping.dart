import 'package:cvworld/client/datasource/models/feedback.model.dart';

///
///
///
/// Root to feedback mapping
class RootToFeedbackMapping {
  static final RootToFeedbackMapping _instance = RootToFeedbackMapping._();
  final Map<String, FeedbackModel> _mappingData = <String, FeedbackModel>{};

  RootToFeedbackMapping._();

  factory RootToFeedbackMapping.getInstance() {
    return _instance;
  }

  // Get model
  FeedbackModel get(String id) {
    if (_mappingData.containsKey(id)) {
      return _mappingData[id]!;
    } else {
      _mappingData[id] = FeedbackModel(nodeId: id);
      return _mappingData[id]!;
    }
  }

  // Dispose
  void dispose() {
    _mappingData.clear();
  }
}
