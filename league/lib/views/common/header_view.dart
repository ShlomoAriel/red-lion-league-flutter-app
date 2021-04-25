import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
                    placeholder: AssetImage('assets/images/shield-placeholder.png'),
                    image: AssetImage('assets/images/LOGO CLEAN BACKGROUND.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Text('ליגת האריה האדום',
                    style: Theme.of(context).textTheme.headline6.apply(color: Colors.white)),
                SeasonDropDown(),
              ],
            ),
          ),
        ],
      )),
      decoration: new BoxDecoration(
        color: Color(0xffDD294D),
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
      backgroundColor: Color(0xffDD294D),
      // title: MyAppBar(barTitle),
      pinned: true,
      expandedHeight: 160.0,
      flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        var top = constraints.biggest.height;
        return FlexibleSpaceBar(
            title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: top > 104 ? 0.0 : 1.0,
                // opacity: 1,
                child: Text(
                  top > 104 ? "" : 'ליגת האריה האדום',
                  style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
                )),
            background: MyFlexiableAppBar(expandedBarTitle));
      }),
      // flexibleSpace: FlexibleSpaceBar(
      //   stretchModes: [
      //     StretchMode.zoomBackground,
      //     StretchMode.blurBackground,
      //     StretchMode.fadeTitle,
      //   ],
      //   background: MyFlexiableAppBar(expandedBarTitle),
      // ),
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
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.button.apply(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeasonDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      if (state == null || state.seasons == null || state.currentSeason == null) {
        return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Shimmer.fromColors(
                baseColor: Colors.grey[400],
                highlightColor: Colors.grey[100],
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 10,
                    color: Colors.grey,
                  ),
                ])));
      } else {
        return Container(
          child: PopupMenuButton<Season>(
            itemBuilder: (BuildContext context) {
              return state.seasons.map((value) {
                return new PopupMenuItem<Season>(
                  value: value,
                  child: new Text(value?.name ?? 'NA', style: Theme.of(context).textTheme.button),
                );
              }).toList();
            },
            initialValue: state.currentSeason,
            onSelected: (value) {
              print(value);
              BlocProvider.of<LeagueCubit>(context).setSeason(value);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.only(left: 30, top: 2, bottom: 7, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        // margin: EdgeInsets.only(left: 0),
                        child: Icon(Icons.arrow_drop_down, color: Colors.white70)),
                    Text(state.currentSeason.name,
                        style: Theme.of(context).textTheme.button.apply(color: Colors.white70)),
                  ],
                )),
            elevation: 16,
          ),
        );
      }
    });
  }
}
