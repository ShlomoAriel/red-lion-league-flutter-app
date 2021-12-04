import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:league/views/main/shimmer_placeholders.dart';

class MatchView extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      var match = state.selectedMatch!;
      final cubit = BlocProvider.of<LeagueCubit>(context);
      var matchGoals = cubit.getMatchGoals(match);
      return Container(
          color: Colors.white,
          child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  title:
                      Text('מחזור ' + match.weekName!, style: Theme.of(context).textTheme.headline6),
                  backgroundColor: Colors.white,
                ),
                matchScore(match, cubit, state, context),
                SliverToBoxAdapter(
                    child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: (MediaQuery.of(context).size.width / 2) - 7.5,
                          child: MatchScorerView(
                              goals: matchGoals['homeGoals'], alignment: Alignment.centerLeft)),
                      Container(
                          width: 15,
                          padding: EdgeInsets.only(top: 10),
                          child: (() {
                            if (matchGoals['awayGoals']!.length > 0 ||
                                matchGoals['homeGoals']!.length > 0) {
                              return FadeInImage(
                                width: 15,
                                height: 15,
                                placeholder: AssetImage('assets/images/football.png'),
                                image: AssetImage('assets/images/football.png'),
                                fit: BoxFit.cover,
                              );
                            }
                          }())),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: (MediaQuery.of(context).size.width / 2) - 7.5,
                          child: MatchScorerView(
                              goals: matchGoals['awayGoals'], alignment: Alignment.centerRight)),
                    ],
                  ),
                )),
              ]));
    });
  }
}

Widget matchScore(Match match, LeagueCubit cubit, state, context) {
  var match = state.selectedMatch;
  var store = state.store[state.currentSeason.id];
  Team homeTeam = store.teamsMap[match.homeId];
  Team awayTeam = store.teamsMap[match.awayId];
  return SliverToBoxAdapter(
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              BlocProvider.of<LeagueCubit>(context)
                  .setTeamSeasonPlayers(match.seasonId, homeTeam.id.toString());
              Navigator.of(context).pushNamed(
                '/teamDetails',
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  width: 95,
                  height: 95,
                  imageUrl: homeTeam.logoURL ?? '',
                  placeholder: (context, url) =>
                      new Image.asset('assets/images/shield-placeholder.png'),
                  errorWidget: (context, url, error) =>
                      new Image.asset('assets/images/shield-placeholder.png'),
                ),
                Container(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(match.homeName, style: Theme.of(context).textTheme.headline6)
                ])),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Text(match.played ? match.homeGoals.toString() : '',
                    style: Theme.of(context).textTheme.headline4),
                Text(match.played ? ' - ' : match.time,
                    style: Theme.of(context).textTheme.headline4),
                Text(match.played ? match.awayGoals.toString() : '',
                    style: Theme.of(context).textTheme.headline4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              BlocProvider.of<LeagueCubit>(context)
                  .setTeamSeasonPlayers(match.seasonId, awayTeam.id.toString());
              Navigator.of(context).pushNamed(
                '/teamDetails',
              );
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CachedNetworkImage(
                width: 95,
                height: 95,
                imageUrl: awayTeam.logoURL ?? '',
                placeholder: (context, url) =>
                    new Image.asset('assets/images/shield-placeholder.png'),
                errorWidget: (context, url, error) =>
                    new Image.asset('assets/images/shield-placeholder.png'),
              ),
              Container(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(match.awayName, style: Theme.of(context).textTheme.headline6)
              ])),
            ]),
          )
        ],
      ),
    ),
  );
}

class MatchScorerView extends StatelessWidget {
  final List<Goal>? goals;
  final Alignment? alignment;

  const MatchScorerView({Key? key, this.goals, this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 0);
            },
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 20, right: 20),
            itemCount: (goals != null) ? goals!.length : 10,
            itemBuilder: (_, index) {
              final item = (goals != null) ? goals![index] : null;
              return (goals != null)
                  ? Container(
                      alignment: alignment,
                      width: 30,
                      height: 30,
                      child: Text(
                        item!.player!.name!,
                        style: Theme.of(context).textTheme.bodyText1!.apply(),
                      ))
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(1),
                      // alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 5),
                      child: getShimmer(30.0, 30.0));
            }));
  }
}
