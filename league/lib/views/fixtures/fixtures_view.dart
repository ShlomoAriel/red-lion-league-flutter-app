import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/common/selection_list_widget.dart';
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
                  MainAppBar('ליגת האריה האדום', 'seasonState.season.name'),
                  SliverPadding(
                    padding: EdgeInsets.all(5),
                    sliver: SliverToBoxAdapter(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Column(children: [
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Container(
                                width: 80,
                                height: 35,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 80,
                                height: 35,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ]),
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
              MainAppBar('ליגת האריה האדום', seasonState.season.name),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Row(
                    children: [TeamSelectionButton(), SizedBox(width: 10), WeeksSelectionButton()],
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
        var teams = [Team(id: '-1', name: 'כל הקבוצות')];
        teams.addAll(seasonState.teamsMap.values);
        return Container(
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
            child: Card(
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                  padding: EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(seasonState.weeksTeam?.name ?? 'קבוצה',
                          style: Theme.of(context).textTheme.button),
                      Container(child: Icon(Icons.arrow_drop_down)),
                    ],
                  )),
            ),
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
        var weeks = [
          Week(id: '-1', name: 'כל המחזורים', seasonId: int.parse(state.currentSeason.id))
        ];
        weeks.addAll(seasonState.weeks.toList());
        return Container(
          alignment: Alignment.centerRight,
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
            child: Card(
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                  padding: EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(seasonState.weeksWeek?.name ?? 'מחזור',
                          style: Theme.of(context).textTheme.button),
                      Container(child: Icon(Icons.arrow_drop_down)),
                    ],
                  )),
            ),
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
      padding: EdgeInsets.only(top: 5),
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
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              Container(
                  width: 80,
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
                  width: 80,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(match.awayName, style: Theme.of(context).textTheme.bodyText1)
                  ])),
            ],
          );
        }));
  }
}

class WeeksSelectionButton extends StatelessWidget {
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
        var weeks = [
          Week(id: '-1', name: 'כל המחזורים', seasonId: int.parse(state.currentSeason.id))
        ];
        weeks.addAll(seasonState.weeks.toList());
        return Container(
            alignment: Alignment.centerRight,
            child: RawMaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 0),
              onPressed: () {
                Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                  child: showBottomSheetSelection(context, weeks, (Week value) {
                    return Text(value.name, style: Theme.of(context).textTheme.button);
                  }, (value) {
                    BlocProvider.of<LeagueCubit>(context).setWeeksWeek(value);
                  }, (Week week, text) {
                    return week.name.contains(text);
                  }),
                );
              },
              fillColor: Colors.white,
              elevation: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(seasonState.weeksWeek?.name ?? 'מחזור',
                      style: Theme.of(context).textTheme.button),
                  Container(child: Icon(Icons.arrow_drop_down)),
                ],
              ),
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ));
      }
    });
  }
}

class TeamSelectionButton extends StatelessWidget {
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
        var teams = [Team(id: '-1', name: 'כל הקבוצות')];
        teams.addAll(seasonState.teamsMap.values);
        return Container(
            alignment: Alignment.centerRight,
            child: RawMaterialButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                  child: showBottomSheetSelection(context, teams, (Team value) {
                    return Text(value.name, style: Theme.of(context).textTheme.button);
                  }, (value) {
                    BlocProvider.of<LeagueCubit>(context).setWeeksTeam(value);
                  }, (Team team, text) {
                    return team.name.contains(text);
                  }),
                );
              },
              fillColor: Colors.white,
              elevation: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(seasonState.weeksTeam?.name ?? 'קבוצה',
                      style: Theme.of(context).textTheme.button),
                  Container(child: Icon(Icons.arrow_drop_down)),
                ],
              ),
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ));
      }
    });
  }
}

showBottomSheetSelection(context, items, cellText, callback, filterFunction) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.3,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0), topRight: const Radius.circular(15.0))),
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: SelectionListWidget(
                  cellText: cellText,
                  items: items,
                  callback: callback,
                  filterFunction: filterFunction)),
        );
      });
}
