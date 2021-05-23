import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:league/views/fixtures/fixtures_view.dart';
import 'package:shimmer/shimmer.dart';

class MainFlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 0.0;
  final title;

  const MainFlexiableAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
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
                    width: 80,
                    height: 80,
                    placeholder: AssetImage('assets/images/shield-placeholder.png'),
                    image: AssetImage('assets/images/LOGO CLEAN BACKGROUND.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Text('ליגת האריה האדום',
                    style: Theme.of(context).textTheme.headline6.apply(color: Colors.white)),
                SeasonSelectionButton(textColor: Colors.white),
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

class MainAppBar extends StatelessWidget {
  final barTitle;
  final expandedBarTitle;

  const MainAppBar(this.barTitle, this.expandedBarTitle);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color(0xffDD294D),
      pinned: true,
      expandedHeight: 170.0,
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
            background: MainFlexiableAppBar(expandedBarTitle));
      }),
    );
  }
}

class SeasonSelectionButton extends StatelessWidget {
  final Color textColor;

  const SeasonSelectionButton({Key key, this.textColor}) : super(key: key);
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
        var items = state.seasons;
        return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.only(left: 30, top: 2, bottom: 7, right: 12),
            child: GestureDetector(
              onTap: () {
                showBottomSheetSelection(context, items, (Season value) {
                  return Text(value.name);
                }, (value) {
                  BlocProvider.of<LeagueCubit>(context).setSeason(value);
                }, (Season week, text) {
                  return week.name.contains(text);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(child: Icon(Icons.arrow_drop_down, color: textColor)),
                  Text(state.currentSeason.name,
                      style: Theme.of(context).textTheme.button.apply(color: textColor)),
                ],
              ),
            ));
      }
    });
  }
}

class SeasonDropDown extends StatelessWidget {
  final Color textColor;

  const SeasonDropDown({Key key, this.textColor}) : super(key: key);

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
                  child: new Text(value?.name ?? 'NA',
                      style: Theme.of(context).textTheme.button.apply(color: Colors.black)),
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
                    Container(child: Icon(Icons.arrow_drop_down, color: textColor)),
                    Text(state.currentSeason.name,
                        style: Theme.of(context).textTheme.button.apply(color: textColor)),
                  ],
                )),
            elevation: 16,
          ),
        );
      }
    });
  }
}

class TeamAppBar extends StatelessWidget {
  final Team team;

  const TeamAppBar(this.team);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.grey[200],
      pinned: true,
      expandedHeight: 170.0,
      flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        var top = constraints.biggest.height;
        return FlexibleSpaceBar(
            title: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: top > 104 ? 0.0 : 1.0,
                child: Text(
                  top > 104 ? "" : team.name,
                  style: Theme.of(context).textTheme.headline6.apply(color: Colors.black),
                )),
            background: TeamHeader(team));
      }),
    );
  }
}

class TeamHeader extends StatelessWidget {
  final double appBarHeight = 0.0;
  final Team team;

  const TeamHeader(this.team);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
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
                    width: 80,
                    height: 80,
                    placeholder: AssetImage('assets/images/shield-placeholder.png'),
                    image: AssetImage('assets/images/logos/' + team.id + '.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Text(team.name,
                    style: Theme.of(context).textTheme.headline6.apply(color: Colors.black)),
                SeasonSelectionButton(textColor: Colors.black),
              ],
            ),
          ),
        ],
      )),
      decoration: new BoxDecoration(color: Colors.grey[200]),
    );
  }
}
