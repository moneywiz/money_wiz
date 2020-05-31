import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/month.dart';

class Account {
  String name;
  String description;
  List<Month> months;
  double startingBalance;
  Map<Category, double> budgets;
  double maxPos;
  double maxNeg;

  Account(this.name, this.description, this.startingBalance){
    months = List();
    budgets = Map();
    maxPos = 0;
    maxNeg = 0;
  }

  get balance {
    double res = startingBalance;
    for(Month m in months) {
      res += m.positive + m.negative;
    }
    return res;
  }

  String toString() => name;

  @override
  bool equals(Object a1, Object a2){
    return (a1 as Account).name == (a2 as Account).name;
  }

}