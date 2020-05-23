import 'package:flutter/material.dart';
import 'package:moneywiz/view/account_view.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';

class Accounts extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Accounts();
}


class _Accounts extends State<StatefulWidget> {


  String account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Accounts"),
    ),
    body:
    Column(
      children: <Widget>[
        OutlineButton(
          color: Colors.blue,
          onPressed: () {},
          child: Text("Categories"),
        ),
        Expanded(
          child:
            Center(
              child: DropdownButton<String>(
                value: account,
                icon: Icon(Icons.expand_more),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                  color: Colors.black
                ),
              underline: Container(
                height: 2,
                color: Colors.blue,
                ),
              onChanged: (String newValue) {
                setState(() {
                  account = newValue;
                });
                Navigator.of(context).push( MaterialPageRoute(builder: (context) => Account()));
              },
              items: <String>['Account1', 'Account2', 'Account3', 'Account4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
              ),
            ),
        ),
    ],
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );

  }
}