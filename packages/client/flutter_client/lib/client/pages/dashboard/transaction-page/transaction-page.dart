import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.mobile.dart';
import 'package:cvworld/client/pages/dashboard/transaction-page/transaction-page.web.dart';
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
  const TransactionListItem({super.key});

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
              CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'),
                minRadius: 30,
                maxRadius: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Template One 123', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transaction Id: ',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                        ),
                        TextSpan(
                          text: 'hsdfghsdfghsdf',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Column(children: [
                TextButton(onPressed: () {}, child: Text('₹ 100.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green))),
                const SizedBox(height: 5),
                Text('10/10/2022', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
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
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Column(
        children: [
          TransactionListItem(),
          TransactionListItem(),
          TransactionListItem(),
          TransactionListItem(),
        ],
      ),
    );
  }
}
