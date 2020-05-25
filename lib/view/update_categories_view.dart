import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:moneywiz/view/add_category_view.dart';



class MainCategories extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainCategories();
}


class _MainCategories extends State<StatefulWidget> {

//Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddCategoryView(true, 0))).then((onValue){
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body:
      Column(
        children: <Widget>[
          DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                TabBar(
                  labelColor: Color(0xFF000000),
                  unselectedLabelColor: Color(0xFF000000),
                  tabs: <Widget>[
                    Tab(
                      text: "Expenses"
                    ),
                    Tab(
                      text: "Income"
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child:
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                for (int i = 0; i<Data.expenseCategories.length; i++)
                  MyTile(i, Data.expenseCategories[i].name, changeName, removeName),

              ],
            ),
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 310.0),
                child:  RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Apply"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /*List<Category> deepCopyListCategories(){
    List<Category> new_list = new List<Category>();
    for(int i = 0; i<Data.expenseCategories.length; i++){
      new_list.add(new Category(Data.expenseCategories[i].name));
    }
    return new_list;
  }*/

  changeName(String name, int id){
    setState(() {
      Data.expenseCategories[id].name = name;
    });
  }

  removeName(int id){
    setState(() {
      for(int i = 0; i<Data.accounts.length; i++){
        Data.accounts[i].budgets.remove(Data.expenseCategories[id]);
      }
      print(Data.expenseCategories.removeAt(id));
    });
  }

  Future<String> createCategoriesNewPopUp(BuildContext context){

    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("New Category name :"),
          content: TextField(
            controller: customController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Create"),
              onPressed: () {
                Navigator.of(context).pop(customController.text.toString());
              },
            ),
          ]
      );
    });
  }



}


class MyTile extends StatelessWidget{

  int id;
  String name;

  Function(String new_name, int id) changeName;
  Function(int id) removeName;

  MyTile(id, name, changeName, removeName){
    this.id = id;
    this.name = name;
    this.changeName = changeName;
    this.removeName = removeName;
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction){
        createCategoriesRemovePopUp(context, name).then((onValue){
          if(onValue == true){
            removeName(id);
          }
          else{
            changeName(Data.expenseCategories[0].name, 0);
          }
        });
      },
      child: ListTile(
        onTap: (){
          Navigator.of(context).push( MaterialPageRoute(builder: (context) => (AddCategoryView(false, id)))).then((onValue){
            changeName(Data.expenseCategories[0].name, 0);
          });
        },
        leading: Icon(Data.expenseCategories[id].icon),
        title: Text(name),
      ),
    );
  }


  Future<String> createCategoriesFormPopUp(BuildContext context){

    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("New Category name :"),
          content: TextField(
            controller: customController,
          ),
          actions: <Widget>[
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


  Future<bool> createCategoriesRemovePopUp(BuildContext context, String name){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Remove Category :\n '$name' ?"),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Remove"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]
      );
    });
  }


}
