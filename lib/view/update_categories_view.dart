import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';

class UpdateCategories extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _UpdateCategories();
}


class _UpdateCategories extends State<StatefulWidget> {


    List<String> temp_categories;

  _UpdateCategories() {
    this.temp_categories = List.from(Data.expenseCategories);
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
                  for (int i = 0; i<Data.expenseCategories.length; i++)
                    MyTile(i, temp_categories)

                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                  },
                  child: Text("Cancel"),
                ),
                RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () {
                  },
                  child: Text("Apply"),
                ),
              ],
            )
          ],
        ),
    );
  }



}


class MyTile extends StatefulWidget{

  int id;
  List<String> temp_categories;

  MyTile(id, temp_categories){
    this.id = id;
    this.temp_categories = temp_categories;
  }

  @override
  State<StatefulWidget> createState() => _MyTile(id, temp_categories);
}


class _MyTile extends State<StatefulWidget> {

  int id;
  List<String> temp_categories;

  _MyTile(id, temp_categories){
    this.id = id;
    this.temp_categories = temp_categories;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: (){
          createCategoriesFormPopUp(context).then((onValue){
            setState((){
              if (onValue != null ){
                temp_categories[id] = onValue;
              }
            });
          });
        },
        leading: Icon(Icons.map),
        title: Text(temp_categories[id]),
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
            MaterialButton(
              elevation: 5.0,
              child: Text("Remove"),
              onPressed: () {
              },
            )
          ]
      );
    });
  }

}


