// expandable_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class ExpandableCardHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ExpandableCardHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: onTap,
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 16,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  final String title;
  final Widget children;
  final DeleteFunction onDelete;
  final int index;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.children,
    required this.onDelete,
    required this.index,
  });

  @override
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandableCardHeader(
              title: widget.title,
              isExpanded: _isExpanded,
              onTap: () {
                setState(() {
                  if (mounted) {
                    _isExpanded = !_isExpanded;
                  }
                });
              },
              onDelete: () => widget.onDelete(widget.index),
            ),
            if (_isExpanded) Container(padding: const EdgeInsets.all(5.0), child: Container(child: widget.children)),
          ],
        ),
      ),
    );
  }
}
