import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/main/shimmer_placeholders.dart';
import 'package:shimmer/shimmer.dart';

class FixturesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
          if (state == null ||
              state.isLoading ||
              state.store == null ||
              state.store[state.currentSeason.id] == null) {
            return Container(
                color: Colors.grey[200],
                child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
                  MySliverAppBar('ליגת האריה האדום', 'seasonState.season.name'),
                  SliverPadding(
                    padding: EdgeInsets.all(5),
                    sliver: SliverToBoxAdapter(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                              height: 30,
                            ),
                            Container(
                              width: 100,
                              height: 25,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 100,
                              height: 25,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FixturesPlaceholder(
                    count: 2,
                    height: 40.0,
                  ),
                ]));
          } else {
            var seasonState = state.store[state.currentSeason.id];
            return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
              MySliverAppBar('ליגת האריה האדום', seasonState.season.name),
              SliverToBoxAdapter(
                child: Container(
                  child: Row(
                    children: [TeamDropDown(), WeeksDropDown()],
                  ),
                ),
              ),
              FixturesSliverView(weeks: seasonState.filteredWeeks)
            ]);
          }
        }));
  }
}

class TeamDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      if (state == null || state.seasons == null || state.currentSeason == null) {
        return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      } else {
        var seasonState = state.store[state.currentSeason.id];
        var teams = seasonState.teamsMap.values;
        return Container(
          margin: EdgeInsets.only(top: 10, bottom: 0, right: 5, left: 5),
          child: PopupMenuButton<Team>(
            itemBuilder: (BuildContext context) {
              return teams.map((value) {
                return new PopupMenuItem<Team>(
                  value: value,
                  child: new Text(value?.name ?? 'NA', style: Theme.of(context).textTheme.button),
                );
              }).toList();
            },
            initialValue: seasonState.weeksTeam,
            onSelected: (value) {
              print(value);
              BlocProvider.of<LeagueCubit>(context).setWeeksTeam(value);
            },
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                padding: EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(margin: EdgeInsets.only(left: 5), child: Icon(Icons.arrow_drop_down)),
                    Text(seasonState.weeksTeam?.name ?? 'קבוצה',
                        style: Theme.of(context).textTheme.button),
                  ],
                )),
            elevation: 16,
          ),
        );
      }
    });
  }
}

class WeeksDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      if (state == null || state.seasons == null || state.currentSeason == null) {
        return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      } else {
        var seasonState = state.store[state.currentSeason.id];
        var weeks = seasonState.weeks;
        return Container(
          margin: EdgeInsets.only(top: 10, bottom: 0, right: 5, left: 5),
          child: PopupMenuButton<Week>(
            itemBuilder: (BuildContext context) {
              return weeks.map((value) {
                return new PopupMenuItem<Week>(
                  value: value,
                  child: new Text(value?.name ?? 'NA', style: Theme.of(context).textTheme.button),
                );
              }).toList();
            },
            initialValue: seasonState.weeksWeek,
            onSelected: (value) {
              print(value);
              BlocProvider.of<LeagueCubit>(context).setWeeksWeek(value);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                padding: EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(margin: EdgeInsets.only(left: 5), child: Icon(Icons.arrow_drop_down)),
                    Text(seasonState.weeksWeek?.name ?? 'מחזור',
                        style: Theme.of(context).textTheme.button),
                  ],
                )),
            elevation: 16,
          ),
        );
      }
    });
  }
}

class FixturesSliverView extends StatelessWidget {
  final List<Week> weeks;

  const FixturesSliverView({Key key, this.weeks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final week = weeks[index];
            return FixturesWeekView(week: week);
          },
          childCount: weeks.length,
        ),
      ),
    );
  }
}

class FixturesWeekView extends StatelessWidget {
  final Week week;

  const FixturesWeekView({Key key, this.week}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text('מחזור ' + week.name, style: Theme.of(context).textTheme.headline6)),
          ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: week.fixtures.keys.toList().length,
            itemBuilder: (context, index) {
              final keys = week.fixtures.keys.toList();
              final list = week.fixtures[keys[index]];
              return FixtureDayView(dateString: keys[index], matches: list);
            },
          )
        ],
      ),
    );
  }
}

class FixtureDayView extends StatelessWidget {
  final List<Match> matches;
  final String dateString;

  const FixtureDayView({Key key, this.matches, this.dateString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 20),
              child: Text(dateString, style: Theme.of(context).textTheme.subtitle2)),
          Container(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: matches.length,
              itemBuilder: (context, index) {
                return FixtureView(match: matches[index]);
              },
            ),
          )
        ]);
  }
}

class FixtureView extends StatelessWidget {
  final Match match;

  const FixtureView({Key key, this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              Container(
                  width: 100,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(match.homeName, style: Theme.of(context).textTheme.bodyText1)
                  ])),
              SizedBox(width: 10),
              FadeInImage(
                width: 30,
                height: 30,
                placeholder: AssetImage('assets/images/shield-placeholder.png'),
                image: AssetImage('assets/images/logos/' + match.homeId + '.png'),
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Text(match.played ? match.homeGoals.toString() : '',
                  style: Theme.of(context).textTheme.bodyText1),
              Text(match.played ? ' - ' : match.time, style: Theme.of(context).textTheme.bodyText1),
              Text(match.played ? match.awayGoals.toString() : '',
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(width: 10),
              FadeInImage(
                width: 30,
                height: 30,
                placeholder: AssetImage('assets/images/shield-placeholder.png'),
                image: AssetImage('assets/images/logos/' + match.awayId + '.png'),
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Container(
                  width: 100,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(match.awayName, style: Theme.of(context).textTheme.bodyText1)
                  ])),
            ],
          );
        }));
  }
}
