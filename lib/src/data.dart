import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moneywiz/src/account.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';

class Data {
  static Random random = new Random();

  static Account account;

  static get months {
    return account.months;
  }

  static List<Account> accounts = [
    Account("Cartão CGD", "Cartão Multibanco CGD", 5000.0),
    Account("Poupanças CGD", "Conta a prazo de poupanças CGD", 15000.0),
    Account("Dinheiro", "Dinheira na Carteira", 50.0),
    Account("Cartão UA", "Cartão de Estudante - Refeições SASUA", 15.0),
  ];

  static List<Category> incomeCategories = [
    Category("Salary", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Refund", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Gift", Color(random.nextInt(0xffffffff)), Icons.add)
  ];

  static List<Category> expenseCategories = [
    Category("Restaurants", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Groceries", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Leisure", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Games", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Movies & Music", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Snacks", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Transportation", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Debts", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Taxes", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Rent", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Subscriptions", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Tuition", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Gift", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Clothes", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Hobbies", Color(random.nextInt(0xffffffff)), Icons.add),
    Category("Beverages", Color(random.nextInt(0xffffffff)), Icons.add)
  ];

  Data(){
    for(Account a in accounts) {
      for (Category c in expenseCategories) {
        a.budgets[c] = random.nextInt(400) + 601.0;
      }

      a.months = List();
      for (var i in Iterable<int>.generate(6).toList()) {
        Month month = Month(2020, i + 1);
        for (var j in Iterable<int>.generate(Month.nDays(i + 1, 2020))
            .toList()) {
          Day d = Day(month, j + 1);
          for (var k in Iterable<int>.generate(random.nextInt(6)).toList()) {
            bool expense = random.nextInt(100) < 85;
            int randomNumber = random.nextInt(expense ? 150 : 500) + (expense ? 1 : 51);
            randomNumber *= expense ? -1 : 1;
            Transaction t = Transaction(d, randomNumber +
                double.parse(random.nextDouble().toStringAsFixed(2)),
                "Placeholder");
            int n = expense ? random.nextInt(4) : 1;
            List<Category> categories = expense
                ? expenseCategories
                : incomeCategories;
            for (var m in Iterable<int>.generate(n).toList()) {
              t.categories.add(categories[random.nextInt(categories.length)]);
            }
          }
        }
        a.months.add(month);
      }
    }
    account = accounts[0];
  }
}