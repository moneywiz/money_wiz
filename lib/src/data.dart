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
    Account("Cartão CGD", "Cartão Multibanco CGD", 15000.0),
    Account("Poupanças CGD", "Conta a prazo de poupanças CGD", 25000.0),
    Account("Dinheiro", "Dinheira na Carteira", 50.0),
    Account("Cartão UA", "Cartão de Estudante - Refeições SASUA", 15.0),
  ];

  static List<Category> incomeCategories = [
    Category("Salary", Color(random.nextInt(0xffffffff)), Icons.monetization_on),
    Category("Refund", Color(random.nextInt(0xffffffff)), Icons.money_off),
    Category("Gift", Color(random.nextInt(0xffffffff)), Icons.card_giftcard)
  ];

  static List<Category> expenseCategories = [
    Category("Restaurants", Color(random.nextInt(0xffffffff)), Icons.restaurant),
    Category("Groceries", Color(random.nextInt(0xffffffff)), Icons.shopping_basket),
    Category("Leisure", Color(random.nextInt(0xffffffff)), Icons.event),
    Category("Games", Color(random.nextInt(0xffffffff)), Icons.gamepad),
    Category("Movies & Music", Color(random.nextInt(0xffffffff)), Icons.movie),
    Category("Snacks", Color(random.nextInt(0xffffffff)), Icons.fastfood),
    Category("Transportation", Color(random.nextInt(0xffffffff)), Icons.airplanemode_active),
    Category("Debts", Color(random.nextInt(0xffffffff)), Icons.account_balance),
    Category("Taxes", Color(random.nextInt(0xffffffff)), Icons.receipt),
    Category("Rent", Color(random.nextInt(0xffffffff)), Icons.home),
    Category("Subscriptions", Color(random.nextInt(0xffffffff)), Icons.cached),
    Category("Tuition", Color(random.nextInt(0xffffffff)), Icons.business),
    Category("Gift", Color(random.nextInt(0xffffffff)), Icons.card_giftcard),
    Category("Clothes", Color(random.nextInt(0xffffffff)), Icons.person),
    Category("Hobbies", Color(random.nextInt(0xffffffff)), Icons.book),
    Category("Beverages", Color(random.nextInt(0xffffffff)), Icons.local_drink)
  ];

  Data(){
    for(Account a in accounts) {
      for (Category c in expenseCategories) {
        if(random.nextInt(100) < 70) a.budgets[c] = random.nextInt(400) + 601.0;
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
                double.parse(random.nextDouble().toStringAsFixed(2)));
            t.cause = "Placeholder lorem ipsum";
            t.time = TimeOfDay(hour: 14 + k, minute: random.nextInt(60));

            List<Category> categories = expense
                ? expenseCategories
                : incomeCategories;
            t.category=categories[random.nextInt(categories.length)];
          }
        }
        a.months.add(month);
      }
    }
    account = accounts[0];
  }
}