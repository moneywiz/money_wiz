import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:moneywiz/view/add_category_view.dart';



class MainCategories extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainCategories();
}


class _MainCategories extends State<StatefulWidget> {

//Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddCategoryView(true, 0))).then((onValue){
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar: AppBar(
          title: Text("Categories"),
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              Tab(
                  text: "Expenses",
                  icon: Icon(Icons.attach_money)
              ),
              Tab(
                  text: "Income",
                  icon: Icon(Icons.account_balance_wallet)
              ),
            ]
          ),
        ),
        body:
        Column(
          children: <Widget>[
            Expanded(
                child: TabBarView(
                    children: [
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          for (int i = 0; i<Data.expenseCategories.length; i++)
                            MyTile(i, Data.expenseCategories, changeName, removeName),

                        ],
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          for (int i = 0; i<Data.incomeCategories.length; i++)
                            MyTile(i, Data.incomeCategories, changeName, removeName),

                        ],
                      ),
                    ]
                ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      )
    );
  }

  /*List<Category> deepCopyListCategories(){
    List<Category> new_list = new List<Category>();
    for(int i = 0; i<Data.expenseCategories.length; i++){
      new_list.add(new Category(Data.expenseCategories[i].name));
    }
    return new_list;
  }*/

  changeName(String name, int id, List<Category> categories){
    setState(() {
      categories[id].name = name;
    });
  }

  removeName(int id, List<Category> categories){
    setState(() {
      for(int i = 0; i<Data.accounts.length; i++){
        Data.accounts[i].budgets.remove(categories[id]);
      }
      categories.removeAt(id);
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
  List<Category> categories;

  Category category;
  String name;

  Function(String new_name, int id, List<Category> categories) changeName;
  Function(int id, List<Category> categories) removeName;

  @override
  MyTile(this.id, this.categories, this.changeName, this.removeName){
    category = categories[id];
    name = category.name;
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await createCategoriesRemovePopUp(context, name).then((onValue){
          if(onValue == true){
            removeName(id, categories);
            return true;
          }
          return false;
        });
      },
      child: ListTile(
        onTap: (){
          Navigator.of(context).push( MaterialPageRoute(builder: (context) => (AddCategoryView(false, id)))).then((onValue){
            changeName(categories[0].name, 0, categories);
          });
        },
        leading: Icon(category.icon, color: Colors.black,),
        title: Text(name),
      ),
    );
  }

  Future<bool> createCategoriesRemovePopUp(BuildContext context, String name){

    return showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text("Remove Category ${name}?", style: TextStyle(fontSize: 18),),
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
