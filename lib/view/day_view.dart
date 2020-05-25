import 'package:flutter/material.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:moneywiz/view/newtransaction_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';

class DayView extends StatefulWidget {
  final Day day;

  DayView(this.day);

  @override
  State<StatefulWidget> createState() => _DayViewState(day);
}

class _DayViewState extends State<DayView> {

  static NumberFormat format=NumberFormat("#,##0.00");

  Day day;

  _DayViewState(this.day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${day.month.year} ${day.month.monthString} ${day.day}, ${day.weekDayString}"),
        centerTitle: true,
      ),
      body: Container(
          child:
            _balanceWidget(),
            //_transactionsWidget(),
          //],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTransaction(day))).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _balanceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _getPosNegStats(),
        Text("Total Balance", style: TextStyle(fontSize: 26)),
        Text((day.balance>=0?"+":"")+"${format.format(day.balance)}€", style: TextStyle(fontSize: 50, color: (day.balance>=0?Colors.green:Colors.red))),
        Padding(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: CalendarHeader(
                showHeader: true,
                headerTitle: "${day.month.monthString} ${day.day}",
                onLeftButtonPressed: (){
                  this.setState(() {
                    _changeDay(true);
                  });
                },
                onRightButtonPressed: (){
                  this.setState(() {
                    _changeDay(false);
                  });
                },
                showHeaderButtons: true,
                isTitleTouchable: false,
                onHeaderTitlePressed: null
            )
        ),
        const Divider(
          color: Colors.black12,
          height: 20,
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        Expanded(
          child: _transactionsWidget()
        )
      ],
    );
  }

  Widget _transactionsWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
            child: SingleChildScrollView(
              child: Column(children: _getTransactions())
            )
          )
        )
      ],
    );
  }

  Widget _getPosNegStats() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "+${format.format(day.positive)}€",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                )
              ),
              Expanded(
                child: LinearPercentIndicator(
                  percent: day.getPercent()??0,
                  lineHeight: 8,
                  progressColor: Colors.green,
                  animateFromLastPercent: true,
                  animationDuration: 500,
                )
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "-${format.format(day.negative.abs())}€",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                )
              ),
              Expanded(
                child: LinearPercentIndicator(
                  percent: day.getPercent(false)??0,
                  lineHeight: 8,
                  progressColor: Colors.red,
                  animateFromLastPercent: true,
                  animationDuration: 500,
                )
              )
            ],
          )
        ],
      )
    );
  }

  List<Widget> _getTransactions() {
    List<Widget> lst=List();
    for (Transaction t in day.transactions) {
      lst.add(Card(
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20.0),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await RemovePopUp(context).then((onValue){
              if(onValue == true){
                day.removeTransaction(t);
                setState(() {});
                return true;
              }
              return false;

            });
          },
          child:
          FlatButton(
          child:
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Text("${t.cause}", style: TextStyle(fontSize: 14,))
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 12),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.access_time, size: 16),
                                Text(" ${t.time.hour.toString().padLeft(2, '0')}:${t.time.minute.toString().padLeft(2, '0')}   |   ", style: TextStyle(fontSize: 13,)),
                                Icon(t.category.icon, size: 21),
                                Text("  ${t.category.name}", style: TextStyle(fontSize: 13,))
                              ],
                            )
                        )
                      ]
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text((t.value>=0?"+":"")+"${format.format(t.value)}€", style: TextStyle(fontSize: 16, color: (t.value>=0?Colors.green:Colors.red))),
                      )
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween
              )
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTransaction(day,t))).then((value) {
              setState(() {});
            });
          },
        ),
        ),
      ));
    }
    return lst;
  }



  _changeDay(bool prev) {
    int m=day.month.month;
    int d=day.day;
    Day next=day;

    if (prev) {
      if (day.isFirst()) {
        if (m>1) next=Data.months[m-2].days[Data.months[m-2].days.length-1];
      }
      else next=Data.months[m-1].days[d-2];
    }
    else {
      if (day.isLast()) {
        if (m < 6) next=Data.months[m].days[0];
      }
      else next=Data.months[m-1].days[d];
    }

    setState(() {
      day=next;
    });

  }

  Future<bool> RemovePopUp(BuildContext context){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Remove Selected Transaction?", style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Remove", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]
      );
    });
  }
}