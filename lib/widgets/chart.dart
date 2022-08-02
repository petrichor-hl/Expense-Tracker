import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: 7 - index - 1),
      );
      double totalSum = 0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 3),
        "amount": totalSum,
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item["amount"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(7),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ...groupedTransactionValues.map((data) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data["day"] as String,
                    data["amount"] as double,
                    totalSpending == 0
                        ? 0
                        : (data["amount"] as double) / totalSpending,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}