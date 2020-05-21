import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:intl/intl.dart';
import 'package:moneywiz/view/day_view.dart';

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
            child: CalendarCarousel(
              weekendTextStyle: TextStyle(color: Colors.red),
              thisMonthDayBorderColor: Colors.grey,
              height: 320,
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
                if (isThisMonthDay) {
                  double balance=month.days[day.day-1].balance;
                  if (balance<0) return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${day.day}'),
                      ],
                    ),
                  );
                  else if (balance>0) return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2)),
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
        ],
      )
    );
  }
}