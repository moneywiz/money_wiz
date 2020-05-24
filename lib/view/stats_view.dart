import 'package:flutter/material.dart';
import 'stats_month_view.dart';
import 'stats_category_view.dart';
import 'package:moneywiz/src/data.dart';
import 'package:moneywiz/src/month.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';

class StatsView extends StatefulWidget {
  int month;

  @override
  StatsView(this.month);

  @override
  State<StatefulWidget> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
            bottom: TabBar(
              isScrollable: false,
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                  icon: Icon(choice.icon)
                );
              }).toList(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                    children: [
                      StatsMonthView(Data.months[widget.month]),
                      StatsCategoryView(Data.months[widget.month])
                    ]
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: CalendarHeader(
                  showHeader: true,
                  headerTitle: Month.months[Data.months[widget.month].month - 1] + " " +  Data.months[widget.month].year.toString(),
                  onLeftButtonPressed: (){
                    if(widget.month - 1 >= 0) {
                      widget.month -= 1;
                      this.setState(() {});
                    }
                  },
                  onRightButtonPressed: (){
                    if(Data.months.length > widget.month + 1) {
                      widget.month += 1;
                      this.setState(() {});
                    }
                  },
                  showHeaderButtons: true,
                  isTitleTouchable: false,
                  onHeaderTitlePressed: null
                )
              )
            ]
          ),
        ),
    );
  }
}

class Choice {
  Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

List<Choice> choices = <Choice>[
  Choice(title: 'Days', icon: Icons.insert_chart),
  Choice(title: 'Categories', icon: Icons.pie_chart),
];