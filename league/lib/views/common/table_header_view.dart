import 'package:flutter/material.dart';

class TableHeaderColumnView extends StatelessWidget {
  final double width;
  final String label;
  const TableHeaderColumnView({Key key, this.width, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      child: Text(
        label,
        style: Theme.of(context).textTheme.overline,
      ),
    );
  }
}

class SliverRow extends StatelessWidget {
  final List<TableHeaderColumnView> tableRowColumns;

  const SliverRow({Key key, this.tableRowColumns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: tableRowColumns,
        ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  final List<TableHeaderColumnView> tableRowColumns;

  const TableHeader({Key key, this.tableRowColumns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: tableRowColumns,
      ),
    );
  }
}
