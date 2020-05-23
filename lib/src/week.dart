import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';

class Week {

  static var _weekDays=["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];

  List<Day> days;

  Week(this.days);

  get positive {
    double pos=0;
    for (Day d in days) pos+=d.positive;
    return pos;
  }

  get negative {
    double neg=0;
    for (Day d in days) neg+=d.negative;
    return neg;
  }

  get balance {
    double bal=0;
    for (Day d in days) bal+=d.negative+d.positive;
    return bal;
  }

  get weekString {
    int m1=days[0].month.month;
    int m2=days[6].month.month;
    if (m1!=m2) return "${days[0].month.monthString} ${days[0].day} - ${days[6].month.monthString} ${days[6].day}";
    else return "${days[0].month.monthString} ${days[0].day} - ${days[6].day}";
  }

}