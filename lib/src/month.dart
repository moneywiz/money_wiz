import 'package:moneywiz/src/day.dart';

class Month {

  static var _months=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

  int year;
  int month;

  List<Day> days;

  Month(this.year, this.month) {
    days=List();
  }

  addDay(Day d) {
    days.add(d);
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

  get monthString {
    return _months[month-1];
  }

  static int nDays(int month, int year) {
    DateTime date=DateTime(year,month);
    return ((date.month < 12)?DateTime(date.year, date.month + 1, 0):DateTime(date.year + 1, 1, 0)).day;
  }

}