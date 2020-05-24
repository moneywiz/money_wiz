import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';


class AddCategoryView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddCategoryView();
}


class _AddCategoryView extends State<StatefulWidget> {

  Color pickerColor ;
  Color currentColor = Color(0xff443a48);
  String name = "";
  String limit = "";
  Icon _icon ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Category"),
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
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                ),
                ListTile(
                  title: Text("Category Name"),
                  subtitle: name == "" ? Text("Not Selected") : Text("$name", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    createCategoriesNewPopUp(context).then((onValue){
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
                  title: Text("Max Monthly Limit"),
                  subtitle: limit == "" ? Text("Non-Limit") : Text("$limit €", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    createCategoriesNewPopUp(context).then((onValue){
                      if (onValue != null) {
                        setState(() {
                          limit = onValue;
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text("Color"),
                        onTap: (){
                          selectColorPopUp(context);
                        },
                      ),
                    ),
                    Expanded(
                      child:
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: pickerColor,
                              shape: BoxShape.circle
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text("Icon"),
                        onTap: (){
                          _pickIcon();
                        },
                      ),
                    ),
                    Expanded(
                      child:
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: _icon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: RaisedButton(
                  child: Text("Create", style: TextStyle(fontSize: 14, color: Colors.white),),
                  color: Colors.blue,
                  onPressed: (){},
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.materialOutline);

    _icon = Icon(icon, size: 50);
    setState((){});

    print('Picked Icon:  $icon');
  }

   selectColorPopUp(BuildContext context){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Pick one Color :"),
          //content: TextField(
          //),
          actions: <Widget>[
            BlockPicker(
              pickerColor: currentColor,
              onColorChanged:  (Color color){
                setState((){
                  pickerColor = color;
                });
                Navigator.of(context).pop();
              }),
              ],
            );
    });
  }


  Future<String> createCategoriesNewPopUp(BuildContext context){

    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Category Name"),
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

}
