import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/datasource/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:sembast/sembast.dart';

class UserModel {
  final String nodeId;

  late Database _database;
  late String _storeName;

  final _source = BehaviorSubject<ModelStore<List<User>>>.seeded(ModelStore(status: ModelStoreStatus.booting, data: []));

  List<User> _prevData = [];
  List<User> _nextData = [];

  UserModel({required this.nodeId}) {
    _storeName = 'user_store_$nodeId';

    MutationModel.getInstance().observable.listen((event) {
      if (event.identifier == MutationModelIdentifier.USER) {
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
      _prevData.add(User.fromRecord(element.value));
    }

    _nextData = _prevData;
    _emit();
  }

  // Save local data
  _saveLocal() async {
    var nodeStore = stringMapStoreFactory.store(_storeName);
    await nodeStore.delete(_database);
    for (var element in _nextData) {
      await nodeStore.record(element.reference).put(_database, element.toRecord(), merge: true);
    }
  }

  // emit
  _emit() {
    _source.add(ModelStore(status: ModelStoreStatus.ready, data: _nextData));
  }

  // get
  _get() async {
    try {
      ApiResponse response = await singleCall(NetworkApi().getUser());
      if (response.statusCode == 200) {
        User data = response.data;
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

  // Get single user
  Stream<ModelStore<List<User>>> getUser() {
    return _source.stream;
  }

  ///
  ///
  /// Update user
  Future<void> updateUser(User user) async {
    _prevData = deepCopyList(_nextData);
    _nextData = [user];
    _emit();

    try {
      try {
        await user.uploadProfilePicture((progress) => _emit(), (error) => throw error); // upload avatar
      } catch (e) {
        ErrorManager.getInstance().dispatch('Cannot upload profile picture for user');
        if (kDebugMode) {
          print('updateUser :: cannot upload profile picture for user');
          print(e);
        }
      }

      await singleCall(NetworkApi().updateUser(user));
      await _saveLocal();

      MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.USER, user, MutationType.update));
      return;
    } catch (e) {
      ErrorManager.getInstance().dispatch('Cannot update user. Please try again.');
      if (kDebugMode) {
        print('updateUser :: cannot update user');
        print(e);
      }

      // Rollback
      _nextData = deepCopyList(_prevData);
      _emit();

      return;
    }
  }

  // Delete user
  Future<void> deleteUser() async {
    try {
      await singleCall(NetworkApi().deleteUser());
      await _saveLocal();
      await ApplicationToken.getInstance().deleteToken();
      MutationModel.getInstance().dispatch(MutationModelData(MutationModelIdentifier.USER, null, MutationType.delete));
      return;
    } catch (e) {
      ErrorManager.getInstance().dispatch('Cannot delete user. Please try again.');

      if (kDebugMode) {
        print('deleteUser :: cannot delete user');
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
    _prevData = [];
    _nextData = [];
  }
}
