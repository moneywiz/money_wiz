import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/data.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';


class AddCategoryView extends StatefulWidget{

  bool isAddView;
  List<Category> categories;

  int id;

  AddCategoryView(bool isAddView, int id, this.categories){
    this.isAddView = isAddView;
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() => _AddCategoryView(isAddView, id, categories);
}


class _AddCategoryView extends State<StatefulWidget> {

  bool isAddView;
  List<Category> categories;

  Color pickerColor ;
  Color currentColor = Color(0xff443a48);

  int id;
  String name = "";
  String limit = "";
  IconData _icon ;


  _AddCategoryView(bool isAddView, int id, this.categories){
    this.id = id;
    this.isAddView = isAddView;
    if (!isAddView){
      Category c = categories[id];
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


                categories == Data.expenseCategories && Data.account != Data.allAccounts ?
                ListTile(
                  title: Text("Max Monthly Limit"),
                  subtitle: limit == "null" ? Text("No Limit") : Text("$limit €", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    limitNewPopUp(context).then((onValue){
                      if (onValue != null) {
                        setState(() {
                          limit = onValue;
                        });
                      }
                    });

                  },
                )
                :
                Container(
                  child:
                  ListTile(
                    title: Text("Max Monthly Limit", style: TextStyle(color: Colors.black26),),
                    subtitle: limit == "null" ? Text("No Limit") : Text("$limit €", style: TextStyle(color: Colors.blue),),
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
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
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
            categories.add(c);
            if (categories == Data.expenseCategories){
              Data.account.budgets[c] = double.parse(limit);
            }
          }
          else{
            Category c = categories[id];
            c.name = name;
            c.color = pickerColor;
            c.icon = _icon;
            if (categories == Data.expenseCategories){
              Data.account.budgets[c] = double.parse(limit);
            }
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
