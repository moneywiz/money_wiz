import 'dart:math';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';

class Data {
  Random random = new Random();
  static List<Month> months;

  static List<Category> incomeCategories = [
    Category("Salary"),
    Category("Refund"),
    Category("Gift")
  ];

  static List<Category> expenseCategories = [
    Category("Restaurants"),
    Category("Groceries"),
    Category("Leisure"),
    Category("Games"),
    Category("Movies & Music"),
    Category("Snacks"),
    Category("Transportation"),
    Category("Debts"),
    Category("Taxes"),
    Category("Rent"),
    Category("Subscriptions"),
    Category("Tuition"),
    Category("Gift"),
    Category("Clothes"),
    Category("Hobbies"),
    Category("Beverages")
  ];

  Data(){
    months = List();

    for (var i in Iterable<int>.generate(6).toList()){
      Month month = Month(2020, i+1);
      for (var j in Iterable<int>.generate(Month.nDays(i+1, 2020)).toList()) {
        Day d = Day(month, j+1);
        for (var k in Iterable<int>.generate(random.nextInt(6)).toList()) {
          bool expense = random.nextInt(100)<85;
          int randomNumber = random.nextInt(150) + 1;
          randomNumber *= expense ? -1 : 1;
          Transaction t = Transaction(d, randomNumber + double.parse(random.nextDouble().toStringAsFixed(2)), "Placeholder");
          int n = expense ? random.nextInt(4) : 1;
          List<Category> categories = expense ? expenseCategories : incomeCategories;
          for (var m in Iterable<int>.generate(n).toList()) {
            t.categories.add(categories[random.nextInt(categories.length)]);
          }
        }
      }
      months.add(month);
    }
  }
}