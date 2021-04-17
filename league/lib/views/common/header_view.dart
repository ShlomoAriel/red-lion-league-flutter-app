import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      title: MyAppBar(barTitle),
      pinned: false,
      expandedHeight: 160.0,
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
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
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
      if (state == null ||
          state.seasons == null ||
          state.currentSeason == null) {
        return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      } else {
        return Container(
          child: PopupMenuButton<Season>(
            itemBuilder: (BuildContext context) {
              return state.seasons.map((value) {
                return new PopupMenuItem<Season>(
                  value: value,
                  child: new Text(value?.name ?? 'NA'),
                );
              }).toList();
            },
            initialValue: state.currentSeason,
            onSelected: (value) {
              print(value);
              BlocProvider.of<LeagueCubit>(context).setSeason(value);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding:
                    EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_drop_down)),
                    Text(state.currentSeason.name,
                        style: Theme.of(context).textTheme.headline6),
                  ],
                )),
            elevation: 16,
          ),
        );
      }
    });
  }
}
