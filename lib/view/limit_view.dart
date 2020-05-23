import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Limit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Limit();
}


class _Limit extends State<StatefulWidget> {


  String account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Limit Goals"),
    ),
    body:
    Column(
      children: <Widget>[
        Container(
          color: Colors.blue,
          child:
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 320.0),
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () {},
                    child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Category: Education" ,style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Budget : 30€" ,style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child:Text("Available: 10€", style: TextStyle(fontSize: 16),),
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Category: Transports" ,style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Budget : 60€" ,style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child:Text("Available: 40€", style: TextStyle(fontSize: 16),),
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Category: Food" ,style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Text("Budget : 200€" ,style: TextStyle(fontSize: 16),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child:Text("Available: 120€", style: TextStyle(fontSize: 16),),
                  ),

                  ],
        ),
        ),


        ],
    ),
    );
  }
}