import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';

import 'types.dart';

class PersonalDetailSection extends StatefulWidget {
  final String title;
  final String description;
  final List<CustomInputType> inputs;

  const PersonalDetailSection(this.inputs,
      {super.key, required this.title, required this.description});

  @override
  State<PersonalDetailSection> createState() => _PersonalDetailSectionState();
}

class _PersonalDetailSectionState extends State<PersonalDetailSection> {
  bool _ShowMoreInputs = false;
  late List<CustomInputField> _UpperInputs;
  late final List<CustomInputField> _LowerInputs;

  @override
  void initState() {
    super.initState();

    _UpperInputs = widget.inputs
        .sublist(0, 6)
        .map((e) => CustomInputField(
            label: e.label,
            isRequired: e.isRequired,
            controller: e.controller,
            type: e.type))
        .toList();

    _LowerInputs = widget.inputs
        .sublist(6)
        .map((e) => CustomInputField(
            label: e.label,
            isRequired: e.isRequired,
            controller: e.controller,
            type: e.type))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
            child: const Text(
              'Personal Details',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
            child: const Text(
              'Enter your personal details below',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Column(
              children: [..._UpperInputs, if (_ShowMoreInputs) ..._LowerInputs],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 35, 0, 35),
            child: TextButton(
                onPressed: () {
                  setState(() {
                    _ShowMoreInputs = !_ShowMoreInputs;
                  });
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _ShowMoreInputs
                        ? const Text('Hide additional information')
                        : const Text('Show additional information'),
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Icon(
                        _ShowMoreInputs ? Icons.expand_less : Icons.expand_more,
                        color: Colors.blue,
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
