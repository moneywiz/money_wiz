import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';


class NewTransaction extends StatefulWidget{
  final Day day;
  final Transaction tr;

  NewTransaction(this.day,[this.tr]);

  @override
  State<StatefulWidget> createState() => _NewTransactionState(day,tr);
}

class _NewTransactionState extends State<NewTransaction> {

  GlobalKey scaffold = new GlobalKey();

  AppBar appBar;

  Day day;
  Transaction tr;
  bool isNew;

  bool gain;
  DateTime formDateTime;
  String dropdownValue;
  Map<String,Category> allCats;

  TextEditingController _valueController;
  bool _validValue;
  TextEditingController _causeController;
  TextEditingController _descrController;

  _NewTransactionState(this.day,this.tr){
    _valueController=TextEditingController();
    _validValue=true;
    _causeController=TextEditingController();
    _descrController=TextEditingController();

    if (tr==null) {
      isNew=true;
      gain = false;
      tr=Transaction(day,0,false);
    }
    else {
      isNew=false;
      gain=tr.value>=0;
      _valueController.text="${tr.value.abs()}";
      _causeController.text=tr.cause;
      _descrController.text=tr.description;
      dropdownValue=tr.category?.name??"";
    }

    Map<String,Category> exp=Map.fromIterable(Data.expenseCategories, key: (elem)=>elem.name.toString(), value: (elem)=>elem);
    Map<String,Category> inc=Map.fromIterable(Data.incomeCategories, key: (elem)=>elem.name.toString(), value: (elem)=>elem);
    allCats=Map();
    allCats.addAll(exp);
    allCats.addAll(inc);

    appBar=AppBar(
      title: Text(isNew ? "New Transaction" : "Transaction"),
    );
  }

  @override
  void initState() {
    super.initState();
    _valueController.addListener(() {
      var lastValid=_validValue;
      if (double.tryParse(_valueController.text)==null) _validValue=false;
      else _validValue=true;
      if (lastValid!=_validValue) setState(() {
        _validValue=_validValue;
      });
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    _causeController.dispose();
    _descrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: appBar,
      //resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height-appBar.preferredSize.height-MediaQuery.of(context).padding.top), child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Divider(
            color: Colors.black12,
            height: 20,
            thickness: 1,
            indent: 1,
            endIndent: 10,
          ),
          Expanded(
            flex: 1,
              child:Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Transaction's \nTime", style: TextStyle(fontSize: 17),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 90),
                    child:
                    RaisedButton(
                      child: Text("${tr.time.hour.toString().padLeft(2, '0')}:${tr.time.minute.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 32)),
                      onPressed: () async {
                        TimeOfDay t=await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        setState(() {
                          tr.time??=t;
                        });
                      },
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
          Expanded(
            flex: 2,
            child:Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Value", style: TextStyle(fontSize: 17),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 90),
                  child:
                  Card(
                      color: gain ? Colors.green : Colors.red,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            gain = ! gain;
                            dropdownValue=null;
                          });
                        },
                        color: Colors.white,
                        icon: Icon(gain ? Icons.add : Icons.remove),

                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 22),
                    child:Container(
                      width: 130,
                      height: 70,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Value',
                          errorText: _validValue?"":"Must be a number",
                        ),
                      controller: _valueController,
                      ),
                    ),
                ),
              ],
            ),
          ),

          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


            ],
          ),*/
          const Divider(
            color: Colors.black12,
            height: 20,
            thickness: 1,
            indent: 1,
            endIndent: 10,
          ),
          Expanded(
            flex: 2,
            child:Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Cause", style: TextStyle(fontSize: 17),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 90),
                  child:
                      Container(
                        width: 230,
                        height: 45,
                        child:
                        TextField(
                          controller: _causeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cause',
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
          Expanded(
            flex: 2,
            child:Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Description", style: TextStyle(fontSize: 17),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 53),
                  child:
                  Container(
                    width: 230,
                    height: 245,
                    child:
                    TextField(
                      controller: _descrController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
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
          Expanded(
            flex: 2,
            child: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Category", style: TextStyle(fontSize: 17),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child:
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.black
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: _getDropdown(),
                ),
              )
            ],
            ),
          ),
        ],
      ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_validValue && _valueController.text!="") {
            tr.value = double.tryParse(_valueController.text);
            if (!gain) tr.value*=-1;

            tr.description=_descrController.text;
            tr.cause=_causeController.text;
            tr.category=allCats.containsKey(dropdownValue)?allCats[dropdownValue]:null;

            if (isNew) day.addTransaction(tr);
            Navigator.of(context).pop();
          }
          else {
            (scaffold.currentState as ScaffoldState).showSnackBar(
                SnackBar(content: Text('All fields must be filled!')));
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropdown() {
    var lst=(gain?Data.incomeCategories.map((elem)=>elem.name):Data.expenseCategories.map((elem)=>elem.name));
    return lst.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

}