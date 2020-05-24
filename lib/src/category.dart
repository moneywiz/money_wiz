import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Category {

  String name;
  Color color;
  IconData icon;

  Category(this.name, this.color, this.icon);

  String toString() => name;

  @override
  bool equals(Object e1, Object e2){
    return (e1 as Category).name == (e2 as Category).name;
  }

}