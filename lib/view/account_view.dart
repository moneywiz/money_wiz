import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneywiz/view/limit_view.dart';
import 'package:moneywiz/view/stats_view.dart';
import 'package:moneywiz/view/update_categories_view.dart';
import 'package:moneywiz/view/stats_month_view.dart';
import 'package:moneywiz/view/day_view.dart';

class Account extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Account();
}


class _Account extends State<StatefulWidget> {

  String account_name = "Account 1";
  String account_description = "Account to organise the money that I spend when I am at the University";
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
          Expanded(
            flex:3,
            child:
             Container(
               color: Colors.blue,
               child: Row(
                 children: <Widget>[
                   Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child: Text("$account_name",
                        style: TextStyle(fontSize: 17, color: Colors.white),),
                    ),
                 ],
                ),
              ),
          ),
          Expanded(
            flex: 11,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("$account_description", style: TextStyle(fontSize: 18),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text("Balance : $account_balance €" , style: TextStyle(fontSize: 18),),
                ),
              ],
            ),
          ),
          Expanded(flex: 25,
            child:Container(
              padding: EdgeInsets.only(top: 20),
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
                    title: Text("Calendar"),
                    subtitle: Text("See all your transactions"),
                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => DayView(Day(Month(2020, 6), 10))));
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
                    subtitle: Text("Analise your data by categories"),
                    leading: Icon(Icons.show_chart, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => StatsView(4)));
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
                    subtitle: Text("set monthly limits"),
                    leading: Icon(Icons.flag, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => Limit()));
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
                    title: Text("Categories"),
                    subtitle: Text("create categories to organize your data"),
                    leading: Icon(Icons.loyalty, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => (UpdateCategories())));
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