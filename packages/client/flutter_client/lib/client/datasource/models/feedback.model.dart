import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class FeedbackModel {
  final String nodeId; // Root node id

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<Feedback>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));

  List<Feedback> _prevData = [];
  List<Feedback> _nextData = [];

  FeedbackModel({required this.nodeId}) {
    _storeName = 'feedback_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.FEEDBACK) {
        _get();
      }
    });

    DatabaseManager().openDatabase().then((value) {
      _database = value;
      return _getLocal();
    }).then((value) {
      _get();
    });
  }

  // Get local data
  _getLocal() async {
    var nodeStore = stringMapStoreFactory.store(_storeName);
    var allRecord = await nodeStore.find(_database);
    for (var element in allRecord) {
      _prevData.add(Feedback.fromRecord(element.value));
    }

    _nextData = _prevData;
    _emit();
  }

  // Save local data
  _saveLocal() async {
    var nodeStore = stringMapStoreFactory.store(_storeName);
    await nodeStore.delete(_database);
    for (var element in _nextData) {
      await nodeStore.record(element.identifier).put(_database, element.toRecord(), merge: true);
    }
  }

  // emit
  _emit() {
    _source.add(ModelStore(status: ModelStoreStatus.ready, data: _nextData));
  }

  // Get from network
  _get() async {
    return;
  }

  ///
  ///
  ///
  /// Add new feedback
  Future<void> add(Feedback feedback) async {
    _prevData = deepCopyList(_nextData);
    _nextData.add(feedback);
    _emit();

    try {
      try {
        await feedback.uploadFile((progress) => _emit(), (error) => throw error);
      } catch (e) {
        if (kDebugMode) {
          print('cannot upload attachment for feedback');
          print(e);
        }
      }

      await singleCall(NetworkApi().addFeedback(feedback));
      _saveLocal();
      MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.FEEDBACK, feedback, MutationType.create));
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      // Rollback
      _nextData = deepCopyList(_prevData);
      _emit();
    }
  }
}
