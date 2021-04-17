import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:league/views/fixtures/fixtures_view.dart';
import 'package:league/views/stats/stats_view.dart';
import 'package:league/views/main/main_view.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: Directionality(textDirection: TextDirection.rtl, child: MainView()),
          icon: Icon(Icons.table_chart),
          title: "Table",
        ),
        TabNavigationItem(
          page: Directionality(textDirection: TextDirection.rtl, child: FixturesView()),
          icon: Icon(Icons.calendar_today),
          title: "Fixtures",
        ),
        TabNavigationItem(
          page: Directionality(textDirection: TextDirection.rtl, child: ScorersView()),
          icon: Icon(Icons.leaderboard),
          title: "Stats",
        ),
      ];
}
