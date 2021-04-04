import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/views/common/sliver_section_view.dart';
import 'package:league/views/common/table_header_view.dart';

import '../header_view.dart';

class ScorersView extends StatelessWidget {
  final scrollController = ScrollController();
  @override
  Widget build(Object context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      var seasonState = state.store[state.currentSeason?.id ?? null];
      return Container(
        color: Colors.grey[200],
        child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              MySliverAppBar(
                  'ליגת האריה האדום', seasonState?.season?.name ?? 'ss'),
              SliverSectionView(title: 'כללי'),
              showStats(seasonState),
              SliverSectionView(title: 'כובשים'),
              TableHeader(
                tableRowColumns: [
                  TableHeaderColumnView(
                    index: 1,
                    width: 20,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 25,
                    label: '#',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 30,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 50,
                    label: 'שחקן',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 200,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 50,
                    label: 'שערים',
                  )
                ],
              ),
              showSliver(seasonState),
              SliverSectionView(title: 'ממוצע כיבושים'),
              TableHeader(
                tableRowColumns: [
                  TableHeaderColumnView(
                    index: 1,
                    width: 20,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 25,
                    label: '#',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 50,
                    label: 'קבוצה',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 80,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 60,
                    label: 'משחקים',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 5,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 60,
                    label: 'שערי זכות',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 5,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 80,
                    label: 'ממוצע',
                  )
                ],
              ),
              buildGoalsScoredTable(seasonState),
              SliverSectionView(title: 'ממוצע ספיגות'),
              TableHeader(
                tableRowColumns: [
                  TableHeaderColumnView(
                    index: 1,
                    width: 20,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 25,
                    label: '#',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 50,
                    label: 'קבוצה',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 80,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 60,
                    label: 'משחקים',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 5,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 60,
                    label: 'שערי חובה',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 5,
                    label: '',
                  ),
                  TableHeaderColumnView(
                    index: 1,
                    width: 80,
                    label: 'ממוצע',
                  )
                ],
              ),
              buildGoalsConcededTable(seasonState),
              SliverPadding(padding: EdgeInsets.only(bottom: 10))
            ]),
      );
    });
  }

  Widget showStats(SeasonState seasonState) {
    if (seasonState == null || seasonState.scorers == null) {
      return SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final stat = seasonState.stats[index];
              return Card(
                elevation: 15,
                shadowColor: Colors.black26,
                color: Colors.white, //(0xff44044B),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: FadeInImage(
                          width: 100,
                          height: 100,
                          placeholder: AssetImage(
                              'assets/images/shield-placeholder.png'),
                          image: AssetImage(
                              'assets/images/logos/' + stat.teamId + '.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(5),
                          height: 70,
                          color: Color(0xff2F0238),
                          child: Column(
                            children: [
                              Text(stat.value.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .apply(
                                          color: Color(0xffF62880),
                                          fontFamily: 'OpenSansHebrew-Bold')),
                              Text(stat.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .apply(
                                        color: Colors.white,
                                      )),
                            ],
                          ),
                        ))
                  ],
                ),
              );
            },
            childCount: seasonState.stats.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 0.92,
          ),
        ),
      );
    }
  }

  Widget showSliver(SeasonState seasonState) {
    if (seasonState == null || seasonState.scorers == null) {
      return SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else {
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: seasonState.scorers.length,
            itemBuilder: (context, index) {
              final scorer = seasonState.scorers[index];
              final tableRow = TableRow((index + 1).toString(), scorer.teamId,
                  scorer.name, [TableRowColumn(30, scorer.goals.toString())]);
              return StatsRowView(tableRow: tableRow);
            },
          ),
        ),
      );
    }
  }

  Widget buildGoalsScoredTable(SeasonState seasonState) {
    if (seasonState == null || seasonState.standingsResponse == null) {
      return SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else {
      var sortedList = seasonState.standingsResponse.list.toList();
      sortedList
          .sort((a, b) => b.goalsFortAverage.compareTo(a.goalsFortAverage));
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final stat = sortedList[index];
              final tableRow =
                  TableRow((index + 1).toString(), stat.id, stat.name, [
                TableRowColumn(40, stat.games.toString()),
                TableRowColumn(60, stat.goalsFor.toString()),
                TableRowColumn(50, stat.goalsFortAverage.toStringAsFixed(2)),
              ]);
              return StatsRowView(tableRow: tableRow);
            },
          ),
        ),
      );
    }
  }

  Widget buildGoalsConcededTable(SeasonState seasonState) {
    if (seasonState == null || seasonState.standingsResponse == null) {
      return SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else {
      var sortedList = seasonState.standingsResponse.list.toList();
      sortedList.sort(
          (a, b) => a.goalsAgainstAverage.compareTo(b.goalsAgainstAverage));
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final stat = sortedList[index];
              final tableRow =
                  TableRow((index + 1).toString(), stat.id, stat.name, [
                TableRowColumn(40, stat.games.toString()),
                TableRowColumn(60, stat.goalsAgainst.toString()),
                TableRowColumn(50, stat.goalsAgainstAverage.toStringAsFixed(2)),
              ]);
              return StatsRowView(tableRow: tableRow);
            },
          ),
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
  final String teamId;
  final String title;
  final List<TableRowColumn> trailingColumns;
  List<Widget> trailingColumnsView;

  TableRow(this.position, this.teamId, this.title, this.trailingColumns) {
    this.trailingColumnsView = new List<Widget>();
    for (var item in this.trailingColumns) {
      this.trailingColumnsView.add(Row(children: [
            Container(
              width: item.width,
              child: Text(item.label),
            ),
            SizedBox(width: 10)
          ]));
    }
  }
}

class StatsRowView extends StatelessWidget {
  final TableRow tableRow;

  const StatsRowView({Key key, this.tableRow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
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
                      child: Text(tableRow.position,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    FadeInImage(
                      width: 30,
                      height: 30,
                      placeholder:
                          AssetImage('assets/images/shield-placeholder.png'),
                      image: AssetImage(
                          'assets/images/logos/' + tableRow.teamId + '.png'),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text(
                      tableRow.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(children: tableRow.trailingColumnsView),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}