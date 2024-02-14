import 'package:cvworld/client/datasource/mutation.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/dashboard/datasource/mapping.admin.dart';
import 'package:cvworld/dashboard/datasource/models/feedback.model.admin.dart';
import 'package:cvworld/dashboard/datasource/schema.admin.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationMutation {
  static ApplicationMutation? _instance;
  final PublishSubject<ApplicationMutationDataAdmin> _mutation = PublishSubject<ApplicationMutationDataAdmin>();

  ApplicationMutation._() {
    _mutation.listen((value) {
      ApplicationMutationIdentifierAdmin identifier = value.identifier;

      switch (identifier) {
        case ApplicationMutationIdentifierAdmin.DELETE_FEEDBACK:
          MutationQueue.getInstance().add(_deleteFeedback(value.data as Feedback));
          break;
      }
    });
  }

  /// Delete feedback
  static Future<void> Function() _deleteFeedback(Feedback feedback) {
    return () async {
      var mapping = RootToFeedbackMapping.getInstance();
      FeedbackModel model = mapping.get('');
      await model.delete(feedback);
    };
  }

  static ApplicationMutation getInstance() {
    _instance ??= ApplicationMutation._();
    return _instance!;
  }

  void dispatch(ApplicationMutationDataAdmin data) {
    _mutation.add(data);
  }
}
