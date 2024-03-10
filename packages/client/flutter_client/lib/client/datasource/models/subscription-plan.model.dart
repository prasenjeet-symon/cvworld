import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class SubscriptionPlanModel {
  final String nodeId;

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<Subscription>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));

  List<Subscription> _prevData = [];
  List<Subscription> _nextData = [];

  SubscriptionPlanModel({required this.nodeId}) {
    _storeName = 'subscription_plan_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.SUBSCRIPTION_PLAN) {
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
      _prevData.add(Subscription.fromRecord(element.value));
    }

    _nextData = _prevData;
    _emit();
  }

  // Save local data
  _saveLocal() async {
    var nodeStore = stringMapStoreFactory.store(_storeName);
    await nodeStore.delete(_database);
    for (var element in _nextData) {
      await nodeStore.record(element.name).put(_database, element.toRecord(), merge: true);
    }
  }

  // emit
  _emit() {
    _source.add(ModelStore(status: ModelStoreStatus.ready, data: _nextData));
  }

  // Get
  _get() async {
    try {
      ApiResponse response = await singleCall(NetworkApi().getSubscriptionPlan());
      if (response.statusCode == 200) {
        Subscription subscriptionPlan = response.data;
        _prevData = [subscriptionPlan];
        _nextData = [subscriptionPlan];
        _emit();
        await _saveLocal();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream<ModelStore<List<Subscription>>> get plans => _source.stream;

  void dispose() {
    _source.close();
    _nextData = [];
    _prevData = [];
  }
}
