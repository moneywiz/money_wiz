import 'dart:ui';
import 'package:flutter/material.dart';

class Category {

  String name;
  Color color;
  IconData icon;

  List<String> causes;

  Category(this.name, this.color, this.icon, {this.causes});

  String toString() => name;

  @override
  bool equals(Object e1, Object e2){
    return (e1 as Category).name == (e2 as Category).name;
  }

}