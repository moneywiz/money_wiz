import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/week.dart';
import 'package:intl/intl.dart';

class WeekView extends StatefulWidget {
  final Week week;

  WeekView(this.week);

  @override
  State<StatefulWidget> createState() => _WeekViewState(week);
}

class _WeekViewState extends State<WeekView> {

  static NumberFormat format=NumberFormat("#,##0.00");

  Week week;

  _WeekViewState(this.week);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(week.weekString),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Total Balance",style: TextStyle(fontSize: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text((week.balance>=0?"+":"")+"${format.format(week.balance)}€", style: TextStyle(fontSize: 40, color: (week.balance>=0?Colors.green:Colors.red))),
              Column(
                children: <Widget>[
                  Text(
                    "+${format.format(week.positive)}€",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    )
                  ),
                  Text(
                    "-${format.format(week.negative.abs())}€",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    )
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (BuildContext context, int index) {
                return Card(child: ListTile(
                  title: Text("${week.days[index].weekDayString}"),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text((week.days[index].balance>=0?"+":"")+"${format.format(week.days[index].balance)}€", style: TextStyle(fontSize: 20, color: (week.days[index].balance>=0?Colors.green:Colors.red))),
                      Column(
                        children: <Widget>[
                          Text(
                              "+${format.format(week.days[index].positive)}€",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                              )
                          ),
                          Text(
                              "-${format.format(week.days[index].negative.abs())}€",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
              },
            )
          )
        ]
      )
    );
  }

  List<Widget> _getDays() {
    List<Widget> lst=List(7);
    for (Day d in week.days) {
      lst.add(
        Card()
      );
    }
  }

}