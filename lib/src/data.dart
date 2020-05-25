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

  static final Account allAccounts = Account("All accounts", "All accounts", accounts.fold(0, (double res, Account b) => res + b.startingBalance));

  static List<Category> incomeCategories = [
    Category("Salary", Color(0xff607d8b), Icons.monetization_on, causes: [
      "Vencimento",
      "Bónus",
      "Subsídio de Alimentação"
    ]),
    Category("Refund", Color(0xff9e9e9e), Icons.money_off, causes: [
      "Devolução IRS",
      "Devolução Prenda de Natal"
    ]),
    Category("Gift", Color(0xff795548), Icons.card_giftcard, causes: [
      "Prenda de aniversário - Ana",
      "Prenda de Natal - João"
    ])
  ];

  static List<Category> expenseCategories = [
    Category("Restaurants", Color(0xff8bc34a), Icons.restaurant, causes: [
      "Almoço McDonald's",
      "Jantar Ali Kebab",
      "Jantar de Aniversário",
      "Almoço Cantina",
      "Jantar Telepizza"
    ]),
    Category("Groceries", Color(0xff2196f3), Icons.shopping_basket, causes: [
      "Snacks para casa",
      "Leite e Ovos",
      "Comida para o Jantar"
    ]),
    Category("Leisure", Color(0xff00bcd4), Icons.event, causes: [
      "Bilhete do Enterro 2020",
      "GoKarts Oiã"
    ]),
    Category("Games", Color(0xff673ab7), Icons.gamepad, causes: [
      "Rocket League",
      "Assassin's Creed Rogue",
      "Super Mario Kart",
      "Fortnite Battle Pass",
      "Minecraft"
    ]),
    Category("Movies & Music", Color(0xff009688), Icons.movie, causes: [
      "Star Wars III: Revenge of The Sith",
      "Sonic the Hedgehog",
      "Interstellar - BluRay",
      "Dark Side of The Moon - Pink Floyd",
      "Dark Knight",
      "Inception - DVD",
    ]),
    Category("Snacks", Color(0xffcddc39), Icons.fastfood, causes: [
      "Tripa com Chocolate - Tripas da Praça",
      "Croissant com Chocolate - DBio",
      "Gelado Epá",
      "Ovos Moles - 12x"
    ]),
    Category("Transportation", Color(0xffff9800), Icons.airplanemode_active, causes: [
      "Regional Coimbra-Aveiro",
      "Uber para a estação",
      "Alfa-Pendular para Lisboa",
      "Autocarro para Costa-Nova"
    ]),
    Category("Debts", Color(0xff9c27b0), Icons.account_balance, causes: [
      "Pagamento hipoteca",
      "Empréstimo do carro"
    ]),
    Category("Taxes", Color(0xffffc107), Icons.receipt, causes: [
      "Pagamento IMI",
      "Imposto de circulação"
    ]),
    Category("Rent", Color(0xff4caf50), Icons.home, causes: [
      "Renda Apartamento",
      "Renda Casa da Praia"
    ]),
    Category("Subscriptions", Color(0xffffeb3b), Icons.cached, causes: [
      "Spotify",
      "Netflix",
      "Playstation Plus",
      "Ginásio"
    ]),
    Category("Tuition", Color(0xffff5722), Icons.business, causes: [
      "Propinas",
      "Pré-escola - João"
    ]),
    Category("Gift", Color(0xff3f51b5), Icons.card_giftcard, causes: [
      "Prenda para a Maria",
      "Bicicleta para o João"
    ]),
    Category("Clothes", Color(0xffe91e63), Icons.person, causes: [
      "Sapatilhas de corrida - Sport Zone",
      "Botas de montanha - Decathlon"
    ]),
    Category("Hobbies", Color(0xff03a9f4), Icons.book, causes: [
      "Câmara de Ar para a bicicleta",
      "Raspberry Pi 4 4Gb"
    ]),
    Category("Beverages", Color(0xfff44336), Icons.local_drink, causes: [
      "Sumol de Ananás",
      "Garrafa de Água 1L",
      "Pepsi Max"
    ])
  ];

  Data(){
    for (var i in Iterable<int>.generate(6).toList()) {
      Month month = Month(2020, i + 1);
      for (var j in Iterable<int>.generate(Month.nDays(i + 1, 2020)).toList()) {
        Day d = Day(month, j + 1);
      }
      allAccounts.months.add(month);
    }

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

            List<Category> categories = expense
                ? expenseCategories
                : incomeCategories;
            t.category=categories[random.nextInt(categories.length)];

            t.cause = t.category.causes != null ? t.category.causes[random.nextInt(t.category.causes.length)] : "Placeholder lorem ipsum";
            t.time = TimeOfDay(hour: 14 + k, minute: random.nextInt(60));
            t.account = a;
          }
        }
        a.months.add(month);
      }
    }
    account = accounts[0];
  }
}