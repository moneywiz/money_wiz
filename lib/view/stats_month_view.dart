import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneywiz/src/category.dart';
import 'package:moneywiz/src/day.dart';
import 'package:moneywiz/src/month.dart';
import 'package:moneywiz/src/data.dart';

class StatsMonthView extends StatefulWidget {
  Month month;

  @override
  StatsMonthView(this.month);

  @override
  State<StatefulWidget> createState() => _StatsMonthViewState();
}

class _StatsMonthViewState extends State<StatsMonthView> with AutomaticKeepAliveClientMixin {
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
                  child: StatsBarChart(
                    month: widget.month,
                    pos: false,
                    func: (Day d, {Category category}) => d.getNegative(category: category).abs(),
                    barColor: const Color(0xffff5182),
                    categories: Data.expenseCategories
                  ),
                ),
                Container(
                  child: StatsBarChart(
                    month: widget.month,
                    pos: true,
                    func: (Day d, {Category category}) => d.getPositive(category: category),
                    barColor: const Color(0xff53fdd7),
                    categories: Data.incomeCategories
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}

class StatsBarChart extends StatefulWidget {
  final Month month;
  final Function func;
  final Color barColor;
  final bool pos;
  List<Category> categories;

  static final Category _all = Category('All', null, null);

  StatsBarChart({
    this.month,
    this.pos,
    this.func,
    this.barColor,
    categories
  }) {
    this.categories = List.from(categories);

    if (!(this.categories.contains(_all))) this.categories.insert(0, _all);

  }

  @override
  State<StatefulWidget> createState() => StateBarChartState();
}

class StateBarChartState extends State<StatsBarChart> with AutomaticKeepAliveClientMixin {
  final double width = 7;

  Category dropdownValue = StatsBarChart._all;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  double max;
  int touchedIndex;

  void initData() {
    final List<BarChartGroupData> items = List();

    Category cat = dropdownValue != StatsBarChart._all ? dropdownValue : null;

    for (Day d in widget.month.days) {
      items.add(makeGroupData(items.length, widget.func(d, category: cat)));
    }

    max = widget.pos ? Data.account.maxPos : Data.account.maxNeg;

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    initData();
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
                      maxY: max,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            tooltipPadding: EdgeInsets.all(6),
                            tooltipBottomMargin: 6,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              if (rod.y == 0) return null;
                              return BarTooltipItem(
                                  "Day " + (group.x.toInt() + 1).toString() + '\n' + (rod.y - 1).toStringAsFixed(2) + "€", TextStyle(color: Colors.white)
                              );
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
                              fontSize: 8.2),
                          margin: 5,
                          getTitles: (double value) {
                            return (value.toInt() + 1).toString();
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontSize: 11),
                          margin: 8,
                          reservedSize: 24,
                          getTitles: (value) {
                            return value % (max > 600 ? (max > 1500 ? 100 : 50) : 25) == 0 ? value.toInt().toString() + "€" : '';
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: (max > 600 ? (max > 1500 ? 100 : 50) : 25),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xffe7e8ec),
                          strokeWidth: 1,
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
              Padding(
                padding: EdgeInsets.fromLTRB(92, 20, 100, 0),
                child: Text(
                  "Category",
                  style: TextStyle(fontSize: 12),
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: DropdownButton<Category>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: Icon(Icons.expand_more),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.black
                  ),
                  onChanged: (Category newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: getCategories()
                      .map<DropdownMenuItem<Category>>((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  })
                      .toList(),
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

  List<Category> getCategories() {
    List<Category> res = List.from(widget.categories);
    res.sort((Category a, Category b) => a.name.compareTo(b.name));
    return res;
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(barsSpace: 1, x: x, barRods: [
      BarChartRodData(
        y: y,
        color: widget.barColor,
        width: width,
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
