import 'dart:async';

import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/domain-page/domain-page.controller.dart';
import 'package:cvworld/client/pages/dashboard/domain-page/domain-page.mobile.dart';
import 'package:cvworld/client/pages/dashboard/domain-page/domain-page.web.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class DomainPage extends StatelessWidget {
  const DomainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return const DomainPageMobile();
      } else {
        return const DomainPageWeb();
      }
    });
  }
}

///
///
///

class DomainCard extends StatefulWidget {
  const DomainCard({Key? key}) : super(key: key);

  @override
  State<DomainCard> createState() => _DomainCardState();
}

class _DomainCardState extends State<DomainCard> {
  final DomainPageController controller = DomainPageController();
  StreamSubscription? _subscription;
  bool isLoading = true;
  User? user;

  @override
  void initState() {
    super.initState();

    _subscription = controller.getUser().listen((event) {
      if (mounted) {
        setState(() {
          user = event.data.isNotEmpty ? event.data[0] : null;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Card(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Left Logo
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              width: isMobile ? 50 : 100,
              height: isMobile ? 50 : 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/web-link.png'),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text heading
                  Text(
                    '${user?.userName ?? ''}.${ApplicationConfiguration.apiUrl.replaceAll('https://', '').replaceAll('http://', '')}',
                    style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Sub heading
                  Text(
                    'Give your HR a personal domain to showcase your skills and portfolio',
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: const Color.fromARGB(255, 82, 82, 82),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
