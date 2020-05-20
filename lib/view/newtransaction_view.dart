import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/transaction.dart';
import 'package:flutter/cupertino.dart';


class NewTransaction extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {


  //maybe
  //variavel para mostrar o dia da semana
  Day day;
  //variavel para mostrar as horas da transação

  bool gain;
  DateTime formDateTime;
  String dropdownValue;


  _NewTransactionState(){
    this.day=Day(Month(2020,5),20);
    this.gain = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Transaction"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Teste Wednesday 20th May 2020"),
          Text("Transaction's Time"),
          Container(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime(2020, 5, 20),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  this.formDateTime = newDateTime;
                });
              },
            ),
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
                    ),
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
              print("horas: $formDateTime, ganho: $gain, categoria: $dropdownValue");
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

}


