import 'package:moneywiz/src/day.dart';

class Month {

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
    for (Day d in days) bal+=d.negative;
    return bal;
  }

}