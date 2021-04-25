import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/common/sliver_section_view.dart';

class TeamDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: BlocBuilder<LeagueCubit, LeagueState>(
        builder: (context, state) {
          if (state == null ||
              state.isLoading ||
              state.selectedTeam == null ||
              state.store[state.currentSeason.id] == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var seasonState = state.store[state.currentSeason.id];
            var team = seasonState.teamsMap[state.selectedTeam];
            return CustomScrollView(
              slivers: [
                MySliverAppBar(team.name, seasonState.season.name),
                SliverSectionView(title: 'משחקים אחרונים'),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          for (var item in team.matchForm.getRange(0, 5))
                            Container(
                              decoration:
                                  BoxDecoration(color: item.resultColor, shape: BoxShape.circle),
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 5),
                              width: 30,
                              child: Text(
                                item.resultText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .apply(color: Colors.white),
                              ),
                            ),
                        ]),
                      ],
                    ),
                  ),
                ),
                SliverSectionView(title: 'העונה'),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            color: Colors.green,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              'נצחונות: ' + team.standing?.wins.toString(),
                              style:
                                  Theme.of(context).textTheme.bodyText1.apply(color: Colors.white),
                            ),
                          ),
                          Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              'תיקו: ' + team.standing?.draws.toString(),
                              style:
                                  Theme.of(context).textTheme.bodyText1.apply(color: Colors.white),
                            ),
                          ),
                          Container(
                            color: Colors.red,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              'הפסדים: ' + team.standing?.losses.toString(),
                              style:
                                  Theme.of(context).textTheme.bodyText1.apply(color: Colors.white),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                SliverSectionView(title: 'שחקנים'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final player =
                            seasonState.teamsMap[state.selectedTeam].seasonPlayers[index];
                        return TeamDetailsRowView(
                          team: team,
                          // callback: () {},
                          tableLine: player,
                        );
                      },
                      childCount: seasonState.teamsMap[state.selectedTeam].seasonPlayers.length,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class TeamDetailsRowView extends StatelessWidget {
  final VoidCallback callback;
  final Player tableLine;
  final Team team;

  const TeamDetailsRowView({Key key, this.callback, this.tableLine, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        // padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15),
                      CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 3.4,
                      ),
                      SizedBox(width: 10),
                      FadeInImage(
                        width: 30,
                        height: 30,
                        placeholder: AssetImage('assets/images/shield-placeholder.png'),
                        image: AssetImage('assets/images/logos/' + team.id + '.png'),
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
                      width: 60,
                      child: Text(tableLine.position ?? ''),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 20,
                      child: Text(tableLine.goals ?? ''),
                    ),
                    SizedBox(width: 20),
                  ]),
                ],
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 1,
                color: Colors.grey[200],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget headerSection(BuildContext context, String title) => SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: Theme.of(context).textTheme.headline2),
      ),
    );

class ClientMembersDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;
  final String imageURL;
  final String sku;

  ClientMembersDelegate(this.backgroundColor, this._title, this.imageURL, this.sku);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: backgroundColor,
        child: Center(
          child: Image.network(imageURL, width: 600, height: 400, fit: BoxFit.fitWidth),
        ));
  }

  @override
  double get maxExtent => 250;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
