import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';

class Transaction {

  Day day;

  double value;
  String description;
  String cause;
  List<Category> categories;

  Transaction(this.day, this.value, this.cause) {
    description="";
    categories=List();
    day.addTransaction(this);
  }

}