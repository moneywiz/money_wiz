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
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Color(0xFF000000),
            unselectedLabelColor: Color(0xFF000000),
            tabs: <Widget>[
              Tab(child: Text("Balance"),),
              Tab(text: "Transactions"),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              _balanceWidget(),
              _transactionsWidget(),
            ],
          )
        ),
      )
    );
  }

  Widget _balanceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _getPosNegStats(),
        Text("Total Balance", style: TextStyle(fontSize: 32)),
        Text((day.balance>=0?"+":"")+"${format.format(day.balance)}€", style: TextStyle(fontSize: 80, color: (day.balance>=0?Colors.green:Colors.red))),
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
        )
      ],
    );
  }

  Widget _transactionsWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(32),
          child: RaisedButton(
            child: Text("Add new Transaction", style: TextStyle(fontSize: 24)),
            color: Colors.blue,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTransaction(day))).then((value) {
                setState(() {});
              });
            },
          )
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
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
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Text("${t.cause}: "),
              Text((t.value>=0?"+":"")+"${format.format(t.value)}€", style: TextStyle(color: (t.value>=0?Colors.green:Colors.red)))
            ],
          ),
        )
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
}