import 'dart:async';
import 'dart:io';

import 'package:cvworld/client/datasource/http/error.manager.dart';
import 'package:cvworld/client/datasource/http/success.manager.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

///
///
///
///
class DatabaseManager {
  static final DatabaseManager _singleton = DatabaseManager._internal();

  DatabaseManager._internal();

  factory DatabaseManager() {
    return _singleton;
  }

  Database? _db;

  Future<Database> openDatabase() async {
    if (_db != null) {
      return _db!;
    }

    if (kIsWeb) {
      final dbFactory = databaseFactoryWeb;
      _db = await dbFactory.openDatabase(Constants.databaseName);
      return _db!;
    } else {
      // Specify the path where the database file will be stored
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/${Constants.applicationDirectory}';
      await Directory(folderPath).create(recursive: true);
      final filePath = '$folderPath/${Constants.databaseName}.db';

      // Open the database
      DatabaseFactory dbFactory = databaseFactoryIo;
      _db = await dbFactory.openDatabase(filePath);

      return _db!;
    }
  }

  // Dispose
  void dispose() {
    _db?.close();
    _db = null;
  }
}

///
///
///
///
List<T> deepCopyList<T extends Network<T>>(List<T> list) {
  return list.map((item) => item.deepCopy()).toList();
}

///
///
///
///
class MutationModel {
  static MutationModel? _instance;

  final _subject = StreamController<MutationModelData>.broadcast();

  Stream<MutationModelData> get observable => _subject.stream;

  MutationModel._(); // Private constructor

  static MutationModel getInstance() {
    _instance ??= MutationModel._();
    return _instance!;
  }

  // Dispatch
  void dispatch(MutationModelData data) {
    _subject.add(data);
  }

  // Dispose
  void dispose() {
    _subject.close();
  }
}

///
///
///
/// Notification Manager
class NotificationManager {
  late BuildContext ctx;
  static NotificationManager? _instance;

  NotificationManager._() {
    SuccessManager.getInstance().observable.listen((message) {
      showSuccess(message);
    });

    ErrorManager.getInstance().observable.listen((message) {
      showError(message);
    });
  }

  static NotificationManager getInstance({required BuildContext ctx}) {
    _instance ??= NotificationManager._();
    _instance!.ctx = ctx;
    return _instance!;
  }

  ///
  ///
  /// Show success snackbar
  void showSuccess(String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        },
      ),
    ));
  }

  ///
  ///
  /// Show error snackbar
  void showError(String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
            }),
      ),
    );
  }
}
