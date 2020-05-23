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

  get CategoryBalance {
    Map<String, double> map = Map();
    map.entries.toList();
    for (var d in days) {
      Map<String, double> dayMap = d.CategoryBalance;
      for (var c in dayMap.keys) {
        map[c] = map.containsKey(c) ? map[c] + dayMap[c]: dayMap[c];
      }
    }
    return map;
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

  static int nWeeks(int month, int year) {
    DateTime date=DateTime(year,month,1);
    int nd=nDays(month, year);
    return 1+((nd-(8-date.weekday))/7).ceil();
  }

}