import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:moneywiz/view/add_category_view.dart';



class UpdateCategories extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UpdateCategories();
}


class _UpdateCategories extends State<StatefulWidget> {


    List<Category> temp_categories;

  _UpdateCategories() {
    this.temp_categories = deepCopyListCategories();
    print(temp_categories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body:
        Column(
          children: <Widget>[
            Container(
                color: Colors.blue,
                child:
                    Row(
                      children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text("Categories", style: TextStyle(fontSize: 17, color: Colors.white),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 220.0),
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddCategoryView(newCategory, null, "new", null, null, null)));
                          },
                          child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
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
                  for (int i = 0; i<temp_categories.length; i++)
                    MyTile(i, temp_categories[i].name, temp_categories[i].icon, temp_categories[i], Data.accounts[0].budgets[temp_categories[i]], changeName, removeName, updateCategory),

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
                        Data.expenseCategories = temp_categories;
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

  List<Category> deepCopyListCategories(){
    List<Category> new_list = new List<Category>();

    for(int i = 0; i<Data.expenseCategories.length; i++){
      new_list.add(new Category(Data.expenseCategories[i].name, Data.expenseCategories[i].color, Data.expenseCategories[i].icon));
    }
    return new_list;
  }

  changeName(String name, int id){
    setState(() {
      temp_categories[id].name = name;
    });
  }

  removeName(int id, String name){
    if (name == "remove"){
      setState(() {
        print(temp_categories.removeAt(id));
      });
    }
    else{
      setState((){});
    }

  }

  newCategory(Category c, String limit){
    setState((){
      temp_categories.add(c);
      if (limit != "") {
        Data.accounts[0].budgets[c] = double.parse(limit);
      }
    });
  }

  updateCategory(Category c, String limit, int id){
    setState(() {
      temp_categories[id] = c;
      Data.accounts[0].budgets[c] = double.parse(limit);
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
  IconData icondata;
  Category c;
  double limit;

  Function(String new_name, int id) changeName;
  Function(int id, String msg) removeName;
  Function(Category c, String limit, int id) updateCategory;

  MyTile(id, name, icondata, c, limit, changeName, removeName, updateCategory){
    this.id = id;
    this.name = name;
    this.changeName = changeName;
    this.removeName = removeName;
    this.icondata = icondata;
    this.c = c;
    this.limit = limit;
    this.updateCategory = updateCategory;
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction){
      createCategoriesRemovePopUp(context, name).then((onValue){
        if (onValue == true) {
          removeName(id, "remove");
        }
        else{
          removeName(id, "cancel");
        }
      });
      },
      child :ListTile(
        onTap: (){
          Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddCategoryView(null, updateCategory, "", c, limit, id)));
        },
        leading: Icon(icondata),
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


