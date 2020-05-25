import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/week.dart';

class Day {

  static var _weekDays=["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];

  Month month;
  DateTime date;

  int day;
  double _positive;
  double _negative;
  List<Transaction> transactions;

  Day(this.month, this.day) {
    transactions=List();
    _positive=0;
    _negative=0;
    month.addDay(this);
    date=DateTime(month.year,month.month,day);
  }

  addTransaction(Transaction t) {
    transactions.add(t);
    _positive += t.value > 0 ? t.value : 0;
    _negative += t.value < 0 ? t.value : 0;
  }

  removeTransaction(Transaction t) {
    transactions.remove(t);
    _positive -= t.value > 0 ? t.value : 0;
    _negative -= t.value < 0 ? t.value : 0;
  }

  get expenseCategoryBalance {
    Map<Category, double> map = Map();
    for (var t in transactions) {
      if(Data.expenseCategories.contains(t.category)) map[t.category] = map.containsKey(t.category) ? map[t.category] + t.value.abs(): t.value.abs();
    }
    return map;
  }

  get incomeCategoryBalance {
    Map<Category, double> map = Map();
    for (var t in transactions) {
      if(Data.incomeCategories.contains(t.category)) map[t.category] = map.containsKey(t.category) ? map[t.category] + t.value.abs(): t.value.abs();
    }
    return map;
  }

  get positive => _positive;

  double getPositive({Category category}) {
    if (category == null) return _positive;
    double res = 0;
    for(Transaction t in transactions) {
      if (t.category==category && t.value > 0) res += t.value;
    }
    return res;
  }

  get negative => _negative;

  double getNegative({Category category}) {
    if (category == null) return _negative;
    double res = 0;
    for(Transaction t in transactions) {
      if (t.category==category && t.value < 0) res += t.value;
    }
    return res;
  }

  get balance => _positive+_negative;

  bool isLast() {
    DateTime dt=(date.month < 12)?DateTime(date.year, date.month + 1, 0):DateTime(date.year + 1, 1, 0);
    return dt.day==day;
  }

  bool isFirst() {
    return day==1;
  }

  get weekDayString {
    var weekDay=date.weekday;
    return _weekDays[weekDay-1];
  }

  double getPercent([bool pos=true]) {
    var total=_positive+_negative.abs();
    if (total==0) return null;
    if (pos) return ((_positive)/total);
    return ((_negative.abs())/total);
  }

  Week getWeek() {
    List<Day> days=List();

    DateTime first=DateTime(month.year,month.month,day);
    while (first.weekday>1) {
      first=first.subtract(Duration(days: 1));
    }

    for (var d=0;d<7;d++) {
      days.add(Data.months[first.month-1].days[first.day-1]);
      first=first.add(Duration(days: 1));
    }

    return Week(days);

  }

}