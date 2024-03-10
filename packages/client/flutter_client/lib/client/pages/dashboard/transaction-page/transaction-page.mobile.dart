import 'dart:async';

import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.controller.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.dart';
import 'package:cvworld/client/shared/empty-data/empty-data.dart';
import 'package:flutter/material.dart';

class TransactionPageMobile extends StatefulWidget {
  const TransactionPageMobile({super.key});

  @override
  State<TransactionPageMobile> createState() => _TransactionPageMobileState();
}

class _TransactionPageMobileState extends State<TransactionPageMobile> {
  TransactionPageController controller = TransactionPageController();

  List<UserTransaction> transactions = [];
  StreamSubscription? _subscription;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

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

    searchController.addListener(() {
      search(searchController.text);
    });
  }

  // Refresh
  void refresh() async {
    controller.refresh();
    return;
  }

  // Search
  void search(String query) {
    controller.search(query);
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
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          // Search
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                              width: 300,
                              child: TextField(controller: searchController, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Search...')),
                            ),
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
      ),
    );
  }
}
