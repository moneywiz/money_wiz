import 'package:moneywiz/src/day.dart';

class Transaction {

  Day day;

  double value;
  String description;
  List<String> categories;

  Transaction(this.day, this.value) {
    description="";
    categories=List();
  }

}