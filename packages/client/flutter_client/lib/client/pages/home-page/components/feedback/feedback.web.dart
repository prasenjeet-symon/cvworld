import 'package:cvworld/client/pages/home-page/components/feedback/feedback.dart';
import 'package:flutter/material.dart';

class FeedbackWebComponent extends StatefulWidget {
  const FeedbackWebComponent({super.key});

  @override
  State<FeedbackWebComponent> createState() => _FeedbackWebComponentState();
}

class _FeedbackWebComponentState extends State<FeedbackWebComponent> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(context: context, builder: (context) => const FeedbackFormDialog());
      },
      child: const Icon(Icons.feedback),
    );
  }
}
