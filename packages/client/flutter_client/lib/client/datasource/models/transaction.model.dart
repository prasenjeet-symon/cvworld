import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:sembast/sembast.dart';

class TransactionModel {
  final String nodeId;

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<UserTransaction>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));
  // Search source
  final _searchSource = BehaviorSubject<String?>.seeded(null);

  List<UserTransaction> _prevData = [];
  List<UserTransaction> _nextData = [];

  TransactionModel({required this.nodeId}) {
    _storeName = 'transaction_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.TRANSACTION) {
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
      _prevData.add(UserTransaction.fromRecord(element.value));
    }

    _nextData = _prevData;
    _emit();
  }

  // Save local data
  _saveLocal() async {
    var nodeStore = stringMapStoreFactory.store(_storeName);
    await nodeStore.delete(_database);
    for (var element in _nextData) {
      await nodeStore.record(element.orderId).put(_database, element.toRecord(), merge: true);
    }
  }

  // emit
  _emit() {
    _source.add(ModelStore(status: ModelStoreStatus.ready, data: _nextData));
  }

  // Get single user
  _get() async {
    try {
      ApiResponse response = await singleCall(NetworkApi().getUserTransaction());
      if (response.statusCode == 200) {
        List<UserTransaction> data = response.data;
        _nextData = data;
        _prevData = data;
        _emit();
        await _saveLocal();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Refresh
  refresh() async {
    _get();
  }

  Stream<ModelStore<List<UserTransaction>>> get transactions => _source.stream;

  ///
  ///
  /// Get searched transactions
  Stream<ModelStore<List<UserTransaction>>> getTransactions(String query) {
    return _searchSource.switchMap((value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return _source.stream;
      } else {
        return _source.map((event) {
          // Search with regex
          return ModelStore(
              status: event.status,
              data: event.data
                  .where((element) => RegExp(query, caseSensitive: false, multiLine: true).hasMatch('${element.orderId} ${element.amount} ${element.method} ${element.templateName} ${element.status} ${formatDateTime(element.createdAt)}'))
                  .toList());
        });
      }
    });
  }

  dispose() {
    _source.close();
    _prevData = [];
    _nextData = [];
  }

  // Search
  void search(String query) {
    _searchSource.add(query);
  }
}
