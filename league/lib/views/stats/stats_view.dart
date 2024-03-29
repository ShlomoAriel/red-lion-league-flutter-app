import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/common/sliver_section_view.dart';
import 'package:league/views/common/table_header_view.dart';
import 'package:league/views/main/shimmer_placeholders.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScorersView extends StatelessWidget {
  final scrollController = ScrollController();
  @override
  Widget build(Object context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      var seasonState = state.store![state.currentSeason?.id ?? null];
      if (kIsWeb) {
        return Text('Is web');
      }
      return Container(
        color: Colors.grey[200],
        child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              MainAppBar('ליגת האריה האדום', seasonState?.season?.name ?? 'ss'),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  final cubit = BlocProvider.of<LeagueCubit>(context);
                  await cubit.createAndSetSeason(state.currentSeason!);
                },
              ),
              SliverSectionView(title: 'כללי'),
              buildStats(seasonState),
              SliverSectionView(title: 'כובשים'),
              buildScorerSliver(seasonState),
              SliverSectionView(title: 'ממוצע כיבושים'),
              buildGoalsScoredTable(seasonState),
              SliverSectionView(title: 'ממוצע ספיגות'),
              buildGoalsConcededTable(seasonState),
              SliverPadding(padding: EdgeInsets.only(bottom: 10))
            ]),
      );
    });
  }

  Widget buildStats(SeasonState? seasonState) {
    if (seasonState == null || seasonState.scorers == null) {
      return SliverGridPlaceholder(count: 6);
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final stat = seasonState.stats![index];
              return Card(
                elevation: 15,
                shadowColor: Colors.black26,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(seasonState.teamsMap![stat.teamId]!.name!,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .apply(color: Colors.black, fontFamily: 'OpenSansHebrew-Bold')),
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: CachedNetworkImage(
                          height: (MediaQuery.of(context).size.width / 2.8) -
                              (MediaQuery.of(context).size.width / 10),
                          imageUrl: seasonState.teamsMap![stat.teamId]!.logoURL ?? '',
                          placeholder: (context, url) =>
                              new Image.asset('assets/images/shield-placeholder.png'),
                          errorWidget: (context, url, error) =>
                              new Image.asset('assets/images/shield-placeholder.png'),
                        ),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(5),
                          height: 80,
                          color: Color(0xff2F0238),
                          child: Column(
                            children: [
                              Text(stat.value.toString(),
                                  style: Theme.of(context).textTheme.headline4!.apply(
                                      color: Colors.white, fontFamily: 'OpenSansHebrew-Bold')),
                              Text(stat.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .apply(color: Colors.white)),
                            ],
                          ),
                        ))
                  ],
                ),
              );
            },
            childCount: seasonState.stats!.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.86,
          ),
        ),
      );
    }
  }

  Widget buildScorerSliver(SeasonState? seasonState) {
    if (seasonState == null || seasonState.scorers == null) {
      return SliverListPlaceholder(count: 10);
    } else {
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(children: [
            TableHeaderRowView(columnList: ['שערים'], columnWidth: 35.0),
            ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              physics: const NeverScrollableScrollPhysics(),
              controller: scrollController,
              shrinkWrap: true,
              itemCount: seasonState.scorers!.length,
              itemBuilder: (context, index) {
                final scorer = seasonState.scorers![index];
                final tableRow = TableRow((index + 1).toString(), scorer.teamId, scorer.name,
                    [TableRowColumn(35, scorer.goals.toString())]);
                return StatsRowView(tableRow: tableRow);
              },
            )
          ]),
        ),
      );
    }
  }

  Widget buildGoalsScoredTable(SeasonState? seasonState) {
    if (seasonState == null || seasonState.standingsResponse == null) {
      return SliverListPlaceholder(count: 10);
    } else {
      var sortedList = seasonState.standingsResponse!.list!.toList();
      sortedList.sort((a, b) => b.goalsFortAverage.compareTo(a.goalsFortAverage));
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(children: [
            TableHeaderRowView(columnList: ['משחקים', 'שערי זכות', 'ממוצע'], columnWidth: 55.0),
            ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              physics: const NeverScrollableScrollPhysics(),
              controller: scrollController,
              shrinkWrap: true,
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                final stat = sortedList[index];
                final tableRow = TableRow((index + 1).toString(), stat.id, stat.name, [
                  TableRowColumn(55, stat.games.toString()),
                  TableRowColumn(55, stat.goalsFor.toString()),
                  TableRowColumn(55, stat.goalsFortAverage.toStringAsFixed(2)),
                ]);
                return StatsRowView(tableRow: tableRow);
              },
            )
          ]),
        ),
      );
    }
  }

  Widget buildGoalsConcededTable(SeasonState? seasonState) {
    if (seasonState == null || seasonState.standingsResponse == null) {
      return SliverListPlaceholder(count: 10);
    } else {
      var sortedList = seasonState.standingsResponse!.list!.toList();
      sortedList.sort((a, b) => a.goalsAgainstAverage.compareTo(b.goalsAgainstAverage));
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(children: [
            TableHeaderRowView(columnList: ['משחקים', 'ספיגות', 'ממוצע'], columnWidth: 55.0),
            ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              physics: const NeverScrollableScrollPhysics(),
              controller: scrollController,
              shrinkWrap: true,
              itemCount: sortedList.length,
              itemBuilder: (context, index) {
                final stat = sortedList[index];
                final tableRow = TableRow((index + 1).toString(), stat.id, stat.name, [
                  TableRowColumn(55, stat.games.toString()),
                  TableRowColumn(55, stat.goalsAgainst.toString()),
                  TableRowColumn(55, stat.goalsAgainstAverage.toStringAsFixed(2)),
                ]);
                return StatsRowView(tableRow: tableRow);
              },
            )
          ]),
        ),
      );
    }
  }
}

class TableRowColumn {
  final double width;
  final String label;

  TableRowColumn(this.width, this.label);
}

class TableRow {
  final String position;
  final String? teamId;
  final String? title;
  final List<TableRowColumn> trailingColumns;
  late List<Widget> trailingColumnsView;

  TableRow(this.position, this.teamId, this.title, this.trailingColumns) {
    this.trailingColumnsView = [];
    for (var item in this.trailingColumns) {
      this.trailingColumnsView.add(Row(children: [
            Container(
              width: item.width,
              alignment: Alignment.center,
              child: Text(
                item.label,
              ),
            ),
            SizedBox(width: 10)
          ]));
    }
  }
}

class StatsRowView extends StatelessWidget {
  final TableRow? tableRow;

  const StatsRowView({Key? key, this.tableRow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child: Container(
      child: BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
        var store = state.store![state.currentSeason!.id];
        var logoURL = store?.teamsMap![tableRow!.teamId]?.logoURL ?? '';
        return Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      width: 20,
                      child: Text(tableRow!.position, style: Theme.of(context).textTheme.bodyText1),
                    ),
                    CachedNetworkImage(
                      width: 30,
                      height: 30,
                      imageUrl: logoURL,
                      placeholder: (context, url) =>
                          new Image.asset('assets/images/shield-placeholder.png'),
                      errorWidget: (context, url, error) =>
                          new Image.asset('assets/images/shield-placeholder.png'),
                    ),
                    SizedBox(width: 8),
                    Text(
                      tableRow!.title!,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(children: tableRow!.trailingColumnsView),
              ],
            ),
            SizedBox(height: 10)
          ],
        );
      }),
    ));
  }
}
