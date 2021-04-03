import 'package:flutter/material.dart';

class TableHeaderColumnView extends StatelessWidget {
  final double width;
  final int index;
  final String label;
  const TableHeaderColumnView({Key key, this.width, this.index, this.label})
      : super(key: key);

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

class TableHeader extends StatelessWidget {
  final List<TableHeaderColumnView> tableRowColumns;

  const TableHeader({Key key, this.tableRowColumns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: tableRowColumns,
          // children: [
          //   Container(
          //     alignment: Alignment.center,
          //     width: 50,
          //     child: Text(
          //       '#',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     width: 145,
          //     child: Text(
          //       'Club',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     alignment: Alignment.center,
          //     width: 30,
          //     child: Text(
          //       'PL',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     alignment: Alignment.center,
          //     width: 30,
          //     child: Text(
          //       'W',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     alignment: Alignment.center,
          //     width: 30,
          //     child: Text(
          //       'D',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     alignment: Alignment.center,
          //     width: 30,
          //     child: Text(
          //       'L',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     alignment: Alignment.center,
          //     width: 30,
          //     child: Text(
          //       'GD',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          //   Container(
          //     alignment: Alignment.center,
          //     width: 30,
          //     child: Text(
          //       'Pts',
          //       style: Theme.of(context).textTheme.overline,
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }
}
