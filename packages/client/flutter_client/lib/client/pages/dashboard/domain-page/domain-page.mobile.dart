import 'package:cvworld/client/pages/dashboard/domain-page/domain-page.dart';
import 'package:flutter/material.dart';

class DomainPageMobile extends StatelessWidget {
  const DomainPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width * 0.95,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    DomainCard(),
                  ],
                ),
              ),
              // Put page footer if needed just below
            ],
          ),
        ),
      ),
    );
  }
}
