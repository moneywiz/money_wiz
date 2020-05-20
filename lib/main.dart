import 'package:flutter/material.dart';
import 'package:moneywiz/view/day_view.dart';
import 'package:moneywiz/view/stats_month_view.dart';
import 'package:moneywiz/src/data.dart';

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
      home: DayView(),
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
