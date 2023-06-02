// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';

class SideBySideInputs extends StatelessWidget {
  final List<CustomInputField> inputFields;

  const SideBySideInputs({super.key, required this.inputFields});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        // Mobile version
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            children: [
              Expanded(child: inputFields[0]),
              Expanded(child: inputFields[1])
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: inputFields[0],
                ),
              ),
              Expanded(
                child: Container(
                  child: inputFields[1],
                ),
              )
            ],
          ),
        );
      }
    });
  }
}
