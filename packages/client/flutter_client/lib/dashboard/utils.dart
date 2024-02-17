import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

Future<bool> isAdminAuthenticated() async {
  var isAuthenticated = await const FlutterSecureStorage().read(key: 'JWT_ADMIN');
  if (isAuthenticated == null) {
    return false;
  } else {
    return true;
  }
}

///
///
///
/// Delete conformation dialog

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmationDialog({Key? key, required this.title, required this.content, required this.onConfirm, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.black54, fontSize: 16.0)),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
          child: const Text('Delete', style: TextStyle(fontSize: 16.0)),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.white,
      elevation: 4.0,
    );
  }
}
