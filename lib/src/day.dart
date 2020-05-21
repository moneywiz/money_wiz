import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';

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

  get positive => _positive;

  get negative => _negative;

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

}