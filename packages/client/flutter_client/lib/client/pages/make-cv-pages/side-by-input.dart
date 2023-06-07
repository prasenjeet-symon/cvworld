// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';

class SideBySideInputs extends StatelessWidget {
  final List<CustomInputField> inputFields;

  const SideBySideInputs({super.key, required this.inputFields});

  List<Expanded> buildInput(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    return inputFields
        .asMap()
        .map((key, value) {
          return MapEntry(
              key,
              Expanded(
                child: Container(
                  margin: key > 0 && maxWidth > 600
                      ? const EdgeInsets.fromLTRB(15, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: value,
                ),
              ));
        })
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    if (maxWidth < 600) {
      // Mobile version
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          children: buildInput(context),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(children: buildInput(context)),
      );
    }
  }
}
