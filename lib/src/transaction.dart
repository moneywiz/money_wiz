import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';

class Transaction {

  Day day;
  TimeOfDay time;

  double value;
  String description;
  String cause;
  List<Category> categories;

  Transaction(this.day, this.value, this.cause, [bool autoAdd=true]) {
    description="";
    categories=List();
    if (autoAdd) day.addTransaction(this);
    DateTime now=DateTime.now();
    time=TimeOfDay(hour: now.hour, minute: now.minute);
  }

}