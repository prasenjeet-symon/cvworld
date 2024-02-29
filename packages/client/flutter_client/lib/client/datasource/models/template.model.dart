import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/mapping.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class TemplateModel {
  final String nodeId;

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<Template>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));
  // Search source
  final _searchSource = BehaviorSubject<String?>.seeded(null);

  List<Template> _prevData = [];
  List<Template> _nextData = [];

  TemplateModel({required this.nodeId}) {
    _storeName = 'template_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.TEMPLATE || event.identifier == MutationModelIdentifier.FAVORITE) {
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
      ApiResponse response = await singleCall(NetworkApi().getTemplates());
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

  // Get searched templates with fav status
  Stream<ModelStore<List<Template>>> getTemplates(String userId) {
    // Stream with fav status
    Stream<ModelStore<List<Template>>> streamWithFav$ = _source.switchMap((value) {
      return CombineLatestStream(value.data.map((e) {
        return UserToFavoriteMapping.getInstance().get(userId).isFavorite(e);
      }), (everyStatus) {
        return ModelStore(
          status: value.status,
          data: value.data.asMap().entries.map((e) {
            e.value.isMyFavourite = everyStatus[e.key];
            return e.value;
          }).toList(),
        );
      });
    });

    // Stream with default
    Stream<ModelStore<List<Template>>> streamWithDefault$ = streamWithFav$.switchMap((value) {
      return CombineLatestStream(value.data.map((e) {
        return UserToFavoriteMapping.getInstance().get(userId).isDefault(e);
      }), (everyStatus) {
        return ModelStore(
          status: value.status,
          data: value.data.asMap().entries.map((e) {
            e.value.isMyDefault = everyStatus[e.key];
            return e.value;
          }).toList(),
        );
      });
    });

    return _searchSource.stream.switchMap((value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return streamWithDefault$;
      } else {
        // Search with regex
        return streamWithDefault$.map((event) {
          return ModelStore(
            status: event.status,
            data: event.data.where((element) => RegExp(value, caseSensitive: false, multiLine: true).hasMatch('${element.name} ${element.displayDescription} ${element.displayName} ${formatAsIndianRupee(element.price)}')).toList(),
          );
        });
      }
    });
  }

  // Dispose
  dispose() {
    _source.close();
    _nextData = [];
    _prevData = [];
  }

  // Search
  void search(String query) {
    _searchSource.add(query);
  }
}
