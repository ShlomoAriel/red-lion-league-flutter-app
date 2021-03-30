import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';

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
              state.store[state.currentSeason] == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var seasonState = state.store[state.currentSeason];
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(
                    'state.seasons',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  backgroundColor: Color(0xFFEDF2F8),
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                        'https://scontent.fsdv3-1.fna.fbcdn.net/v/t31.0-8/12698529_231358233869155_5619845670877879998_o.png?_nc_cat=101&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=2EA7Ge84dF8AX9Zkzga&_nc_ht=scontent.fsdv3-1.fna&oh=e4bf096459653b87c3ce6570161678cc&oe=608202A1',
                        fit: BoxFit.cover),
                  ),
                ),
                headerSection(context, state.selectedTeam ?? ''),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final player = seasonState
                            .teamsMap[state.selectedTeam].seasonPlayers[index];
                        return TeamDetailsRowView(
                          callback: () {
                            // BlocProvider.of<LeagueCubit>(context)
                            //     .setTeamSeasonPlayers(
                            //         state.currentSeason.id.toString(),
                            //         standing.id.toString());
                          },
                          tableLine: player,
                        );
                      },
                      childCount: seasonState
                          .teamsMap[state.selectedTeam].seasonPlayers.length,
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

  const TeamDetailsRowView({Key key, this.callback, this.tableLine})
      : super(key: key);

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
                        placeholder: AssetImage('assets/images/gold.png'),
                        image: NetworkImage('https://i.imgur.com/bTa4y4S.png'),
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

  ClientMembersDelegate(
      this.backgroundColor, this._title, this.imageURL, this.sku);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: backgroundColor,
        child: Center(
          child: Image.network(imageURL,
              width: 600, height: 400, fit: BoxFit.fitWidth),
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
