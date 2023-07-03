// ignore: file_names
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class WebsiteLinkSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const WebsiteLinkSection({
    Key? key,
    required this.title,
    required this.description,
    this.resume,
  }) : super(key: key);

  @override
  State<WebsiteLinkSection> createState() => WebsiteLinkSectionState();
}

class WebsiteLinkSectionState extends State<WebsiteLinkSection> {
  final CustomWebsiteLinkSection _customWebsiteLinkSection =
      CustomWebsiteLinkSection();

  List<Links> getData() {
    return _customWebsiteLinkSection.item
        .map((e) => {Links(e.label.controller.text, e.link.controller.text)})
        .expand((element) => element)
        .toList();
  }

  addNewItem() {
    _customWebsiteLinkSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _customWebsiteLinkSection.removeItem(index);
    setState(() {});
  }

  @override
  void initState() {
    _customWebsiteLinkSection.resume = widget.resume;
    _customWebsiteLinkSection
        .fetchWebsiteLinks()
        .then((value) => {setState(() {})});

    super.initState();
  }

  @override
  void dispose() {
    _customWebsiteLinkSection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            margin: _customWebsiteLinkSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: _customWebsiteLinkSection.item
                  .asMap()
                  .map(
                    (i, e) => MapEntry(
                        i,
                        WebsiteLinkItem(
                          websiteLinkItem: e,
                          onDelete: removeItem,
                          index: i,
                        )),
                  )
                  .values
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: TextButton(
                onPressed: () => addNewItem(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _customWebsiteLinkSection.item.isNotEmpty
                        ? const Text('Add one more link')
                        : const Text('Add link'),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: const Icon(Icons.add),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

///
///
///
///
///
///
class WebsiteLinkItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomWebsiteLinkItem websiteLinkItem;
  final int index;

  const WebsiteLinkItem(
      {super.key,
      required this.onDelete,
      required this.websiteLinkItem,
      required this.index});

  @override
  State<WebsiteLinkItem> createState() => _WebsiteLinkItemState();
}

class _WebsiteLinkItemState extends State<WebsiteLinkItem> {
  @override
  void initState() {
    super.initState();
    widget.websiteLinkItem.generateCustomInputFields();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Website & Link Item',
      onDelete: widget.onDelete,
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.websiteLinkItem.labelField,
                widget.websiteLinkItem.linkField,
              ].toList(),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
///
///
///
class CustomWebsiteLinkItem {
  final int id;
  final CustomInputType label;
  final CustomInputType link;

  late CustomInputField labelField;
  late CustomInputField linkField;

  BehaviorSubject<int> controller = BehaviorSubject<int>();

  CustomWebsiteLinkItem({
    required this.id,
    required this.label,
    required this.link,
  });

  // listen for the changes
  Stream<int> listenForChanges() {
    label.controller.addListener(() {
      controller.add(id);
    });

    link.controller.addListener(() {
      controller.add(id);
    });

    return controller
        .debounceTime(const Duration(milliseconds: Constants.debounceTime));
  }

  // dispose
  dispose() {
    labelField.controller.dispose();
    linkField.controller.dispose();

    // remove listeners
    labelField.controller.removeListener(() {});
    linkField.controller.removeListener(() {});

    controller.close();
  }

  generateCustomInputFields() {
    labelField = CustomInputField(
      label: label.label,
      isRequired: label.isRequired,
      controller: label.controller,
      type: label.type,
    );

    linkField = CustomInputField(
      label: link.label,
      isRequired: link.isRequired,
      controller: link.controller,
      type: link.type,
    );
  }
}

class CustomWebsiteLinkSection {
  List<CustomWebsiteLinkItem> item = [];
  final List<TextEditingController> _controllers = [];
  List<UserLink> _userLinks = [];
  Resume? resume;

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  dispose() {
    for (var element in item) {
      element.dispose();
    }
  }

  // fetch website links
  Future<void> fetchWebsiteLinks() async {
    if (resume.isNull) {
      var fetchedLinks = await DatabaseService().fetchUserLinks();
      if (fetchedLinks.isNull) return;
      _userLinks = fetchedLinks!;

      for (var element in _userLinks) {
        var linkController = _addController();
        linkController.text = element.url;

        var labelController = _addController();
        labelController.text = element.title;

        var itemToAdd = CustomWebsiteLinkItem(
          id: element.id,
          label: CustomInputType(
            'Label',
            'label',
            true,
            labelController,
            TextInputType.text,
          ),
          link: CustomInputType(
            'Link',
            'link',
            true,
            linkController,
            TextInputType.text,
          ),
        );

        item.add(itemToAdd);

        itemToAdd.listenForChanges().listen((event) {
          updateItem(event);
        });
      }
    }
  }

  // get latest id
  int getLatestId() {
    int id = 0;
    for (var element in item) {
      if (element.id > id) {
        id = element.id;
      }
    }

    return id + 1;
  }

  Future<void> addNewItem() async {
    var id = getLatestId();

    var itemToAdd = CustomWebsiteLinkItem(
      id: id,
      label: CustomInputType(
        'Label',
        'label',
        true,
        _addController(),
        TextInputType.text,
      ),
      link: CustomInputType(
        'Link',
        'link',
        true,
        _addController(),
        TextInputType.text,
      ),
    );

    item.add(itemToAdd);

    if (resume.isNull) {
      // add to the database
      itemToAdd.listenForChanges().listen((event) {
        updateItem(event);
      });

      var itemForDatabase = UserLink(
        itemToAdd.id,
        itemToAdd.labelField.controller.text,
        itemToAdd.linkField.controller.text,
        DateTime.now(),
        DateTime.now(),
      );

      await DatabaseService().addUpdateUserLink(itemForDatabase);
      _userLinks.add(itemForDatabase);
    }

    Fluttertoast.showToast(
      msg: 'Added a new link',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // update the website link
  Future<void> updateItem(int id) async {
    var itemToUpdateIndex = item.indexWhere((element) => element.id == id);
    if (itemToUpdateIndex == -1) return;
    var updateItem = item[itemToUpdateIndex];

    var itemForDatabase = UserLink(
      updateItem.id,
      updateItem.labelField.controller.text,
      updateItem.linkField.controller.text,
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserLink(itemForDatabase);
    var savedItemIndex = _userLinks.indexWhere((element) => element.id == id);
    if (savedItemIndex != -1) {
      _userLinks[savedItemIndex] = itemForDatabase;
    }

    Fluttertoast.showToast(
      msg: 'Link updated',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> removeItem(int index) async {
    var itemToRemove = item[index];
    itemToRemove.dispose();
    item.removeAt(index);

    if (resume.isNull) {
      var itemToRemoveDatabaseIndex =
          _userLinks.indexWhere((element) => element.id == itemToRemove.id);
      if (itemToRemoveDatabaseIndex != -1) {
        _userLinks.removeAt(itemToRemoveDatabaseIndex);

        await DatabaseService()
            .deleteUserLink(DeleteDocuments(itemToRemove.id));
      }
    }

    Fluttertoast.showToast(
      msg: 'Removed a link',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
