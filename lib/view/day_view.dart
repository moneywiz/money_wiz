import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {

  Day day;

  _DayViewState() {
    day=Day(Month(2020,5),20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${day.month.year} ${day.monthString} ${day.day}, ${day.weekDayString}"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getPosNegStats(),
          /*Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "+${day.negative}€",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                  )
                ),
                Text(
                  "+${day.positive}€",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                  )
                ),
              ]
            )
          ),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width,
            lineHeight: 16,
            progressColor: Colors.red,
            backgroundColor: day.getPercent(false)==null?Colors.grey:Colors.green,
            percent: day.getPercent(false)??0,
          ),*/
          Text("Total Balance", style: TextStyle(fontSize: 32)),
          Text((day.balance>=0?"+":"-")+"${day.balance}€", style: TextStyle(fontSize: 100, color: (day.balance>=0?Colors.green:Colors.red)))
        ],
      ),
    );
  }

  Widget _getPosNegStats() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                  "+${day.positive}€",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                  )
              ),
              Expanded(
                  child: LinearPercentIndicator(
                    percent: day.getPercent()??0,
                    lineHeight: 8,
                    progressColor: Colors.green,
                  )
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "+${day.negative}€",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                )
              ),
              Expanded(
                child: LinearPercentIndicator(
                  percent: day.getPercent(false)??0,
                  lineHeight: 8,
                  progressColor: Colors.red,
                )
              )
            ],
          )
        ],
      )
    );
  }

  /*Widget _getBalance() {
    return Row(
      children: <Widget>[
        Text(
          (day.balance>=0?"+":"-")+"${day.balance}€",
          style: TextStyle(
              color: (day.balance>=0?Colors.green:Colors.red),
              fontSize: 40
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              "+${day.positive}€",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
              ),
            ),
            Text(
              "-${day.negative.abs()}€",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            )
          ],
        ),
      ],
    );
  }*/
}