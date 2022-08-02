import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    // required this.index,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  // final int index;
  final Transaction transaction;
  final Function deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(7),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              child: Text("\$${widget.transaction.amount}"),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          DateFormat("MMMM dd, yyyy").format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? TextButton.icon(
                // onPressed: () => widget.deleteTransaction(widget.index),
                onPressed: () =>
                    widget.deleteTransaction(widget.transaction.id),
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
                // Same with
                // style: ButtonStyle(
                //     foregroundColor:
                //         MaterialStateProperty.all(Colors.grey)),
              )
            : IconButton(
                // onPressed: () => widget.deleteTransaction(widget.index),
                onPressed: () =>
                    widget.deleteTransaction(widget.transaction.id),
                icon: const Icon(Icons.delete),
                color: Colors.grey,
              ),
      ),
    );
  }
}
