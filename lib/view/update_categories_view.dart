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

  bool incomeSelected = false;

//Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddCategoryView(true, 0))).then((onValue){
  @override
  Widget build(BuildContext context) {
    Data.expenseCategories.sort((c1, c2){
      return c1.name.compareTo(c2.name);
    });

    Data.incomeCategories.sort((c1, c2){
      return c1.name.compareTo(c2.name);
    });


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
                            MyTile(i, Data.expenseCategories, updateWidget, updateTabSelected),

                        ],
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          for (int i = 0; i<Data.incomeCategories.length; i++)
                            MyTile(i, Data.incomeCategories, updateWidget, updateTabSelected),

                        ],
                      ),
                    ]
                ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            List<Category> l = Data.expenseCategories;
            if (incomeSelected){
              l = Data.incomeCategories;
            }
            Navigator.of(context).push( MaterialPageRoute(builder: (context) => (AddCategoryView(true, 0, l)))).then((onValue){
              updateWidget();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      )
    );
  }


  updateWidget(){
    setState((){});
  }

  updateTabSelected(bool value){
    incomeSelected = value;
  }



}


class MyTile extends StatelessWidget{

  int id;
  List<Category> categories;

  Function() updateWidget;
  Function(bool value) updateTabSelected;

  @override
  MyTile(this.id, this.categories, this.updateWidget, this.updateTabSelected);


  @override
  Widget build(BuildContext context) {
    if (categories == Data.incomeCategories){
      updateTabSelected(true);
    }
    else{
      updateTabSelected(false);
    }
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
        return await createCategoriesRemovePopUp(context, categories[id].name).then((onValue){
          if(onValue == true){
            for(int i = 0; i<Data.accounts.length; i++){
              Data.accounts[i].budgets.remove(categories[id]);
            }
            for(Month month in Data.account.months) {
              for(Day day in month.days) {
                List<Transaction> lst = List.from(day.transactions);
                for(Transaction transaction in lst){
                  if(transaction.category == categories[id]) day.removeTransaction(transaction);
                }
              }
            }
            categories.removeAt(id);
            updateWidget();
            return true;
          }
          return false;
        });
      },
      child: ListTile(
        onTap: (){
          Navigator.of(context).push( MaterialPageRoute(builder: (context) => (AddCategoryView(false, id, categories)))).then((onValue){
            updateWidget();
          });
        },
        leading: Icon(categories[id].icon, color: Colors.black,),
        title: Text(categories[id].name),
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
