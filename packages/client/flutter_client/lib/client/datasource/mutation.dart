import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/models/feedback.model.dart';
import 'package:cvworld/client/datasource/schema.dart';
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
