import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/subjects.dart';
import 'package:sembast/sembast.dart';

class FavoriteModel {
  final String nodeId; // userId

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<Template>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));

  List<Template> _prevData = [];
  List<Template> _nextData = [];

  FavoriteModel({required this.nodeId}) {
    _storeName = 'favorite_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.FAVORITE) {
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
      _prevData.add(Template.fromRecord(element.value));
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
      ApiResponse response = await singleCall(NetworkApi().getUserFavoriteTemplates());
      if (response.statusCode == 200) {
        List<Template> data = response.data;
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

  // Is this template favorite
  Stream<bool> isFavorite(Template template) {
    return _source.stream.map((event) {
      return event.data.any((element) => element.name == template.name);
    });
  }

  // Is this default
  Stream<bool> isDefault(Template template) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return storage.read(key: 'DefaultTemplate').asStream().map((event) {
      return event == template.name;
    });
  }

  // Add to default
  Future<void> addToDefault(Template template) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(key: 'DefaultTemplate', value: template.name);
    MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.FAVORITE, template, MutationType.create));
  }

  // Add to favorite
  Future<void> addToFavorite(Template template) async {
    _prevData = deepCopyList(_nextData);
    _nextData.add(template);
    _emit();

    try {
      await singleCall(NetworkApi().addTemplateToFavorites(template.name));
      await _saveLocal();

      MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.FAVORITE, template, MutationType.create));
      return;
    } catch (e) {
      ErrorManager.getInstance().dispatch('Cannot add to favorite');
      if (kDebugMode) {
        print(e);
      }

      // Rollback
      _nextData = deepCopyList(_prevData);
      _emit();
      return;
    }
  }

  // Remove from favorite
  Future<void> removeFromFavorite(Template template) async {
    _prevData = deepCopyList(_nextData);
    _nextData.removeWhere((element) => element.name == template.name);
    _emit();

    try {
      await singleCall(NetworkApi().removeTemplateFromFavorites(template.name));
      await _saveLocal();

      MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.FAVORITE, template, MutationType.delete));
      return;
    } catch (e) {
      ErrorManager.getInstance().dispatch('Cannot remove from favorite');
      if (kDebugMode) {
        print(e);
      }

      // Rollback
      _nextData = deepCopyList(_prevData);
      _emit();
      return;
    }
  }

  // Dispose
  dispose() {
    _source.close();
    _nextData = [];
    _prevData = [];
  }
}
