import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class WebsiteLinkSection extends StatefulWidget {
  final String title;
  final String description;

  const WebsiteLinkSection(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<WebsiteLinkSection> createState() => _WebsiteLinkSectionState();
}

class _WebsiteLinkSectionState extends State<WebsiteLinkSection> {
  getJSON() {}

  final CustomWebsiteLinkSection _CustomWebsiteLinkSection =
      CustomWebsiteLinkSection();

  addNewItem() {
    _CustomWebsiteLinkSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomWebsiteLinkSection.removeItem(index);
    setState(() {});
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
            margin: _CustomWebsiteLinkSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: _CustomWebsiteLinkSection.item
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
                    _CustomWebsiteLinkSection.item.isNotEmpty
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

/** 
 * 
 * 
 * 
 * 
 */
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

/** 
 * 
 * 
 * 
 */
class CustomWebsiteLinkItem {
  final CustomInputType label;
  final CustomInputType link;

  late CustomInputField labelField;
  late CustomInputField linkField;

  CustomWebsiteLinkItem({required this.label, required this.link});

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

  _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
  }

  addNewItem() {
    item.add(CustomWebsiteLinkItem(
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
    ));
  }

  void removeItem(int index) {
    item.removeAt(index);
  }
}
