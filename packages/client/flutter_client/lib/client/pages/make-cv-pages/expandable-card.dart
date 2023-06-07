// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final Widget children;
  final DeleteFunction onDelete;
  final int index;

  const ExpandableCard(
      {super.key,
      required this.title,
      required this.children,
      required this.onDelete,
      required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  if (mounted) {
                    _isExpanded = !_isExpanded;
                  }
                });
              },
              title: Text(
                widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        if (mounted) {
                          _isExpanded = !_isExpanded;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 16,
                    ),
                    onPressed: () => widget.onDelete(widget.index),
                  ),
                ],
              ),
            ),
            _isExpanded
                ? Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: widget.children,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
