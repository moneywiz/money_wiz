import 'package:moneywiz/src/day.dart';

class Transaction {

  Day day;

  double value;
  String description;
  String cause;
  List<String> categories;

  Transaction(this.day, this.value, this.cause) {
    description="";
    categories=List();
  }

}