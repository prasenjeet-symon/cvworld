import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/utils.dart';

class SideBySideInputs extends StatelessWidget {
  final List<CustomInputField> inputFields;

  const SideBySideInputs({super.key, required this.inputFields});

  List<Flexible> buildInput(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;
    return inputFields
        .asMap()
        .map((key, value) {
          return MapEntry(
              key,
              Flexible(
                child: Container(
                  margin: isMobile
                      ? const EdgeInsets.fromLTRB(0, 5, 0, 5)
                      : key > 0 && !isMobile
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
    final bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Container(
      margin: isMobile ? const EdgeInsets.symmetric(vertical: 5) : const EdgeInsets.symmetric(vertical: 15),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: buildInput(context),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: buildInput(context),
            ),
    );
  }
}
