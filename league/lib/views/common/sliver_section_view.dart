import 'package:flutter/material.dart';

class SliverSectionView extends StatelessWidget {
  final title;

  const SliverSectionView({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}
