import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';

class Day {

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

}