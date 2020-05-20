import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';

class Day {

  static var _months=["Jan","Feb","Mar","Apr","Mar","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  static var _weekDays=["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];

  Month month;


  int day;
  double _positive;
  double _negative;
  List<Transaction> transactions;

  Day(this.month, this.day) {
    transactions=List();
    _positive=0;
    _negative=0;
  }

  get positive => _positive;

  get negative => _negative;

  get balance => _positive+_negative;

  get monthString {
    return _months[month.month-1];
  }

  get weekDayString {
    var weekDay=DateTime(month.year,month.month,day).weekday;
    return _weekDays[weekDay-1];
  }

  double getPercent([bool pos=true]) {
    var total=_positive+_negative.abs();
    if (total==0) return null;
    if (pos) return ((_positive)/total);
    return ((_negative)/total);
  }

}