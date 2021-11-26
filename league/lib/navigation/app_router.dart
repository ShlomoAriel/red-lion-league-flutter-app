import 'package:flutter/material.dart';
import 'package:league/navigation/app_tab_page.dart';
import 'package:league/views/fixtures/match_view.dart';
import 'package:league/views/main/team_details_view.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Directionality(textDirection: TextDirection.rtl, child: TabsPage()),
        );
      case '/teamDetails':
        return MaterialPageRoute(
          builder: (_) =>
              Directionality(textDirection: TextDirection.rtl, child: TeamDetailsView()),
        );
      case '/matchDetails':
        return MaterialPageRoute(
          builder: (_) => Directionality(textDirection: TextDirection.rtl, child: MatchView()),
        );
      default:
        return null;
    }
  }
}
