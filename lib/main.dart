import 'package:flutter/material.dart';
import 'package:moneywiz/view/account_view.dart';
import 'package:moneywiz/view/add_category_view.dart';
import 'package:moneywiz/view/day_view.dart';
import 'package:moneywiz/view/month_view.dart';
import 'package:moneywiz/view/stats_category_view.dart';
import 'package:moneywiz/view/stats_month_view.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/view/stats_view.dart';
import 'package:moneywiz/view/update_categories_view.dart';
import 'package:moneywiz/view/limit_view.dart';

void main() {
  Data();
  runApp(MoneyWiz());
}

class MoneyWiz extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyWiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountView(),
    );
  }
}
