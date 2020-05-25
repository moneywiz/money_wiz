import 'package:flutter/material.dart';
import 'package:moneywiz/src/account.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/transaction.dart';

class AccountFormView extends StatefulWidget{

  bool isAddView;
  Account account;

  AccountFormView(this.account){
    this.isAddView = account == null;
  }

  @override
  State<StatefulWidget> createState() => AccountFormViewState();
}


class AccountFormViewState extends State<AccountFormView> {
  GlobalKey scaffold = new GlobalKey();

  String category_type;

  Color pickerColor ;
  Color currentColor = Color(0xff443a48);

  String name;
  String description;
  double startingBalance;

  void init(){
    name = widget.isAddView ? "" : widget.account.name;
    description = widget.isAddView ? "" : widget.account.description;
    startingBalance = widget.isAddView ? 0.0 : widget.account.startingBalance;
  }

  @override
  Widget build(BuildContext context) {
    if (name == null) init();
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: widget.isAddView ? Text("New Account"):  Text("Manage Account"),
      ),
      body:
      Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left:20),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: Text("Account Name"),
                  subtitle: name == "" ? Text("Not Selected") : Text("$name", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    accountNamePopUp(context, name).then((onValue){
                      if (onValue != null) {
                        setState(() {
                          name = onValue;
                        });
                      }
                    });
                  },
                ),
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                ),
                ListTile(
                  title: Text("Description"),
                  subtitle: description == "" ? Text("Not Selected") : Text("$description", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    accountDescriptionPopUp(context, description).then((onValue){
                      if (onValue != null) {
                        setState(() {
                          description = onValue;
                        });
                      }
                    });
                  },
                ),
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                ),
                ListTile(
                  title: Text("Starting Balance"),
                  subtitle: startingBalance == 0.0 ? Text("0.0€") : Text("${startingBalance.toStringAsFixed(2)}€", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    startingBalancePopUp(context, startingBalance).then((onValue){
                      if (onValue != null) {
                        setState(() {
                          if(onValue == "") startingBalance = 0.0;
                          else {
                            double val = double.tryParse(onValue);
                            if (val < 0) (scaffold.currentState as ScaffoldState).showSnackBar(
                                SnackBar(content: Text('Only positive values are allowed!')));
                            else startingBalance = val;
                          }
                        });
                      }
                    });
                  },
                ),
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                ),
                getDelete()
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(name == "" || description == ""){
            (scaffold.currentState as ScaffoldState).showSnackBar(
                SnackBar(content: Text('All fields must be filled!')));
            return;
          }
          if(widget.isAddView){
            widget.account = Account("", "", 0.0);
            Data.accounts.add(widget.account);
            for (var i in Iterable<int>.generate(6).toList()) {
              Month month = Month(2020, i + 1);
              for (var j in Iterable<int>.generate(Month.nDays(i + 1, 2020)).toList()) {
                Day d = Day(month, j + 1);
              }
              widget.account.months.add(month);
            }
          }
          widget.account.name = name;
          widget.account.description = description;
          widget.account.startingBalance = startingBalance;
          Data.account = widget.account;
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget getDelete() {
    if(!widget.isAddView) {
      return Column(
        children: <Widget>[
          ListTile(
            title: Text("Delete", style: TextStyle(color: Colors.red),),
            subtitle: Text("Permanently delete this account"),
            onTap: (){
              RemovePopUp(context, widget.account.name).then((onValue){
                if(onValue == true){
                  Data.accounts.remove(widget.account);
                  Data.account = Data.accounts.length > 0 ? Data.accounts[0]: Data.allAccounts;
                  for(Month month in Data.allAccounts.months) {
                    for(Day day in month.days) {
                      List<Transaction> lst = List.from(day.transactions);
                      for(Transaction transaction in lst){
                        if(transaction.account == widget.account) day.removeTransaction(transaction);
                      }
                    }
                  }
                  Navigator.of(context).pop();
                }
              });
            },
          ),
          const Divider(
            color: Colors.black12,
            height: 20,
            thickness: 1,
            indent: 1,
            endIndent: 10,
          )
        ],
      );
    }
    else return SizedBox.shrink();
  }

  Future<String> accountNamePopUp(BuildContext context, String value){

    TextEditingController customController = TextEditingController()..text = value;

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Account Name"),
          content: TextField(
            controller: customController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop(customController.text.toString());
              },
            ),
          ]
      );
    });
  }

  Future<String> accountDescriptionPopUp(BuildContext context, String value){

    TextEditingController customController = TextEditingController()..text = value;

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Account Description"),
          content: TextField(
            controller: customController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop(customController.text.toString());
              },
            ),
          ]
      );
    });
  }

  Future<String> startingBalancePopUp(BuildContext context, double value){

    TextEditingController customController = TextEditingController()..text = value.toStringAsFixed(2);

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Starting Balance"),
          content: TextField(
            controller: customController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                String value = customController.text.toString();
                if (value == ""){
                  value = "null";
                }
                Navigator.of(context).pop(value);
              },
            ),
          ]
      );
    });
  }

  Future<bool> RemovePopUp(BuildContext context, String name){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Delete Account ${name}?", style: TextStyle(fontSize: 17),),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Delete", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]
      );
    });
  }
}
