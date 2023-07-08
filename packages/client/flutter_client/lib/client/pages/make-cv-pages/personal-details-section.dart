import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import 'types.dart';

class PersonalDetailSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const PersonalDetailSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<PersonalDetailSection> createState() => PersonalDetailSectionState();
}

class PersonalDetailSectionState extends State<PersonalDetailSection> {
  final List<TextEditingController> _controllers = [];
  bool _canShowInputs = false;
  UserDetails? _userDetails;
  final BehaviorSubject<int> _userDetailsSubject = BehaviorSubject();

  final List<CustomInputType> inputs = [];
  late final List<CustomInputField> _upperInputs;
  late final List<SideBySideInputs> _upperInputsSideBySide = [];
  late final List<CustomInputField> _lowerInputs;
  late final List<SideBySideInputs> _lowerInputsSideBySide = [];
  late final CustomInputType defaultField;

  Map<String, dynamic> getExtraData() {
    return {
      'profession': inputs.firstWhere((element) => element.jsonKey == 'profession').controller.text,
      'name': '${inputs.firstWhere((element) => element.jsonKey == 'firstName').controller.text} ${inputs.firstWhere((element) => element.jsonKey == 'lastName').controller.text}',
    };
  }

  Details getData() {
    return Details(
      inputs.firstWhere((element) => element.jsonKey == 'email').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'phone').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'country').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'city').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'address').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'postalCode').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'drivingLicense').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'nationality').controller.text,
      inputs.firstWhere((element) => element.jsonKey == 'placeOfBirth').controller.text,
      DateTime.parse(inputs.firstWhere((element) => element.jsonKey == 'dateOfBirth').controller.text.isEmpty ? DateTime.now().toIso8601String() : inputs.firstWhere((element) => element.jsonKey == 'dateOfBirth').controller.text),
    );
  }

  TextEditingController _getController() {
    TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  addAllFields() {
    // Job title
    CustomInputType jobTitle = CustomInputType('Job Title', 'profession', true, _getController(), TextInputType.text);
    inputs.add(jobTitle);

    // First name
    CustomInputType firstName = CustomInputType('First Name', 'firstName', true, _getController(), TextInputType.text);
    inputs.add(firstName);

    // for the last name
    CustomInputType lastName = CustomInputType('Last Name', 'lastName', true, _getController(), TextInputType.text);
    inputs.add(lastName);

    // for the email
    CustomInputType email = CustomInputType('Email', 'email', true, _getController(), TextInputType.emailAddress);
    inputs.add(email);

    // for the phone
    CustomInputType phone = CustomInputType('Phone', 'phone', true, _getController(), TextInputType.phone);
    inputs.add(phone);

    // for the Country
    CustomInputType country = CustomInputType('Country', 'country', true, _getController(), TextInputType.text);
    inputs.add(country);

    // City
    CustomInputType city = CustomInputType('City', 'city', true, _getController(), TextInputType.text);
    inputs.add(city);

    // Address
    CustomInputType address = CustomInputType('Address', 'address', true, _getController(), TextInputType.text);
    inputs.add(address);

    // for postal code
    CustomInputType postalCode = CustomInputType('Postal Code', 'postalCode', true, _getController(), TextInputType.text);
    inputs.add(postalCode);

    // Driving License
    CustomInputType drivingLicense = CustomInputType('Driving License', 'drivingLicense', true, _getController(), TextInputType.text);
    inputs.add(drivingLicense);

    // for the Nationality
    CustomInputType nationality = CustomInputType('Nationality', 'nationality', true, _getController(), TextInputType.text);
    inputs.add(nationality);

    // for the place of birth
    CustomInputType placeOfBirth = CustomInputType('Place Of Birth', 'placeOfBirth', true, _getController(), TextInputType.text);
    inputs.add(placeOfBirth);

    // for date of birth
    CustomInputType dateOfBirth = CustomInputType('Date Of Birth', 'dateOfBirth', true, _getController(), TextInputType.datetime);
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
    print('personal details section init');
    super.initState();

    defaultField = CustomInputType('Default', 'default', true, _getController(), TextInputType.text);
    addAllFields();

    _upperInputs = inputs.sublist(0, 6).map((e) => CustomInputField(label: e.label, isRequired: e.isRequired, controller: e.controller, type: e.type)).toList();
    _lowerInputs = inputs.sublist(6).map((e) => CustomInputField(label: e.label, isRequired: e.isRequired, controller: e.controller, type: e.type)).toList();

    int upperInputsHelperIndex = -1;
    for (int i = 0; i < _upperInputs.length; i++) {
      if (upperInputsHelperIndex == i) continue;
      if (i < _upperInputs.length - 1) {
        _upperInputsSideBySide.add(SideBySideInputs(inputFields: [_upperInputs[i], _upperInputs[i + 1]]));
        upperInputsHelperIndex = i + 1;
      } else {
        _upperInputsSideBySide.add(SideBySideInputs(inputFields: [_upperInputs[i]]));
      }
    }

    int lowerInputsHelperIndex = -1;
    for (int i = 0; i < _lowerInputs.length; i++) {
      if (lowerInputsHelperIndex == i) continue;
      if (i < _lowerInputs.length - 1) {
        _lowerInputsSideBySide.add(SideBySideInputs(inputFields: [_lowerInputs[i], _lowerInputs[i + 1]]));
        lowerInputsHelperIndex = i + 1;
      } else {
        _lowerInputsSideBySide.add(SideBySideInputs(inputFields: [_lowerInputs[i]]));
      }
    }

    // Fetch the old data if the resume id is provided
    // if resume id is not provided then fetch the user details from the server and patch it
    print(widget.resume.isNull);
    print(widget.resume);
    if (widget.resume.isNull) {
      _fetchPersonalDetails();
      // listen for changes and update
      listenForChanges();
      _userDetailsSubject.debounceTime(const Duration(milliseconds: Constants.debounceTime)).listen((event) {
        updatePersonalDetails();
      });
    }

    patchResume();
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.removeListener(() {});
      element.dispose();
    }

    _userDetailsSubject.close();

    super.dispose();
  }

  // listen for the changes
  void listenForChanges() {
    for (var element in _controllers) {
      element.addListener(() {
        _userDetailsSubject.add(0);
      });
    }
  }

  // patch the resume
  Future<void> patchResume() async {
    if (widget.resume.isNull) return;

    inputs.firstWhere((element) => element.jsonKey == 'firstName').controller.text = widget.resume!.name.split(' ')[0];
    inputs.firstWhere((element) => element.jsonKey == 'lastName').controller.text = widget.resume!.name.split(' ')[1];

    // for the profession
    inputs.firstWhere((element) => element.jsonKey == 'profession').controller.text = widget.resume!.profession;

    // for the email
    inputs.firstWhere((element) => element.jsonKey == 'email').controller.text = widget.resume!.details.email;

    // for the phone
    inputs.firstWhere((element) => element.jsonKey == 'phone').controller.text = widget.resume!.details.phone;

    // for the Country
    inputs.firstWhere((element) => element.jsonKey == 'country').controller.text = widget.resume!.details.country;

    // for the City
    inputs.firstWhere((element) => element.jsonKey == 'city').controller.text = widget.resume!.details.city;

    // for the Address
    inputs.firstWhere((element) => element.jsonKey == 'address').controller.text = widget.resume!.details.address;

    // for the postal code
    inputs.firstWhere((element) => element.jsonKey == 'postalCode').controller.text = widget.resume!.details.postalCode;

    // for the Driving License
    inputs.firstWhere((element) => element.jsonKey == 'drivingLicense').controller.text = widget.resume!.details.drivingLicense;

    // for the Nationality
    inputs.firstWhere((element) => element.jsonKey == 'nationality').controller.text = widget.resume!.details.nationality;

    // for the place of birth
    inputs.firstWhere((element) => element.jsonKey == 'placeOfBirth').controller.text = widget.resume!.details.placeOfBirth;

    // for the date of birth
    inputs.firstWhere((element) => element.jsonKey == 'dateOfBirth').controller.text = widget.resume!.details.dateOfBirth.toIso8601String();

    setState(() {});
  }

  // Fetch the personal details from the server
  _fetchPersonalDetails() async {
    // Fetch the personal details from the server
    var userDetail = await DatabaseService().fetchUserDetails();
    if (userDetail.isNull) {
      return;
    }

    _userDetails = userDetail;

    // Patch the personal details by updating the controller
    // for the first name
    inputs.firstWhere((element) => element.jsonKey == 'firstName').controller.text = userDetail!.name.split(' ')[0];

    // for the last name
    inputs.firstWhere((element) => element.jsonKey == 'lastName').controller.text = userDetail.name.split(' ')[1];

    // for the profession
    inputs.firstWhere((element) => element.jsonKey == 'profession').controller.text = userDetail.profession;

    // for the email
    inputs.firstWhere((element) => element.jsonKey == 'email').controller.text = userDetail.email;

    // for the phone
    inputs.firstWhere((element) => element.jsonKey == 'phone').controller.text = userDetail.phone;

    // for the Country
    inputs.firstWhere((element) => element.jsonKey == 'country').controller.text = userDetail.country;

    // for the City
    inputs.firstWhere((element) => element.jsonKey == 'city').controller.text = userDetail.city;

    // for the Address
    inputs.firstWhere((element) => element.jsonKey == 'address').controller.text = userDetail.address;

    // for the postal code
    inputs.firstWhere((element) => element.jsonKey == 'postalCode').controller.text = userDetail.postalCode;

    // for the Driving License
    inputs.firstWhere((element) => element.jsonKey == 'drivingLicense').controller.text = userDetail.drivingLicense;

    // for the Nationality
    inputs.firstWhere((element) => element.jsonKey == 'nationality').controller.text = userDetail.nationality;

    // for the place of birth
    inputs.firstWhere((element) => element.jsonKey == 'placeOfBirth').controller.text = userDetail.placeOfBirth;

    // for the date of birth
    inputs.firstWhere((element) => element.jsonKey == 'dateOfBirth').controller.text = userDetail.dateOfBirth.toIso8601String();

    setState(() {});
  }

  // add update personal details
  Future<void> updatePersonalDetails() async {
    var userDetail = getData();
    var extraData = getExtraData();

    UserDetails userDetailFinal = UserDetails(
      _userDetails.isNull ? 0 : _userDetails!.id,
      extraData['profession'],
      extraData['name'],
      userDetail.email,
      userDetail.phone,
      userDetail.country,
      userDetail.city,
      userDetail.address,
      userDetail.postalCode,
      userDetail.drivingLicense,
      userDetail.nationality,
      userDetail.placeOfBirth,
      userDetail.dateOfBirth,
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserDetails(userDetailFinal);
    Fluttertoast.showToast(msg: 'Personal details updated successfully', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
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
              children: [..._upperInputsSideBySide, if (_canShowInputs) ..._lowerInputsSideBySide],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: TextButton(
              onPressed: toggleLowerSection,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  !_canShowInputs ? const Text('Edit additional details') : const Text('Hide additional details'),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: !_canShowInputs ? const Icon(Icons.expand_more) : const Icon(Icons.expand_less_sharp),
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
