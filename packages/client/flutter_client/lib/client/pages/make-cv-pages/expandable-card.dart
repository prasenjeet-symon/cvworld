// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final Widget children;
  final DeleteFunction onDelete;

  const ExpandableCard(
      {super.key,
      required this.title,
      required this.children,
      required this.onDelete});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
                title: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: widget.onDelete,
                    ),
                  ],
                )),
            if (_isExpanded)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: widget.children,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
