import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';


class NewTransaction extends StatefulWidget{
  final Day day;

  NewTransaction(this.day);

  @override
  State<StatefulWidget> createState() => _NewTransactionState(day);
}

class _NewTransactionState extends State<NewTransaction> {

  Day day;
  Transaction tr;

  bool gain;
  DateTime formDateTime;
  String dropdownValue;

  TextEditingController _valueController;
  bool _validValue;

  _NewTransactionState(this.day){
    this.gain = false;
    tr=Transaction(day,0,"Test",false);
    _valueController=TextEditingController();
    _validValue=true;
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
          Text("Teste Wednesday 20th May 2020"),
          Text("Transaction's Time"),
          RaisedButton(
            child: Text("${tr.time.hour}:${tr.time.minute}"),
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
            children: <Widget>[
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Value',
                    errorText: _validValue?"":"Must be a number"
                  ),
                  controller: _valueController,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    this.gain = ! this.gain;
                  });
                },
                color: this.gain ? Colors.green : Colors.red,
                child: Text("€"),
              ),
            ],
          ),
          Text("Description"),
          TextField(
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
            items: <String>['Restauração', 'Transportes', 'Saude', 'Educação']
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
                day.addTransaction(tr);
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


