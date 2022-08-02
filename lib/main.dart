import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: "QuickSand",
        //
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans",
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _isIOS = Platform.isIOS;

  final List<Transaction> _userTransactions = [
    Transaction(
      id: "t1",
      title: "New Shoes",
      amount: 69.79,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: "t2",
      title: "Monthly rent",
      amount: 51.33,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: "t3",
      title: "Weekly Drink",
      amount: 36.4,
      date: DateTime.now(),
    ),
    Transaction(
      id: "t4",
      title: "Weekly Food",
      amount: 80.29,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: "t5",
      title: "A Cat",
      amount: 50.72,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransaction {
    return _userTransactions
        .where(
          (element) => element.date.isAfter(
            DateTime.now().subtract(const Duration(days: 7)),
          ),
        )
        .toList();
  }

  bool _showChart = false;

  void _addNewTransaction(String title, double amount, DateTime day) {
    _userTransactions.add(Transaction(
      id: "t${_userTransactions.length + 1}",
      title: title,
      amount: amount,
      date: day,
    ));

    setState(() {});
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => NewTransaction(_addNewTransaction),
    );
  }

  // void _deleteTransaction(int index) {
  //   setState(() {
  //     _userTransactions.removeAt(index);
  //   });
  // }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = _isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Expense Tracker"),
            trailing: GestureDetector(
              child: const Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text("Expense Tracker"),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: const Icon(Icons.add),
              ),
            ],
          );
    //
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    final scaleHeightOfChart = isLandscape ? 0.55 : 0.22;
    final scaleHeightOfTransactionList = isLandscape ? 0.83 : 0.78;

    final chartWidget = SizedBox(
      height: availableHeight * scaleHeightOfChart,
      child: Chart(_recentTransaction),
    );
    final transactionListWidget = SizedBox(
      height: availableHeight * scaleHeightOfTransactionList,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: Column(
        children: [
          //
          if (!isLandscape) chartWidget,
          if (!isLandscape) transactionListWidget,
          //
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Show Chart",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                _isIOS
                    ? CupertinoSwitch(
                        value: _showChart,
                        onChanged: (val) => setState(() => _showChart = val),
                      )
                    : Switch(
                        value: _showChart,
                        onChanged: (val) => setState(() => _showChart = val),
                      ),
              ],
            ),
          if (isLandscape) _showChart ? chartWidget : transactionListWidget,
        ],
      ),
    );

    return _isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
