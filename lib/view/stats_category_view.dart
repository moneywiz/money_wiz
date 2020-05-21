import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/data.dart';

class StatsCategoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatsCategoryViewState();
}

class _StatsCategoryViewState extends State<StatsCategoryView> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(child: Text("By Day")),
              RaisedButton(child: Text("By Category")),
            ],
          ),
          Container(
            width: deviceWidth*0.7,
            height: deviceHeight*0.3,
            child: PieChart.build(PieChart._getData(Data.months[4]), animate: true),
          )
        ],
      ),
    );
  }
}

class PieChart {

  static Widget build(seriesList, {animate}) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  static List<charts.Series<MapEntry<String, double>, String>> _getData(Month month) {
    return [
      new charts.Series<MapEntry<String, double>, String>(
        id: 'Sales',
        domainFn: (MapEntry<String, double> entry, _) => entry.key,
        measureFn: (MapEntry<String, double> entry, _) => entry.value,
        data: month.CategoryBalance.entries.toList(),
        labelAccessorFn: (MapEntry<String, double> row, _) => '${row.key}: ${row.value}',
      )
    ];
  }
}
