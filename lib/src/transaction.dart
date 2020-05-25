import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';

class Transaction {

  Day day;
  TimeOfDay time;

  double value;
  String description;
  String cause;
  Category category;

  Transaction(this.day, this.value, [bool autoAdd=true]) {
    cause="";
    description="";
    if (autoAdd) day.addTransaction(this);
    DateTime now=DateTime.now();
    time=TimeOfDay(hour: now.hour, minute: now.minute);
  }

}