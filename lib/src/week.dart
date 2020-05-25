import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';

class Week {

  List<Day> days;
  bool twoMonths;

  Week(this.days){
    twoMonths=days[0].month.month!=days[days.length-1].month.month;
  }

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
    int m2=days[days.length-1].month.month;
    if (m1!=m2) return "${days[0].month.monthString} ${days[0].day}-${days[6].month.monthString} ${days[days.length-1].day}";
    else return "${days[0].month.monthString} ${days[0].day}-${days[days.length-1].day}";
  }

  double getPercent([bool pos=true]) {
    var total=positive+negative.abs();
    if (total==0) return null;
    if (pos) return ((positive)/total);
    return ((negative.abs())/total);
  }

}