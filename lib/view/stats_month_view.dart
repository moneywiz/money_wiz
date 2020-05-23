import 'package:fl_chart/fl_chart.dart';
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
          SizedBox(
            height: 16,
          ),
          DefaultTabController(
            length: 2,
            child: SizedBox(
              height: 400.0,
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
                            child: StatsBarChart(
                                month: Data.months[4],
                                func: (Day d) => d.negative.abs(),
                                barColor: const Color(0xffff5182)
                            ),
                        ),
                        Container(
                            child: StatsBarChart(
                                month: Data.months[4],
                                func: (Day d) => d.positive,
                                barColor: const Color(0xff53fdd7)
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsBarChart extends StatefulWidget {
  final Month month;
  final Function func;
  final Color barColor;

  StatsBarChart({
    this.month,
    this.func,
    this.barColor
  });

  @override
  State<StatefulWidget> createState() => StateBarChartState(month, func, barColor);
}

class StateBarChartState extends State<StatsBarChart> {
  final double width = 7;

  final Month month;
  final Function func;
  final Color barColor;
  double max = 0;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedIndex;

  @override
  StateBarChartState(this.month, this.func, this.barColor);

  @override
  void initState() {
    super.initState();

    final List<BarChartGroupData> items = List();

    for (Day d in month.days) {
      items.add(makeGroupData(items.length, func(d)));
      max = func(d) > max ? func(d) : max;
    }

      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: (max / 25.0).ceil() * 25.0,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            tooltipPadding: EdgeInsets.all(6),
                            tooltipBottomMargin: 6,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                  "Day " + (group.x.toInt() + 1).toString() + '\n' + (rod.y - 1).toStringAsFixed(2) + "€", TextStyle(color: Colors.white));
                            }),
                        touchCallback: (barTouchResponse) {
                          setState(() {
                            if (barTouchResponse.spot != null &&
                                barTouchResponse.touchInput is! FlPanEnd &&
                                barTouchResponse.touchInput is! FlLongPressEnd) {
                              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
                            } else {
                              touchedIndex = -1;
                            }
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 8),
                          margin: 5,
                          getTitles: (double value) {
                            return (value.toInt() + 1).toString();
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontSize: 8),
                          margin: 5,
                          reservedSize: 18,
                          getTitles: (value) {
                            return value % 25 == 0 ? value.toInt().toString() + "€" : '';
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(barsSpace: 1, x: x, barRods: [
      BarChartRodData(
        y: y,
        color: barColor,
        width: width,
      )
    ]);
  }
}
