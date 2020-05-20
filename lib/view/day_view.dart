import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';

class DayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {

  Day day;

  _DayViewState() {
    day=Day(Month(2020,5),20);

    day.transactions.add(Transaction(day,1));
    day.transactions.add(Transaction(day,1));
    day.transactions.add(Transaction(day,1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Day"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(child: Text("Day")),
              RaisedButton(child: Text("Week")),
              RaisedButton(child: Text("Month")),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _getTransactions()
              )
            )
          ),
          Container()
        ],
      ),
    );
  }

  List<Widget> _getTransactions() {
    List<Widget> lst=List();
    for (Transaction t in day.transactions) {
      lst.add(Text("value: ${t.value}"));
    }

    return lst;
  }
}