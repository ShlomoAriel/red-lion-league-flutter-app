import 'package:flutter/material.dart';

class MyFlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 66.0;
  final title;

  const MyFlexiableAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight + 30),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: FadeInImage(
                    width: 60,
                    height: 60,
                    placeholder:
                        AssetImage('assets/images/shield-placeholder.png'),
                    image:
                        AssetImage('assets/images/LOGO CLEAN BACKGROUND.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                    child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ))
              ],
            ),
          ),
        ],
      )),
      decoration: new BoxDecoration(
        color: Colors.red,
      ),
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  final barTitle;
  final expandedBarTitle;

  const MySliverAppBar(this.barTitle, this.expandedBarTitle);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: MyAppBar(barTitle),
      pinned: true,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [
          StretchMode.zoomBackground,
          // StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        background: MyFlexiableAppBar(expandedBarTitle),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final double barHeight = 66.0;
  final title;
  const MyAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Container(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Icon(Icons.shopping_basket),
          //   ),
          // ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          // Container(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Icon(Icons.shopping_basket),
          //   ),
          // ),
        ],
      ),
    );
  }
}
