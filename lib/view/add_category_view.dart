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


class AddCategory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddCategory();
}


class _AddCategory extends State<StatefulWidget> {

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a48);

  Icon _icon;


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
            flex: 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Text("Category Name: "),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: TextField(
                  ),
                ),
              ],
            )
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: RaisedButton(
                      child: Text("Select Color"),
                      onPressed: (){ selectColorPopUp(context);},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: pickerColor,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                ],
                ),
            ),
          Expanded(
            flex: 2,
            child: Row(
              children : <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: RaisedButton(
                    onPressed: _pickIcon,
                    child: Text('Open IconPicker'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: _icon,
                )
              ],
            )

          )

        ],
      ),
    );
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context, iconPackMode: IconPack.materialOutline);

    _icon = Icon(icon);
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

}