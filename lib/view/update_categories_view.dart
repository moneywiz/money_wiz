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
        title: Text("Updating Categories"),
      ),
      body:
        Column(
          children: <Widget>[
            Expanded(
              child:
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  for (String s in Data.expenseCategories)
                    ListTile(
                      onTap: (){
                        createCategoriesFormPopUp(context);
                      },
                      leading: Icon(Icons.map),
                      title: Text(s),
                    ),
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


  createCategoriesFormPopUp(BuildContext context){

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
              },
            )
          ]
      );
    });
    }
}
