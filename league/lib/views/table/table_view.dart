import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';

import 'fixtures_view.dart';

class TableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<LeagueCubit, LeagueState>(
        builder: (context, state) {
          if (state == null ||
              state.isLoading ||
              state.store == null ||
              state.store[state.currentSeason] == null) {
            return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(),
                ));
          } else {
            var seasonState = state.store[state.currentSeason];
            var stretchModes2 = [
              StretchMode.zoomBackground,
              // StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ];
            return Container(
              color: Colors.grey[200],
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 60,
                    stretch: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        seasonState.season.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      stretchModes: stretchModes2,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: DropdownButton<String>(
                      value: state.currentSeason,
                      items: state.seasons.map((value) {
                        return new DropdownMenuItem<String>(
                          value: value.id,
                          child: new Text(value.id),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        BlocProvider.of<LeagueCubit>(context).setSeason(value);
                      },
                    ),
                  ),
                  tableHeader(context),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final standing =
                            seasonState.standingsResponse.list[index];
                        return TableRowView(
                          callback: () {
                            BlocProvider.of<LeagueCubit>(context)
                                .setTeamSeasonPlayers(state.currentSeason,
                                    standing.id.toString());
                            Navigator.of(context).pushNamed(
                              '/teamDetails',
                            );
                          },
                          tableLine: standing,
                        );
                      },
                      childCount: seasonState.standingsResponse.list.length,
                    ),
                  ),
                  headerSection(context, seasonState.nextWeek.name),
                  FixturesView(
                    week: seasonState.nextWeek,
                  )
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class TableRowView extends StatelessWidget {
  final VoidCallback callback;
  final TableLine tableLine;

  const TableRowView({Key key, this.callback, this.tableLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Container(
                      width: 20,
                      child: Text(
                        tableLine.position.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(width: 10),
                    FadeInImage(
                      width: 30,
                      height: 30,
                      placeholder:
                          AssetImage('assets/images/shield-placeholder.png'),
                      image: AssetImage(
                          'assets/images/logos/' + tableLine.id + '.png'),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Text(
                      tableLine.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(children: [
                  SizedBox(width: 10),
                  Container(
                    width: 20,
                    child: Text(
                      tableLine.games.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 20,
                    child: Text(
                      tableLine.wins.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 20,
                    child: Text(
                      tableLine.draws.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 20,
                    child: Text(
                      tableLine.losses.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 20,
                    child: Text(
                      tableLine.goalsDifference.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 20,
                    child: Text(
                      tableLine.points.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(width: 15),
                ]),
              ],
            ),
            SizedBox(height: 9),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}

Widget headerSection(BuildContext context, String title) => SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: Theme.of(context).textTheme.headline5),
      ),
    );

Widget tableHeader(BuildContext context) => SliverPadding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 50,
              child: Text(
                '#',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: 145,
              child: Text(
                'Club',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                'PL',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                'W',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                'D',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                'L',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                'GD',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              child: Text(
                'Pts',
                style: Theme.of(context).textTheme.overline,
              ),
            ),
          ],
        ),
      ),
    );

class ClientMembersDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;
  final String imageURL;
  final String sku;

  ClientMembersDelegate(
      this.backgroundColor, this._title, this.imageURL, this.sku);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: backgroundColor,
        child: Center(
          child: Image.network(imageURL,
              width: 600, height: 100, fit: BoxFit.fill),
        ));
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
