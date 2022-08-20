import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/fixtures/match_view.dart';
import 'package:league/views/main/shimmer_placeholders.dart';

class TeamDetailsView extends StatelessWidget {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: BlocBuilder<LeagueCubit, LeagueState>(
        builder: (context, state) {
          var team = getTeam(state);
          var players = getPlayers(state);
          final cubit = BlocProvider.of<LeagueCubit>(context);
          return CustomScrollView(
            slivers: [
              TeamAppBar(team),
              SliverToBoxAdapter(
                  child: Card(
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('העונה', style: Theme.of(context).textTheme.headline6)),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: MatchForm.formColorMap['W'],
                                borderRadius: BorderRadius.circular(5)),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5),
                            child: (team != null)
                                ? Text(
                                    'נצחונות: ' + team!.standing!.wins.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .apply(color: Colors.white),
                                  )
                                : getShimmer(90.0, 60.0),
                          ),
                          Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: MatchForm.formColorMap['D'],
                                borderRadius: BorderRadius.circular(5)),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5),
                            child: (team != null)
                                ? Text(
                                    'תיקו: ' + team.standing!.draws.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .apply(color: Colors.white),
                                  )
                                : getShimmer(90.0, 60.0),
                          ),
                          Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: MatchForm.formColorMap['L'],
                                borderRadius: BorderRadius.circular(5)),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 5),
                            child: (team != null)
                                ? Text(
                                    'הפסדים: ' + team.standing!.losses.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .apply(color: Colors.white),
                                  )
                                : getShimmer(90.0, 60.0),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
              )),
              SliverToBoxAdapter(
                  child: Card(
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('משחקים', style: Theme.of(context).textTheme.headline6)),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      height: 100.0,
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 40);
                          },
                          padding: EdgeInsets.only(left: 20.0, right: 20),
                          itemCount: (team != null) ? team.matchForm.length : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            final item = (team != null) ? team.matchForm[index] : null;
                            return (team != null)
                                ? MatchScoreHeader(item.match, cubit, state, context)
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5)),
                                    width: 30,
                                    height: 30,
                                    padding: EdgeInsets.all(1),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 5),
                                    child: getShimmer(30.0, 30.0));
                          })),
                ]),
              )),
              SliverToBoxAdapter(
                  child: Card(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text('שחקנים', style: Theme.of(context).textTheme.headline6)),
                    ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: (players != null) ? players.length : 10,
                        itemBuilder: (context, index) {
                          final player = (players != null) ? players[index] : [];
                          return (players != null && team != null)
                              ? TeamDetailsRowView(
                                  team: team,
                                  tableLine: player,
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: getShimmer(300.0, 50.0),
                                );
                        }),
                  ],
                ),
              )),
            ],
          );
        },
      ),
    );
  }

  getPlayers(LeagueState state) {
    if (state == null ||
        state.isLoading! ||
        state.selectedTeam == null ||
        state.store![state.currentSeason!.id] == null) {
      return [];
    } else {
      var seasonState = state.store![state.currentSeason!.id]!;
      var team = seasonState.teamsMap![state.selectedTeam];
      return team?.seasonPlayers ?? [];
    }
  }

  getTeam(LeagueState state) {
    if (state == null ||
        state.isLoading! ||
        state.selectedTeam == null ||
        state.store![state.currentSeason!.id] == null) {
      return null;
    } else {
      var seasonState = state.store![state.currentSeason!.id]!;
      var team = seasonState.teamsMap![state.selectedTeam];
      return team;
    }
  }
}

class TeamDetailsRowView extends StatelessWidget {
  final VoidCallback? callback;
  final Player? tableLine;
  final Team? team;

  const TeamDetailsRowView({Key? key, this.callback, this.tableLine, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
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
                      CachedNetworkImage(
                        width: 30,
                        height: 30,
                        imageUrl: team?.logoURL ?? '',
                        placeholder: (context, url) =>
                            new Image.asset('assets/images/shield-placeholder.png'),
                        errorWidget: (context, url, error) =>
                            new Image.asset('assets/images/shield-placeholder.png'),
                      ),
                      SizedBox(width: 8),
                      Text(
                        tableLine!.name!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(children: [
                    SizedBox(width: 10),
                    Container(
                      width: 60,
                      child: Text(tableLine!.position ?? ''),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 20,
                      child: Text(tableLine!.goals ?? ''),
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
  final String imageURL;
  final String sku;

  ClientMembersDelegate(this.backgroundColor, this.imageURL, this.sku);

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

Widget MatchScoreHeader(Match match, LeagueCubit cubit, state, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          BlocProvider.of<LeagueCubit>(context)
              .setTeamSeasonPlayers(match.seasonId, match.homeTeam?.id ?? '');
          Navigator.of(context).pushNamed(
            '/teamDetails',
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              width: 45,
              height: 45,
              imageUrl: match.homeTeam?.logoURL ?? '',
              placeholder: (context, url) =>
                  new Image.asset('assets/images/shield-placeholder.png'),
              errorWidget: (context, url, error) =>
                  new Image.asset('assets/images/shield-placeholder.png'),
            ),
            Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Text(match.homeName ?? '', style: Theme.of(context).textTheme.bodyText1)
            ])),
          ],
        ),
      ),
      SizedBox(width: 5),
      Container(
        child: Row(
          children: [
            Text(match.played ?? false ? match.homeGoals.toString() : '',
                style: Theme.of(context).textTheme.headline6),
            Text(match.played ?? false ? ' - ' : match.time ?? '-',
                style: Theme.of(context).textTheme.headline6),
            Text(match.played ?? false ? match.awayGoals.toString() : '',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
      SizedBox(width: 5),
      GestureDetector(
        onTap: () {
          BlocProvider.of<LeagueCubit>(context)
              .setTeamSeasonPlayers(match.seasonId, match.awayTeam?.id ?? '');
          Navigator.of(context).pushNamed(
            '/teamDetails',
          );
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CachedNetworkImage(
            width: 45,
            height: 45,
            imageUrl: match.awayTeam?.logoURL ?? '',
            placeholder: (context, url) => new Image.asset('assets/images/shield-placeholder.png'),
            errorWidget: (context, url, error) =>
                new Image.asset('assets/images/shield-placeholder.png'),
          ),
          Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Text(match.awayName ?? '', style: Theme.of(context).textTheme.bodyText1)
          ])),
        ]),
      )
    ],
  );
}
