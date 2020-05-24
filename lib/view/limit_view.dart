import 'package:moneywiz/src/category.dart';
import 'package:flutter/material.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';

class Limit extends StatefulWidget{
  int month;

  @override
  Limit(this.month);

  @override
  State<StatefulWidget> createState() => _Limit();
}

class _Limit extends State<Limit> {
  String account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Budget Goals"),
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
            flex: 8,
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: getBudgets()
            ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: CalendarHeader(
                    showHeader: true,
                    headerTitle: Month.months[Data.months[widget.month].month - 1] + " " +  Data.months[widget.month].year.toString(),
                    onLeftButtonPressed: (){
                      if(widget.month - 1 >= 0) {
                        widget.month -= 1;
                        this.setState(() {});
                      }
                    },
                    onRightButtonPressed: (){
                      if(Data.months.length > widget.month + 1) {
                        widget.month += 1;
                        this.setState(() {});
                      }
                    },
                    showHeaderButtons: true,
                    isTitleTouchable: false,
                    onHeaderTitlePressed: null
                )
            )
          ),


        ],
    ),
    );
  }

  List<Widget> getBudgets() {
    List<Widget> res = [
      Padding(
        padding: EdgeInsets.only(top: 15),
      )
    ];
    Data.account.budgets.entries.forEach((MapEntry<Category, double> e) {
      double budget = e.value;
      double spent = (Data.months[widget.month] as Month).spentOnCategory(e.key);
      double available = budget - spent;
      double percent = available >= 0 ? (spent / budget) : 1;
      res.addAll(
        <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30.0),
            child:
              Row(children: <Widget>[
                  Text("Category: " ,style: TextStyle(fontSize: 14),),
                  Text(e.key.name ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ]
              ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 5, 0, 0),
            child: 
              Row(children: <Widget>[
                  Text("Budget: " ,style: TextStyle(fontSize: 14),),
                  Text(budget.toStringAsFixed(2) + "€" ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ]
              ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 5, 0, 0),
            child:
              Row(children: <Widget>[
                  Text("Available: " ,style: TextStyle(fontSize: 14),),
                  Text(available.toStringAsFixed(2) + "€" ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: percent == 1 ? Colors.red : (percent > 0.8 ? Colors.orange : Colors.green)),),
                ]
              ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child:
              LinearPercentIndicator(
                percent: percent,
                lineHeight: 4,
                progressColor: percent == 1 ? Colors.red : (percent > 0.8 ? Colors.orange : Colors.blue),
              )
          ),
          const Divider(
            color: Colors.black12,
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 10,
          )
        ],
      );
    });
    return res;
  }
}