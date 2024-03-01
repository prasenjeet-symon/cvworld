import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.mobile.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.web.dart';
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        // Mobile
        return const TransactionPageMobile();
      } else {
        // Desktop
        return const TransactionPageWeb();
      }
    });
  }
}

///
///
///
/// Transaction list item
class TransactionListItem extends StatelessWidget {
  final UserTransaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Card(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/transaction-item.png'),
                minRadius: 30,
                maxRadius: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(transaction.templateName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Order Id: ',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        ),
                        TextSpan(
                          text: transaction.orderId,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Column(children: [
                TextButton(onPressed: () {}, child: Text(formatAsIndianRupee(double.parse(transaction.amountPaid.toString())), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green))),
                const SizedBox(height: 5),
                Text(formatDateTime(transaction.createdAt), style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

///
///
///
/// List all the transactions
class TransactionList extends StatelessWidget {
  final List<UserTransaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Column(
        children: [
          ...transactions.map((transaction) => TransactionListItem(key: ValueKey(transaction.orderId), transaction: transaction)),
        ],
      ),
    );
  }
}
