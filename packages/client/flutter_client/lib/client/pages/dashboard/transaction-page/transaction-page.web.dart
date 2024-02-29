import 'dart:async';

import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.controller.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.dart';
import 'package:cvworld/client/shared/empty-data/empty-data.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class TransactionPageWeb extends StatefulWidget {
  const TransactionPageWeb({super.key});

  @override
  State<TransactionPageWeb> createState() => _TransactionPageWebState();
}

class _TransactionPageWebState extends State<TransactionPageWeb> {
  TransactionPageController controller = TransactionPageController();

  List<UserTransaction> transactions = [];
  StreamSubscription? _subscription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _subscription = controller.getTransactions().listen((event) {
      if (mounted) {
        setState(() {
          transactions = event.data;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });
  }

  // Refresh
  void refresh() {
    controller.refresh();
  }

  // Dispose
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
                      child: const Text('Transactions', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
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
                        const Expanded(child: SizedBox()),
                        // Refresh
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: IconButton(
                            onPressed: () {
                              refresh();
                            },
                            icon: const Icon(Icons.refresh),
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
                    transactions.isEmpty && !isLoading ? const EmptyData(title: 'No Transactions', description: 'Look like you have no transactions yet. Buy some templates', image: 'transaction.png') : TransactionList(transactions: transactions),
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
