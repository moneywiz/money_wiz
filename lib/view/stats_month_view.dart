import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/data.dart';

class StatsMonthView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatsMonthViewState();
}

class _StatsMonthViewState extends State<StatsMonthView> {
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
              width: deviceWidth*0.9,
              height: deviceHeight*0.3,
              child: BarChart.build(BarChart._getData(Data.months[4]), animate: true),
          )
        ],
      ),
    );
  }
}

class BarChart {

  static Widget build(seriesList, {animate}) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30)),
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [new charts.SeriesLegend()]
    );
  }

  static List<charts.Series<Day, String>> _getData(Month month) {
    return [
      new charts.Series<Day, String>(
        id: 'Income',
        domainFn: (Day day, _) => day.day.toString(),
        measureFn: (Day day, _) => day.positive,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: month.days,
      ),
      new charts.Series<Day, String>(
        id: 'Expense',
        domainFn: (Day day, _) => day.day.toString(),
        measureFn: (Day day, _) => day.negative.abs(),
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: month.days,
      ),
    ];
  }
}
