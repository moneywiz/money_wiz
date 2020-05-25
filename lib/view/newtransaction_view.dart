import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
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

  Day day;
  Transaction tr;
  bool isNew;

  bool gain;
  DateTime formDateTime;
  String dropdownValue;

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
      _valueController.text="${tr.value}";
      _causeController.text=tr.cause;
      _descrController.text=tr.description;
      dropdownValue=tr.category.name;
    }
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
      appBar: AppBar(
        title: Text("New Transaction"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Transaction's Time"),
          RaisedButton(
            child: Text("${tr.time.hour}:${tr.time.minute}", style: TextStyle(fontSize: 32)),
            onPressed: () async {
              TimeOfDay t=await showTimePicker(context: context, initialTime: TimeOfDay.now());
              setState(() {
                tr.time??=t;
              });
            },
          ),
          Text("Value"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                color: gain ? Colors.green : Colors.red,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      gain = ! gain;
                    });
                  },
                  color: Colors.white,
                  icon: Icon(gain ? Icons.add : Icons.remove),

                )
              ),
              SizedBox(
                width: 300,
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
            ],
          ),
          Text("Cause"),
          TextField(
            controller: _causeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Cause',
            ),
          ),
          Text("Description"),
          TextField(
            controller: _descrController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),

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
            items: (gain?Data.incomeCategories.map((elem)=>elem.name):Data.expenseCategories.map((elem)=>elem.name))
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
                .toList(),
          ),

          RaisedButton(
            color: Colors.lightBlue,
            onPressed: () {
              if (_validValue && _valueController.text!="") {
                tr.value = double.tryParse(_valueController.text);
                if (!gain) tr.value*=-1;

                tr.description=_descrController.text;
                tr.cause=_causeController.text;

                if (isNew) day.addTransaction(tr);
                Navigator.of(context).pop();
              }
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

}


