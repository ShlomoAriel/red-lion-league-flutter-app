import 'package:flutter/material.dart';
import 'package:league/navigation/app_tab_page.dart';
import 'package:league/views/clientLists/client_members_view.dart';
import 'package:league/views/catalog/catalog_view.dart';
import 'package:league/views/catalog/product_details_view.dart';
import 'package:league/views/catalog/product_list_view.dart';
import 'package:league/views/catalog/collection_list_view.dart';
import 'package:league/views/fixtures/match_view.dart';
import 'package:league/views/main/team_details_view.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/catalog':
        return MaterialPageRoute(
          builder: (_) => CatalogView(),
        );
      case '/productList':
        return MaterialPageRoute(
          builder: (_) => ProductListView(),
        );
      case '/productDetails':
        return MaterialPageRoute(
          builder: (_) => ProductDetailsView(),
        );
      case '/collectionList':
        return MaterialPageRoute(
          builder: (_) => CollectionListView(),
        );
      case '/':
        return MaterialPageRoute(
          builder: (_) => Directionality(textDirection: TextDirection.rtl, child: TabsPage()),
        );
      case '/clientListMembers':
        return MaterialPageRoute(
          builder: (_) => ClientMembersView(),
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
