import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:intl/intl.dart';
import 'package:moneywiz/src/week.dart';
import 'package:moneywiz/view/day_view.dart';
import 'package:moneywiz/view/week_view.dart';

class MonthView extends StatefulWidget {
  final Month month;

  MonthView(this.month);

  @override
  State<StatefulWidget> createState() => _MonthViewState(month);
}

class _MonthViewState extends State<MonthView> {

  static NumberFormat format=NumberFormat("#,##0.00");

  Month month;

  _MonthViewState(this.month);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${month.year} ${month.monthString}"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Total Balance",style: TextStyle(fontSize: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text((month.balance>=0?"+":"")+"${format.format(month.balance)}€", style: TextStyle(fontSize: 40, color: (month.balance>=0?Colors.green:Colors.red))),
              Column(
                children: <Widget>[
                  Text(
                    "+${format.format(month.positive)}€",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    )
                  ),
                  Text(
                    "-${format.format(month.negative.abs())}€",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    )
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget> [
                Column(
                  children: _getWeekButtons(),
                ),
                Expanded(
                  child: CalendarCarousel(
                    firstDayOfWeek: 1,
                    weekendTextStyle: TextStyle(color: Colors.red),
                    thisMonthDayBorderColor: Colors.grey,
                    height: 520,
                    selectedDateTime: DateTime(month.year,month.month),
                    selectedDayButtonColor: Colors.transparent,
                    selectedDayTextStyle: TextStyle(fontSize: 14, color: Colors.black),
                    onCalendarChanged: (DateTime dt) {
                      setState(() {
                        month=Data.months[dt.month-1];
                      });
                    },
                    onDayPressed: (DateTime dt, List lst) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DayView(month.days[dt.day-1])));
                    },
                    customDayBuilder: (
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      if (day.month==month.month && isThisMonthDay) {
                        double balance=month.days[day.day-1].balance;
                        Color border=Colors.transparent;
                        if (balance<0) border=Colors.red;
                        else if (balance>0) border=Colors.green;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(border: Border.all(color: border, width: 2)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('${day.day}'),
                            ],
                          ),
                        );
                      }
                      return null;
                    },
                  )
                )
              ]
            )
          )
        ],
      )
    );
  }

  List<Widget> _getWeekButtons() {
    List<Widget> lst=List();
    for (var i=0;i<Month.nWeeks(month.month, month.year);i++) {
      lst.add(
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: () {_goToWeek(i);},
        )
      );
    }
    return lst;
  }

  _goToWeek(int i) {
    List<Day> days=List();

    DateTime firstDay=DateTime(month.year,month.month,1);
    while (firstDay.weekday>1) {
      firstDay=firstDay.subtract(Duration(days: 1));
    }

    firstDay=firstDay.add(Duration(days: 7*i));
    for (var d=0;d<7;d++) {
      days.add(Data.months[firstDay.month-1].days[firstDay.day-1]);
      firstDay=firstDay.add(Duration(days: 1));
    }

    days.forEach((element) {print("${element.month.month} ${element.day} ${element.weekDayString}");});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => WeekView(Week(days))));
  }

}