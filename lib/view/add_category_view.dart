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
  State<StatefulWidget> createState() => _AddCategoryView(newCategory, updateCategory, tipo, c, limit, id);

  Function(Category c, String limit) newCategory;
  Function(Category c, String limit, int id) updateCategory;
  String tipo;
  Category c;
  double limit;
  int id;


  AddCategoryView(newCategory, updateCategory, tipo, c, limit, id){
    this.newCategory = newCategory;
    this.tipo = tipo;
    this.c = c;
    this.limit = limit;
    this.id = id;
    this.updateCategory = updateCategory;
  }
}


class _AddCategoryView extends State<StatefulWidget> {

  String tipo;
  int id;

  Color pickerColor ;
  Color currentColor = Color(0xff443a48);
  String name = "";
  String limit = "";
  Icon _icon ;
  IconData _icondata;

  Function(Category c, String limit) newCategory;
  Function(Category c, String limit, int id) updateCategory;

  _AddCategoryView(newCategory, updateCategory, tipo, c, limit, id){
    if (tipo == "new"){
      this.newCategory = newCategory;
      this.tipo = tipo;
    }
    else{
      name = c.name;
      pickerColor = c.color;
      _icondata = c.icon;
      this.limit = limit.toString();
      _icon = Icon(_icondata);
      this.id = id;
      this.updateCategory = updateCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: tipo == "new" ? Text("New Category") : Text("Changing Category"),
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
                InkWell(
                  onTap: (){
                    selectColorPopUp(context);
                  },
                  child:
                  Row(
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
                          child: _icon,
                        ),
                      ),
                    ],
                  ),
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
                  child: (tipo == "new") ? Text("Create", style: TextStyle(fontSize: 14, color: Colors.white),) : Text("Submit", style: TextStyle(fontSize: 14, color: Colors.white),),
                  color: Colors.blue,
                  onPressed: (){
                    Navigator.of(context).pop();
                    Category c = new Category(name, pickerColor, _icondata);
                    if(tipo == "new"){
                      newCategory(c, limit);
                    }
                    else{
                      updateCategory(c, limit, id);
                    }

                  },
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }

  _pickIcon() async {
    IconData _icondata = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.material);

    _icon = Icon(_icondata, size: 50);
    setState((){});

    print('Picked Icon:  $_icondata');
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
