import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/dashboard/datasource/http/http.manager.admin.dart';
import 'package:cvworld/dashboard/datasource/network.api.admin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class FeedbackModel {
  final String nodeId; // Root node id

  late Database _database;
  late String _storeName;
  final String _storeBaseName = 'feedback_store_admin';

  final _source = BehaviorSubject<ModelStore<List<Feedback>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));
  final _search = BehaviorSubject<String?>.seeded(null);

  List<Feedback> _prevData = [];
  List<Feedback> _nextData = [];

  FeedbackModel({required this.nodeId}) {
    _storeName = '${_storeBaseName}_$nodeId';

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
    ApiResponse response = await singleCall(NetworkApiAdmin().getAllFeedback());
    if (response.statusCode == 200) {
      var data = response.data as List<Feedback>;
      _nextData = data;
      _prevData = data;
      _emit();
      _saveLocal();
    }
  }

  ///
  ///
  ///
  /// Delete feedback
  Future<void> delete(Feedback feedback) async {
    _prevData = deepCopyList(_nextData);
    _nextData = _nextData.where((element) => element.identifier != feedback.identifier).toList();
    _emit();

    try {
      await singleCall(NetworkApiAdmin().deleteFeedback(feedback));
      await _saveLocal();
      MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.FEEDBACK, feedback, MutationType.delete));
      return;
    } catch (e) {
      // Rollback
      _nextData = deepCopyList(_prevData);
      _emit();
      return;
    }
  }

  ///
  ///
  ///
  /// Search
  search(String searchQuery) {
    _search.add(searchQuery);
  }

  ///
  ///
  ///
  /// Feedback get
  Stream<ModelStore<List<Feedback>>> getAll() {
    return _search.stream.switchMap((searchQuery) {
      return _source.stream.map((feedbackStore) {
        if (searchQuery == null) {
          return feedbackStore;
        } else {
          // Filter based on search

          List<Feedback> filteredList = feedbackStore.data.where((element) {
            var searchableString = "${element.description} ${element.email} ${element.name} ${element.title} ${element.department}";
            RegExp regex = RegExp(searchQuery, caseSensitive: false, multiLine: true, dotAll: true);
            return regex.hasMatch(searchableString);
          }).toList();
          return ModelStore(status: feedbackStore.status, data: filteredList);
        }
      }).map((event) {
        // We need to sort by createdAt
        event.data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return event;
      });
    });
  }
}
