import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class StatsCategoryView extends StatefulWidget{
  Month month;

  @override
  StatsCategoryView(this.month);

  @override
  State<StatefulWidget> createState() => _StatsCategoryViewState();
}

class _StatsCategoryViewState extends State<StatsCategoryView> with AutomaticKeepAliveClientMixin{
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            labelColor: Color(0xFF000000),
            unselectedLabelColor: Color(0xFF000000),
            tabs: <Widget>[
              Tab(
                text: "Expenses"
              ),
              Tab(
                text: "Income"
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                Container(
                  child: getPieChart(widget.month.ExpenseCategoryBalance)
                ),
                Container(
                  child: getPieChart(widget.month.IncomeCategoryBalance)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPieChart(List<MapEntry<Category, double>> categoryBalance) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 65,
                      sections: showingSections(categoryBalance)),
                ),
              ),
            ),
            Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getIndicators(categoryBalance)
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<MapEntry<Category, double>> categoryBalance) {
    return List.generate(categoryBalance.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = (touchedIndex == -1 || touchedIndex == null || isTouched) ? (isTouched ? 17 : 11) : 0;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: categoryBalance[i].key.color,
        value: categoryBalance[i].value,
        title: categoryBalance[i].value.toStringAsFixed(2) + '€',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }

  List<Widget> getIndicators(List<MapEntry<Category, double>> categoryBalance) {
    List<Widget> res = List();
    for(MapEntry<Category, double> entry in categoryBalance) {
      res.addAll([
        Indicator(
          color: entry.key.color,
          text: entry.key.name,
          isSquare: true,
        ),
        SizedBox(
          height: 4,
        )
      ]);
    }
    res.add(
      SizedBox(
        height: 18,
      ),
    );
    return res;
  }

  @override
  bool get wantKeepAlive => true;

}
