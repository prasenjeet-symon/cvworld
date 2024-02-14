import 'dart:async';

import 'package:cvworld/client/datasource/schema.dart' as clientSchema;
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/dashboard/feedback_page/feedback_page.controller.admin.dart';
import 'package:cvworld/dashboard/dashboard/users/user_profile_page.dart';
import 'package:cvworld/dashboard/datasource/network.media.api.admin.dart';
import 'package:flutter/material.dart';

class FeedbackPageWebAdmin extends StatefulWidget {
  const FeedbackPageWebAdmin({Key? key}) : super(key: key);

  @override
  State<FeedbackPageWebAdmin> createState() => _FeedbackPageWebAdminState();
}

class _FeedbackPageWebAdminState extends State<FeedbackPageWebAdmin> {
  bool isLoading = true;
  List<clientSchema.Feedback> feedbacks = [];
  TextEditingController searchController = TextEditingController();
  FeedbackPageControllerAdmin controller = FeedbackPageControllerAdmin();
  StreamSubscription<clientSchema.ModelStore<List<clientSchema.Feedback>>>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = controller.getAllFeedback().listen((value) {
      if (mounted) {
        setState(() {
          isLoading = value.status == clientSchema.ModelStoreStatus.booting ? true : false;
          feedbacks = value.data;
        });
      }
    });

    // Listen for the search
    searchController.addListener(() {
      String query = searchController.text;
      controller.search(query);
    });
  }

  // Delete feedback
  void deleteFeedback(clientSchema.Feedback feedback) {
    controller.deleteFeedback(feedback);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: SearchHeaderDelegate(searchController: searchController),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 300),
            sliver: isLoading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                : !isLoading && feedbacks.isNotEmpty
                    ? SliverList.builder(
                        itemBuilder: (context, index) {
                          var feedback = feedbacks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                                    child: const Icon(Icons.feedback, size: 30),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(feedback.title, style: Theme.of(context).textTheme.headlineSmall),
                                        const SizedBox(height: 15),
                                        Chip(
                                          label: Text(feedback.department),
                                          labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(feedback.description, style: Theme.of(context).textTheme.bodyMedium),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [Expanded(child: Text(formatDateTime(feedback.createdAt), style: Theme.of(context).textTheme.bodySmall)), Text(feedback.email, style: Theme.of(context).textTheme.bodySmall)],
                                        ),
                                      ],
                                    ),
                                  ),
                                  feedback.attachment != null
                                      ? IconButton(
                                          onPressed: () {
                                            openLinkInBrowser(NetworkMediaApiAdmin.publicResource(feedback.attachment!));
                                          },
                                          icon: const Icon(Icons.attachment, size: 20))
                                      : const SizedBox(),
                                  IconButton(
                                    iconSize: 12,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      deleteFeedback(feedback);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: feedbacks.length)
                    : const SliverFillRemaining(child: NoResultFound(icon: Icons.feedback, heading: 'No Feedback', description: 'No feedback yet! Once your user sends a feedback, you will see it here.')),
          ),
        ],
      ),
    );
  }
}

///
///
///
///
class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;

  SearchHeaderDelegate({required this.searchController});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0))),
      width: double.infinity,
      child: Row(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back)),
              Text('Feedback', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const Spacer(),
          // Search
          SizedBox(
            width: 250,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 1.0),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => 100.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
