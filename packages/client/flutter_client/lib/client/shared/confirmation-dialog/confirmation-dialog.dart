import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final Function()? onConfirm;
  final Function()? onCancel;

  ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
            Navigator.of(context).pop(false);
          },
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }
            Navigator.of(context).pop(true);
          },
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
