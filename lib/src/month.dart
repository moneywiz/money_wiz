import 'package:moneywiz/src/day.dart';

import 'category.dart';

class Month {

  static var months=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  static Category _others = Category("Others");

  int year;
  int month;

  List<Day> days;

  Month(this.year, this.month) {
    days=List();
  }

  addDay(Day d) {
    days.add(d);
  }

  get ExpenseCategoryBalance {
    Map<Category, double> map = Map();
    map.entries.toList();
    for (var d in days) {
      Map<Category, double> dayMap = d.ExpenseCategoryBalance;
      for (var c in dayMap.keys) {
        map[c] = map.containsKey(c) ? map[c] + dayMap[c]: dayMap[c];
      }
    }
    List<MapEntry<Category, double>> lst = map.entries.toList();
    lst.sort((a, b) => b.value.compareTo(a.value));
    double rest_val = 0;
    lst.sublist(8).forEach((MapEntry<Category, double> e){rest_val += e.value;});
    lst[8] = MapEntry(_others, rest_val);
    return lst.sublist(0, 9);
  }

  get IncomeCategoryBalance {
    Map<Category, double> map = Map();

    for (var d in days) {
      Map<Category, double> dayMap = d.IncomeCategoryBalance;
      for (var c in dayMap.keys) {
        map[c] = map.containsKey(c) ? map[c] + dayMap[c]: dayMap[c];
      }
    }
    List<MapEntry<Category, double>> lst = map.entries.toList();
    lst.sort((a, b) => a.value.compareTo(b.value));
    double rest_val = 0;
    if (lst.length > 7) {
      lst.sublist(5).forEach((MapEntry<Category, double> e) {
        rest_val += e.value;
      });
      lst[5] = MapEntry(_others, rest_val);
      return lst.sublist(0, 6);
    }
    return lst;
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
    return months[month-1];
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