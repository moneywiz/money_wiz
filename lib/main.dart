import 'package:flutter/material.dart';
import 'package:moneywiz/view/accounts_view.dart';
import 'package:moneywiz/view/account_view.dart';
import 'package:moneywiz/view/day_view.dart';
import 'package:moneywiz/view/month_view.dart';
import 'package:moneywiz/view/stats_category_view.dart';
import 'package:moneywiz/view/stats_month_view.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/view/stats_view.dart';
import 'package:moneywiz/view/update_categories_view.dart';

void main() => runApp(MoneyWiz());

class MoneyWiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Data();
    return MaterialApp(
      title: 'MoneyWiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MonthView(Data.months[4]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      )
    );
  }
}
