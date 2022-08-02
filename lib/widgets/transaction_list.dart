import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    //
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: ((context, constraints) => Column(
                  children: [
                    Text(
                      "No transaction added yet!",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )),
          )
        // : ListView.builder(
        //     itemBuilder: (ctx, index) {
        //       return TransactionItem(
        //         index: index,
        //         transaction: transactions[index],
        //         deleteTransaction: deleteTransaction,
        //       );
        //     },
        //     itemCount: transactions.length,
        //   );
        : ListView(
            children: transactions
                .map((e) => TransactionItem(
                      transaction: e,
                      deleteTransaction: deleteTransaction,
                    ))
                .toList(),
          );
  }
}
