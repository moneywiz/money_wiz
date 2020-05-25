import 'package:flutter/material.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/week.dart';
import 'package:intl/intl.dart';
import 'package:moneywiz/view/day_view.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
          _balanceWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: week.days.length,
              itemBuilder: (BuildContext context, int index) {
                Color col;
                DateTime now=DateTime.now();
                bool today=week.days[index].date.day==now.day && week.days[index].month.month==now.month && week.days[index].month.year==now.year;
                if (today) col=Colors.blue;
                else col=week.days[index].date.weekday>=6?Colors.white70:Colors.white;
                return Card(
                  color: col,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DayView(week.days[index])));
                    },
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${week.days[index].weekDayString}", style: TextStyle(fontSize: 30, color: today?Colors.white:Colors.black54)),
                          Text("${week.days[index].month.monthString} ${week.days[index].day}", style: TextStyle(fontSize: 20, color: today?Colors.white:Colors.black38))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        padding: EdgeInsets.all(8),
                        decoration: today?BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(70)),
                          color: Colors.white
                        ):null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text((week.days[index].balance>=0?"+":"")+"${format.format(week.days[index].balance)}€", style: TextStyle(fontSize: 30, color: (week.days[index].balance>=0?Colors.green:Colors.red))),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "+${format.format(week.days[index].positive)}€",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  )
                                ),
                                Text(
                                  "-${format.format(week.days[index].negative.abs())}€",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ])
                  )
                );
              },
            )
          )
        ]
      )
    );
  }

  Widget _balanceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _getPosNegStats(),
        Text("Total Balance", style: TextStyle(fontSize: 26)),
        Text((week.balance>=0?"+":"")+"${format.format(week.balance)}€", style: TextStyle(fontSize: 50, color: (week.balance>=0?Colors.green:Colors.red))),
        Padding(
          padding: EdgeInsets.fromLTRB(75, 0, 75, 0),
          child: CalendarHeader(
            showHeader: true,
            headerTitle: "${week.weekString}",
            onLeftButtonPressed: (){
              this.setState(() {
                _changeWeek(true);
              });
            },
            onRightButtonPressed: (){
              this.setState(() {
                _changeWeek(false);
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
      ],
    );
  }

  Widget _getPosNegStats() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Row(
        children: <Widget>[
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
          VerticalDivider(),
          Expanded(child: Column(
            children: <Widget>[
              LinearPercentIndicator(
                percent: week.getPercent()??0,
                lineHeight: 8,
                progressColor: Colors.green,
                animateFromLastPercent: true,
                animationDuration: 500,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              LinearPercentIndicator(
                percent: week.getPercent(false)??0,
                lineHeight: 8,
                progressColor: Colors.red,
                animateFromLastPercent: true,
                animationDuration: 500,
              )
            ],
          )
        )],
      )
    );
  }

  _changeWeek(bool prev) {
    List<Day> days=List();

    DateTime firstDay=week.days[0].date;
    while (firstDay.weekday>1) {
      firstDay=firstDay.subtract(Duration(days: 1));
    }

    if (prev) firstDay=firstDay.subtract(Duration(days: 7));
    else firstDay=firstDay.add(Duration(days: 7));
    for (var d=0;d<7;d++) {
      if (firstDay.month>0 && firstDay.month<7) days.add(Data.months[firstDay.month-1].days[firstDay.day-1]);
      firstDay=firstDay.add(Duration(days: 1));
    }

    setState(() {
      week=Week(days);
    });

  }

}