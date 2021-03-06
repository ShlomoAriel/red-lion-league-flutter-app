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

class TableHeaderRowView extends StatelessWidget {
  final columnList;
  final columnWidth;

  const TableHeaderRowView({Key key, this.columnList, this.columnWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                Container(
                  width: 20,
                  child: Text(
                    '#',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 70,
                  child: Text(
                    '??????????',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            Row(children: [
              for (var item in columnList)
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: columnWidth,
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
            ]),
          ],
        ),
      ],
    );
  }
}
