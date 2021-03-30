import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:league/views/catalog/catalog_view.dart';
import 'package:league/views/clientLists/main_client_list_view.dart';
import 'package:league/views/table/table_view.dart';

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
          page: TableView(),
          icon: Icon(Icons.list),
          title: "Table",
        ),
        TabNavigationItem(
          page: CatalogView(),
          icon: Icon(Icons.shopping_basket),
          title: "Catalog",
        ),
        TabNavigationItem(
          page: ClientListView(),
          icon: Icon(Icons.person),
          title: "Clients",
        ),
      ];
}
