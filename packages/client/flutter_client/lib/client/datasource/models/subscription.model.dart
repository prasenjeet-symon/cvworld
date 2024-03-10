import 'dart:async';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class SubscriptionModel {
  final String nodeId;

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<UserSubscription>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));

  List<UserSubscription> _prevData = [];
  List<UserSubscription> _nextData = [];
  Timer? periodicTimer;

  SubscriptionModel({required this.nodeId}) {
    _storeName = 'subscription_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.SUBSCRIPTION) {
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
      _prevData.add(UserSubscription.fromRecord(element.value));
    }

    _nextData = _prevData;
    _emit();
  }

  // Save local data
  _saveLocal() async {
    var nodeStore = stringMapStoreFactory.store(_storeName);
    await nodeStore.delete(_database);
    for (var element in _nextData) {
      await nodeStore.record(element.subscriptionID).put(_database, element.toRecord(), merge: true);
    }
  }

  // emit
  _emit() {
    _source.add(ModelStore(status: ModelStoreStatus.ready, data: _nextData));
  }

  // Get
  _get() async {
    try {
      ApiResponse response = await singleCall(NetworkApi().getUserSubscription());
      if (response.statusCode == 200) {
        UserSubscription data = response.data;
        _nextData = [data];
        _prevData = [data];
        _emit();
        await _saveLocal();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Keep listening for the subscription status
  Future<void> keepListening() async {
    if (periodicTimer != null) {
      return;
    }

    // Set timeout with interval of 1 sec
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _get();
    });

    Timer(const Duration(seconds: ApplicationConfiguration.subscriptionWaitingTime), () {
      periodicTimer?.cancel();
      periodicTimer = null;
    });
  }

  // Cancel subscription
  Future<void> cancelSubscription() async {
    if (_nextData.isEmpty) {
      return;
    }

    _prevData = deepCopyList(_nextData);
    _nextData[0].isActive = false;
    _emit();

    try {
      ApiResponse response = await singleCall(NetworkApi().cancelSubscription());
      if (response.statusCode == 200) {
        MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.SUBSCRIPTION, null, MutationType.update));
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      // Rollback
      _nextData = deepCopyList(_prevData);
      _emit();
    }
  }

  // Is subscribed
  Stream<bool> isSubscribed() {
    return _source.stream.map((event) {
      return event.data.any((element) => element.isActive);
    });
  }

  // get subscription
  Stream<ModelStore<List<UserSubscription>>> get subscriptions => _source.stream;

  // Dispose
  dispose() {
    _source.close();
    _prevData = [];
    _nextData = [];
  }
}
