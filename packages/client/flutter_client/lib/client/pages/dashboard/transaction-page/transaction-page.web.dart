import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.dart';
import 'package:cvworld/client/shared/empty-data/empty-data.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class TransactionPageWeb extends StatelessWidget {
  const TransactionPageWeb({super.key});

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
                      child: Text('Transactions', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                    ),
                    // Sub heading
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      width: double.infinity,
                      child: Text('View all transactions of bought templates here', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 10),
                    // Search and refresh holder
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        // Refresh
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.refresh),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Search
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          width: 300,
                          child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Search...')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // TransactionList()
                    EmptyData(title: 'No Transactions', description: 'Look like you have no transactions yet. Buy some templates', image: 'transaction.png')
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
