import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/data.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';


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

  GlobalKey scaffold = new GlobalKey();

  bool isAddView;
  List<Category> categories;
  String category_type;

  Color pickerColor ;
  Color currentColor = Color(0xff443a48);

  int id;
  String name = "";
  double limit = 0.0;
  IconData _icon ;


  _AddCategoryView(bool isAddView, int id, this.categories){
    if(categories == Data.expenseCategories){
      category_type = "Expense";
    }
    else{
      category_type = "Income";
    }
    this.id = id;
    this.isAddView = isAddView;
    if (!isAddView){
      Category c = categories[id];
      name = c.name;
      pickerColor = c.color;
      _icon = c.icon;
      limit = Data.account.budgets[c];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: isAddView ? Text("New $category_type Category"):  Text("Change $category_type Category"),
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
                    createCategoriesNewPopUp(context, name).then((onValue){
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
                  subtitle: limit == 0.0 || limit == null ? Text("No Limit") : Text("${limit.toStringAsFixed(2)}€", style: TextStyle(color: Colors.blue),),
                  onTap: (){
                    limitNewPopUp(context, limit).then((onValue){
                      if (onValue != null) {
                        setState(() {
                          if(onValue == "") limit = 0.0;
                          else {
                            double val = double.tryParse(onValue);
                            if (val < 0) (scaffold.currentState as ScaffoldState).showSnackBar(
                                  SnackBar(content: Text('Only positive values are allowed!')));
                            else limit = val;
                          }
                        });
                      }
                    });
                  }
                )
                : categories == Data.incomeCategories ?
                SizedBox.shrink()    :
                Container(
                  child:
                  ListTile(
                    title: Text("Max Monthly Limit", style: TextStyle(color: Colors.black26),),
                    subtitle: limit == "null" ? Text("No Limit") : Text("$limit €", style: TextStyle(color: Colors.blue),),
                    ),
                  ),

                categories == Data.expenseCategories?
                const Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 1,
                  endIndent: 10,
                )
                :
                SizedBox.shrink(),
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
                getDelete()
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(name == ""){
            (scaffold.currentState as ScaffoldState).showSnackBar(
                SnackBar(content: Text('All fields must be filled!')));
            return;
          }
          if(isAddView){
            Category c = new Category(name, pickerColor, _icon);
            categories.add(c);
            if (categories == Data.expenseCategories){
              if (limit != 0.0){
                Data.account.budgets[c] = limit;
              }
            }
          }
          else{
            Category c = categories[id];
            c.name = name;
            c.color = pickerColor;
            c.icon = _icon;
            if (categories == Data.expenseCategories){
              if (limit != 0.0){
                Data.account.budgets[c] = limit;
              }
              else{
                Data.account.budgets.remove(c);
              }
            }
          }
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget getDelete() {
    if(!isAddView) {
      return Column(
        children: <Widget>[
          ListTile(
            title: Text("Remove", style: TextStyle(color: Colors.red),),
            subtitle: Text("Permanently remove this category"),
            onTap: (){
              RemovePopUp(context, name).then((onValue){
                if(onValue == true){
                  for(int i = 0; i<Data.accounts.length; i++){
                    Data.accounts[i].budgets.remove(categories[id]);
                  }
                  for(Month month in Data.account.months) {
                    for(Day day in month.days) {
                      List<Transaction> lst = List.from(day.transactions);
                      for(Transaction transaction in lst) {
                        if(transaction.category == categories[id]) day.removeTransaction(transaction);
                      }
                    }
                  }
                  categories.removeAt(id);
                  Navigator.of(context).pop();
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
          )
        ],
      );
    }
    else return SizedBox.shrink();
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


  Future<String> createCategoriesNewPopUp(BuildContext context, String name){

    TextEditingController customController = TextEditingController()..text = name;

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


  Future<String> limitNewPopUp(BuildContext context, double value){

    TextEditingController customController = TextEditingController()..text = value != null ? value.toStringAsFixed(2) : "0.0";

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Category Limit"),
          content: TextField(
            controller: customController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                String value = customController.text.toString();
                Navigator.of(context).pop(value);
              },
            ),
          ]
      );
    });
  }

  Future<bool> RemovePopUp(BuildContext context, String name){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Remove Category ${name}?", style: TextStyle(fontSize: 17),),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Remove", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ]
      );
    });
  }


}
