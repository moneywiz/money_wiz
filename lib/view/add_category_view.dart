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

  bool isAddView;

  int id;

  AddCategoryView(bool isAddView, int id){
    this.isAddView = isAddView;
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() => _AddCategoryView(isAddView, id);
}


class _AddCategoryView extends State<StatefulWidget> {

  bool isAddView;

  Color pickerColor ;
  Color currentColor = Color(0xff443a48);

  int id;
  String name = "";
  String limit = "";
  IconData _icon ;


  _AddCategoryView(bool isAddView, int id){
    this.id = id;
    this.isAddView = isAddView;
    if (!isAddView){
      Category c = Data.expenseCategories[id];
      name = c.name;
      pickerColor = c.color;
      _icon = c.icon;
      limit = Data.account.budgets[c].toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isAddView ? Text("New Category"):  Text("Change Category"),
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
                  subtitle: limit == "null" ? Text("Non-Limit") : Text("$limit €", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    limitNewPopUp(context).then((onValue){
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
                InkWell(
                  onTap: (){
                    selectColorPopUp(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text("Color"),
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
                ),
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                ),
                InkWell(
                  onTap: (){
                    _pickIcon();
                  },
                  child:
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text("Icon"),
                        ),
                      ),
                      Expanded(
                        child:
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Icon(_icon, size: 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(isAddView){
            Category c = new Category(name, pickerColor, _icon);
            Data.expenseCategories.add(c);
            Data.account.budgets[c] = double.parse(limit);
          }
          else{
            Category c = Data.expenseCategories[id];
            c.name = name;
            c.color = pickerColor;
            c.icon = _icon;
            Data.account.budgets[c] = double.parse(limit);
          }
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  _pickIcon() async {
    _icon = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.materialOutline);
    setState((){});

  }

  selectColorPopUp(BuildContext context){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Pick One Color :"),
        actions: <Widget>[
          SizedBox(
            height: 380,
            child:
              BlockPicker(
                  pickerColor: currentColor,
                  onColorChanged:  (Color color){
                    setState((){
                      pickerColor = color;
                    });
                    Navigator.of(context).pop();
                  }
              ),
          )
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


  Future<String> limitNewPopUp(BuildContext context){

    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Category Limit"),
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
