import 'package:cvworld/client/pages/dashboard/domain-page/domain-page.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class DomainPageWeb extends StatelessWidget {
  const DomainPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width * ApplicationConfiguration.pageContentWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back Button
                    BackButtonApp(onPressed: () => Navigator.pop(context)),
                    const SizedBox(height: 50),
                    // Page Heading
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      width: double.infinity,
                      child: const Text('Domain', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                    ),
                    // Sub heading
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      width: double.infinity,
                      child: Text('Get your own personal domain in few clicks', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 10),
                    const DomainCard()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
