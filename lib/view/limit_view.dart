import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:moneywiz/src/category.dart';
import 'package:flutter/material.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';

class Limit extends StatefulWidget{
  int month;

  @override
  Limit(this.month);

  @override
  State<StatefulWidget> createState() => _Limit();
}

class _Limit extends State<Limit> {
  GlobalKey scaffold = new GlobalKey();
  String account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffold,
        appBar: AppBar(
        title: Text("Budget Goals"),
    ),
    body:
    Column(
      children: <Widget>[
        Expanded(
            flex: 8,
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: getBudgets()
            ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: CalendarHeader(
                    showHeader: true,
                    headerTitle: Month.months[Data.months[widget.month].month - 1] + " " +  Data.months[widget.month].year.toString(),
                    onLeftButtonPressed: (){
                      if(widget.month - 1 >= 0) {
                        widget.month -= 1;
                        this.setState(() {});
                      }
                    },
                    onRightButtonPressed: (){
                      if(Data.months.length > widget.month + 1) {
                        widget.month += 1;
                        this.setState(() {});
                      }
                    },
                    showHeaderButtons: true,
                    isTitleTouchable: false,
                    onHeaderTitlePressed: null
                )
            )
          ),


        ],
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createBudgetPopUp(context).then((onValue){
            setState(() {});
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  List<Widget> getBudgets() {
    List<Widget> res = [
      Padding(
        padding: EdgeInsets.only(top: 15),
      )
    ];
    SplayTreeMap<Category,double> map=SplayTreeMap.from(Data.account.budgets, (c1,c2)=>c1.name.compareTo(c2.name));
    map.entries.forEach((MapEntry<Category, double> e) {
      double budget = e.value;
      double spent = (Data.months[widget.month] as Month).spentOnCategory(e.key);
      double available = budget - spent;
      double percent = available >= 0 ? (spent / budget) : 1;
      res.addAll(
        <Widget>[
          Dismissible(
            key: UniqueKey(),
            background: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20.0),
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              return await RemovePopUp(context, e.key.name).then((onValue){
                if(onValue == true){
                  Data.account.budgets.remove(e.key);
                  return true;
                }
                return false;

              });
            },
            child:
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  updateBudgetPopUp(context, e.key, e.value).then((onValue){
                      setState(() {});
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,2,0,0),
                      child:
                        Row(children: <Widget>[
                            Text("Category: " ,style: TextStyle(fontSize: 14),),
                            Text(e.key.name ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ]
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 5, 0, 0),
                      child:
                        Row(children: <Widget>[
                          Row(
                            children: [
                              Text("Budget: " ,style: TextStyle(fontSize: 14),),
                              Text(budget.toStringAsFixed(2) + "€" ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                            ]
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 30),
                            alignment: Alignment.centerRight,
                            child: Icon(
                              e.key.icon
                            )
                          )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 5, 0, 0),
                      child:
                        Row(children: <Widget>[
                            Text("Available: " ,style: TextStyle(fontSize: 14),),
                            Text(available.toStringAsFixed(2) + "€" ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: percent == 1 ? Colors.red : (percent > 0.8 ? Colors.orange : Colors.green)),),
                          ]
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12,7,12,2),
                      child:
                        LinearPercentIndicator(
                          percent: percent,
                          lineHeight: 4,
                          progressColor: percent == 1 ? Colors.red : (percent > 0.8 ? Colors.orange : Colors.green),
                        )
                    ),
                    const Divider(
                      color: Colors.black12,
                      height: 20,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    )
                  ]
                )
              )
          )
        ],
      );
    });
    return res;
  }

  Future createBudgetPopUp(BuildContext context){

    List<Category> categories = getCategories();
    if (categories.length == 0) {
      (scaffold.currentState as ScaffoldState).showSnackBar(SnackBar(content: Text('All categories already have a budget in this account!')));
      return null;
    }

      TextEditingController customController = TextEditingController()..text = "0.0";
      Category category;

      return showDialog(context: context, builder: (context){
        return StatefulBuilder(
            builder: (context, setState)
        {
          return AlertDialog(
              title: Text("Create New Budget"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text("Category: ", style: TextStyle(fontSize: 14),),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: DropdownButton<Category>(
                          value: category,
                          icon: Icon(Icons.expand_more),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.black
                          ),
                          onChanged: (Category newValue) {
                            setState(() {
                              category = newValue;
                            });
                          },
                          items: () {
                            categories.sort((c1,c2)=>c1.name.compareTo(c2.name));
                            return categories.map<DropdownMenuItem<Category>>((
                              Category category) {
                            return DropdownMenuItem<Category>(
                              value: category,
                              child: Text(category.name),
                            );
                          })
                              .toList();
                          }.call(),
                        )
                    )
                  ]
                  ),
                  Row(children: <Widget>[
                    Text("Budget:  " ,style: TextStyle(fontSize: 14),),
                    Flexible (
                        child: Container(
                            padding: EdgeInsets.fromLTRB(16, 0, 70, 0),
                            child: TextField(
                              controller: customController,
                              keyboardType: TextInputType.number,
                            )
                        )
                    )
                  ]
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if(category == null) {
                      (scaffold.currentState as ScaffoldState).showSnackBar(
                          SnackBar(content: Text('Category must be specified!')));
                      Navigator.of(context).pop();
                      return;
                    }
                    if(customController.value.text == "") {
                      (scaffold.currentState as ScaffoldState).showSnackBar(
                          SnackBar(content: Text('Budget value must be filled!')));
                      Navigator.of(context).pop();
                      return;
                    }
                    double newValue = double.tryParse(customController.value.text);
                    if(newValue > 0) Data.account.budgets[category] = newValue;
                    else (scaffold.currentState as ScaffoldState).showSnackBar(SnackBar(content: Text('Only positive budget values are allowed!')));
                    Navigator.of(context).pop();
                  },
                ),
              ]
          );
        });
      });
    }

  List<Category> getCategories() {
    return Data.expenseCategories.where((Category c) => !(Data.account.budgets.keys.contains(c))).toList();
  }

  Future updateBudgetPopUp(BuildContext context, Category category, double budget){

    TextEditingController customController = TextEditingController()..text = budget.toStringAsFixed(2);

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Update Budget"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[
                  Text("Category:  " ,style: TextStyle(fontSize: 14),),
                  Text(category.name ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ]
              ),
              Row(children: <Widget>[
                  Text("Budget:  " ,style: TextStyle(fontSize: 14),),
                  Flexible (
                    child: Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 70, 0),
                        child: TextField(
                          controller: customController,
                          keyboardType: TextInputType.number
                        )
                    )
                  )
                ]
              )
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Remove", style: TextStyle(color: Colors.red),),
              onPressed: () {
                RemovePopUp(context, category.name).then((onValue){
                  if(onValue == true){
                    Data.account.budgets.remove(category);
                  }
                  Navigator.of(context).pop();
                });
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                if(customController.value.text == "") {
                  (scaffold.currentState as ScaffoldState).showSnackBar(
                      SnackBar(content: Text('Budget value must be filled!')));
                  Navigator.of(context).pop();
                  return;
                }
                double newValue = double.tryParse(customController.value.text);
                if(newValue > 0) Data.account.budgets[category] = newValue;
                else (scaffold.currentState as ScaffoldState).showSnackBar(SnackBar(content: Text('Negative budget values are not allowed!')));
                Navigator.of(context).pop();
              },
            ),
          ]
      );
    });
  }

  Future<bool> RemovePopUp(BuildContext context, String name){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Remove Budget for Category ${name}?", style: TextStyle(fontSize: 17),),
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
              child: Text("Remove", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]
      );
    });
  }
}