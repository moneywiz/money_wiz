import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class UpdateCategories extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UpdateCategories();
}


class _UpdateCategories extends State<StatefulWidget> {


    List<Category> temp_categories;

  _UpdateCategories() {
    this.temp_categories = deepCopyListCategories();
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
                            createCategoriesNewPopUp(context).then((onValue){
                              if (onValue != null && onValue != ""){
                                setState(() {
                                  temp_categories.add(new Category(onValue));
                                });
                              }
                            });
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
                    MyTile(i, temp_categories[i].name, changeName, removeName),

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
      new_list.add(new Category(Data.expenseCategories[i].name));
    }
    return new_list;
  }

  changeName(String name, int id){
    setState(() {
      temp_categories[id].name = name;
    });
  }

  removeName(int id){
    setState(() {
      print(temp_categories.removeAt(id));
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
    return ListTile(
      onTap: (){
        createCategoriesFormPopUp(context).then((onValue){
          if(onValue != null && onValue != ""){
            changeName(onValue, id);
          }
        });
      },
      onLongPress: (){
        createCategoriesRemovePopUp(context, name).then((onValue){
          if (onValue == true) {
            removeName(id);
          }
        });
      },
      leading: Icon(Icons.map),
      title: Text(name),
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


