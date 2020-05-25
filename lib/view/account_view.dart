import 'package:flutter/material.dart';
import 'package:moneywiz/src/account.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:flutter/cupertino.dart';
import 'package:moneywiz/view/account_form_view.dart';
import 'package:moneywiz/view/limit_view.dart';
import 'package:moneywiz/view/stats_view.dart';
import 'package:moneywiz/view/update_categories_view.dart';
import 'package:moneywiz/view/day_view.dart';

class AccountView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AccountViewState();
}


class AccountViewState extends State<StatefulWidget> {

  static final Account _add = Account("Create New Account", null, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MoneyWiz"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
            child: DropdownButton<Account>(
              hint: Row(
                children: <Widget>[
                  Text("Account: ",
                    style: TextStyle(fontSize: 16, color: Colors.white),),
                  Text(Data.account.toString(),
                    style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
              icon: Icon(Icons.expand_more),
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (Account newValue) {
                if(newValue == _add) {
                  Navigator.of(context).push( MaterialPageRoute(builder: (context) => (AccountFormView(null))));
                }
                else {
                  setState(() {
                    Data.account = newValue;
                  });
                }
              },
              items: getAccounts(),
            ),
          )
        )
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(18, 25, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text("Description: ", style: TextStyle(fontSize: 15)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 14, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(Data.account.description, style: TextStyle(fontSize: 18)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(18, 35, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text("Balance: ", style: TextStyle(fontSize: 15)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 18, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text((Data.account.balance as double).toStringAsFixed(2) + " €",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: (Data.account.balance as double) > 0 ? Colors.green : Colors.red),),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: ListView(
                padding: const EdgeInsets.only(left:20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Calendar"),
                    subtitle: Text("Check all your transactions or add new ones"),
                    leading: Icon(Icons.calendar_today, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => DayView(Data.months[5].days[9])));
                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Statistics"),
                    subtitle: Text("Analyze your transaction data"),
                    leading: Icon(Icons.show_chart, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => StatsView(4)));
                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    enabled: Data.account != Data.allAccounts,
                    title: Text("Budget Goals"),
                    subtitle: Text("Set monthly limits for each category"),
                    leading: Icon(Icons.flag, color: Data.account != Data.allAccounts ? Colors.blue : Colors.grey),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => Limit(4)));
                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text("Categories"),
                    subtitle: Text("Manage categories to organize your data"),
                    leading: Icon(Icons.loyalty, color: Colors.blue),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => (MainCategories())));
                    },
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 20,
                    thickness: 1,
                    indent: 65,
                    endIndent: 10,
                  ),
                  ListTile(
                    enabled: Data.account != Data.allAccounts,
                    title: Text("Account Settings"),
                    subtitle: Text("Edit or delete the current account"),
                    leading: Icon(Icons.account_balance_wallet, color: Data.account != Data.allAccounts ? Colors.blue : Colors.grey),
                    onTap: (){
                      Navigator.of(context).push( MaterialPageRoute(builder: (context) => (AccountFormView(Data.account))));
                    },
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem> getAccounts() {
    List<DropdownMenuItem> res = Data.accounts.map<DropdownMenuItem<Account>>((Account value) {
      return DropdownMenuItem<Account>(
        value: value,
        child: Text(value.name,
          style: TextStyle(inherit: false, fontSize: 17, color: Colors.black),),
      );
    }).toList();
    res.addAll(<DropdownMenuItem<Account>>[
      DropdownMenuItem<Account>(
          value: Data.allAccounts,
          child: Row (
              children: <Widget>[
                Icon(Icons.pie_chart),
                Text("  All Accounts",
                  style: TextStyle(inherit: false, fontSize: 17, color: Colors.black),),
              ],
            )
      ),
      DropdownMenuItem<Account>(
          value: _add,
          child: Row (
            children: <Widget>[
              Icon(Icons.add),
              Text("  Create New Account",
                style: TextStyle(inherit: false, fontSize: 17, color: Colors.black),),
            ],
          )
      )
      ]
    );
    return res;
  }
}