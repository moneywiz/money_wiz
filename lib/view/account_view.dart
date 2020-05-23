import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';

class Account extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Account();
}


class _Account extends State<StatefulWidget> {

  String account_name = "Conta 1";
  String account_description = "Conta para guardar as transações que faço quando estou na universidade";
  int account_balance = 20;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body:
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child:
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text("$account_name",
                      style: TextStyle(fontSize: 17, color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
          Text("$account_description"),
          Text("Saldo : $account_balance €"),
          Expanded(
            child:Container(
              padding: EdgeInsets.only(top: 220),
              child: ListView(
                padding: const EdgeInsets.only(left:20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Calender"),
                    leading: Icon(Icons.calendar_today,),
                    onTap: (){

                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Statistics"),
                    leading: Icon(Icons.show_chart),
                    onTap: (){

                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Goal Limits"),
                    leading: Icon(Icons.flag),
                    onTap: (){

                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Settings"),
                    leading: Icon(Icons.settings),
                    onTap: (){

                    },
                  ),

                ],
              ),
            )
          )
        ],
      ),
    );
  }
}