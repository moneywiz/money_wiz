import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:intl/intl.dart';
import 'package:moneywiz/src/week.dart';
import 'package:moneywiz/view/day_view.dart';
import 'package:moneywiz/view/week_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MonthView extends StatefulWidget {
  final Month month;

  MonthView(this.month);

  @override
  State<StatefulWidget> createState() => _MonthViewState(month);
}

class _MonthViewState extends State<MonthView> {

  static NumberFormat format=NumberFormat("#,##0.00");

  Month month;
  DateTime selDate;

  _MonthViewState(this.month) {
    selDate=DateTime(month.year,month.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(month!=null?"${month.year} ${month.monthString}":"Unavailable Month"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          month!=null?_getPosNegStats():null,
          Padding(padding: EdgeInsets.symmetric(horizontal: 16),child: Text(month!=null?"Total Balance":"This month is out of bounds for the prototype",style: TextStyle(fontSize: 24),textAlign: TextAlign.center)),
          month!=null?Text((month.balance>=0?"+":"")+"${format.format(month.balance)}€", style: TextStyle(fontSize: 50, color: (month.balance>=0?Colors.green:Colors.red))):null,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                month!=null?Padding(padding: EdgeInsets.only(top: 96), child:Column(
                  children: _getWeekButtons(),
                )):null,
                Expanded(
                  child: CalendarCarousel(
                    firstDayOfWeek: 1,
                    weekendTextStyle: TextStyle(color: Colors.red),
                    thisMonthDayBorderColor: Colors.grey,
                    height: 400,
                    selectedDateTime: selDate,
                    selectedDayButtonColor: Colors.transparent,
                    selectedDayTextStyle: TextStyle(fontSize: 14, color: Colors.black),
                    onCalendarChanged: (DateTime dt) {
                      setState(() {
                        month=(dt.month-1>=0 && dt.month-1<=5)?Data.months[dt.month-1]:null;
                        selDate=month!=null?DateTime(month.year,month.month):dt;
                      });
                    },
                    onDayPressed: month!=null?(DateTime dt, List lst) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DayView(month.days[dt.day-1])));
                    }:null,
                    customDayBuilder: month!=null?(
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
                    }:null,
                  )
                )
              ].where((element) => element!=null).toList(),
            )
          )
        ].where((element) => element!=null).toList(),
      )
    ));
  }

  Widget _getPosNegStats() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Row(
          children: <Widget>[
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
            VerticalDivider(),
            Expanded(child: Column(
              children: <Widget>[
                LinearPercentIndicator(
                  percent: month.getPercent()??0,
                  lineHeight: 8,
                  progressColor: Colors.green,
                  animateFromLastPercent: true,
                  animationDuration: 500,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                LinearPercentIndicator(
                  percent: month.getPercent(false)??0,
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
      if (firstDay.month>0 && firstDay.month<7) days.add(Data.months[firstDay.month-1].days[firstDay.day-1]);
      firstDay=firstDay.add(Duration(days: 1));
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => WeekView(Week(days))));
  }

}