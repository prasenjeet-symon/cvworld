import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';

import 'types.dart';

class PersonalDetailSection extends StatefulWidget {
  final String title;
  final String description;

  const PersonalDetailSection(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<PersonalDetailSection> createState() => _PersonalDetailSectionState();
}

class _PersonalDetailSectionState extends State<PersonalDetailSection> {
  final List<TextEditingController> _controllers = [];
  bool _canShowInputs = false;

  final List<CustomInputType> inputs = [];
  late final List<CustomInputField> _upperInputs;
  late final List<SideBySideInputs> _upperInputsSideBySide = [];
  late final List<CustomInputField> _lowerInputs;
  late final List<SideBySideInputs> _lowerInputsSideBySide = [];

  getJson() {}

  // Get the controller
  TextEditingController _getController() {
    TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  /// Add all fields
  addAllFields() {
    // Job title
    CustomInputType jobTitle = CustomInputType(
      'Job Title',
      'jobTitle',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(jobTitle);

    // First name
    CustomInputType firstName = CustomInputType(
      'First Name',
      'firstName',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(firstName);

    // for the last name
    CustomInputType lastName = CustomInputType(
      'Last Name',
      'lastName',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(lastName);

    // for the email
    CustomInputType email = CustomInputType(
      'Email',
      'email',
      true,
      _getController(),
      TextInputType.emailAddress,
    );
    inputs.add(email);

    // for the phone
    CustomInputType phone = CustomInputType(
      'Phone',
      'phone',
      true,
      _getController(),
      TextInputType.phone,
    );
    inputs.add(phone);

    // for the Country
    CustomInputType country = CustomInputType(
      'Country',
      'country',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(country);

    // City
    CustomInputType city = CustomInputType(
      'City',
      'city',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(city);

    // Address
    CustomInputType address = CustomInputType(
      'Address',
      'address',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(address);

    // for postal code
    CustomInputType postalCode = CustomInputType(
      'Postal Code',
      'postalCode',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(postalCode);

    // Driving License
    CustomInputType drivingLicense = CustomInputType(
      'Driving License',
      'drivingLicense',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(drivingLicense);

    // for the Nationality
    CustomInputType nationality = CustomInputType(
      'Nationality',
      'nationality',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(nationality);

    // for the place of birth
    CustomInputType placeOfBirth = CustomInputType(
      'Place Of Birth',
      'placeOfBirth',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(placeOfBirth);

    // for date of birth
    CustomInputType dateOfBirth = CustomInputType(
      'Date Of Birth',
      'dateBirthDate',
      true,
      _getController(),
      TextInputType.text,
    );
    inputs.add(dateOfBirth);
  }

  toggleLowerSection() {
    if (mounted) {
      setState(() {
        _canShowInputs = !_canShowInputs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    addAllFields();

    _upperInputs = inputs
        .sublist(0, 6)
        .map((e) => CustomInputField(
            label: e.label,
            isRequired: e.isRequired,
            controller: e.controller,
            type: e.type))
        .toList();

    _lowerInputs = inputs
        .sublist(6)
        .map((e) => CustomInputField(
            label: e.label,
            isRequired: e.isRequired,
            controller: e.controller,
            type: e.type))
        .toList();

    int _upperInputsHelperIndex = -1;
    for (int i = 0; i < _upperInputs.length; i++) {
      if (_upperInputsHelperIndex == i) continue;
      if (i < _upperInputs.length - 1) {
        _upperInputsSideBySide.add(SideBySideInputs(
            inputFields: [_upperInputs[i], _upperInputs[i + 1]]));
        _upperInputsHelperIndex = i + 1;
      } else {
        _upperInputsSideBySide
            .add(SideBySideInputs(inputFields: [_upperInputs[i]]));
      }
    }

    int _lowerInputsHelperIndex = -1;
    for (int i = 0; i < _lowerInputs.length; i++) {
      if (_lowerInputsHelperIndex == i) continue;
      if (i < _lowerInputs.length - 1) {
        _lowerInputsSideBySide.add(SideBySideInputs(
            inputFields: [_lowerInputs[i], _lowerInputs[i + 1]]));
        _lowerInputsHelperIndex = i + 1;
      } else {
        _lowerInputsSideBySide
            .add(SideBySideInputs(inputFields: [_lowerInputs[i]]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 45, 0, 45),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              widget.description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ..._upperInputsSideBySide,
                if (_canShowInputs) ..._lowerInputsSideBySide
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: TextButton(
              onPressed: toggleLowerSection,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  !_canShowInputs
                      ? const Text('Edit additional details')
                      : const Text('Hide additional details'),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: !_canShowInputs
                        ? const Icon(Icons.expand_more)
                        : const Icon(Icons.expand_less_sharp),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
