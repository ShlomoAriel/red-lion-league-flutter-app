import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FixtureView extends StatelessWidget {
  final Match match;

  const FixtureView({Key key, this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
          var store = state.store[state.currentSeason.id];
          Team homeTeam = store.teamsMap[match.homeId];
          Team awayTeam = store.teamsMap[match.awayId];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              Container(
                  width: 90,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(match.homeName, style: Theme.of(context).textTheme.bodyText1)
                  ])),
              SizedBox(width: 10),
              CachedNetworkImage(
                width: 30,
                height: 30,
                imageUrl: homeTeam.logoURL ?? '',
                placeholder: (context, url) =>
                    new Image.asset('assets/images/shield-placeholder.png'),
                errorWidget: (context, url, error) =>
                    new Image.asset('assets/images/shield-placeholder.png'),
              ),
              SizedBox(width: 10),
              Text(match.played ? match.homeGoals.toString() : '',
                  style: Theme.of(context).textTheme.bodyText1),
              Text(match.played ? ' - ' : match.time, style: Theme.of(context).textTheme.bodyText1),
              Text(match.played ? match.awayGoals.toString() : '',
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(width: 10),
              CachedNetworkImage(
                width: 30,
                height: 30,
                imageUrl: awayTeam.logoURL ?? '',
                placeholder: (context, url) =>
                    new Image.asset('assets/images/shield-placeholder.png'),
                errorWidget: (context, url, error) =>
                    new Image.asset('assets/images/shield-placeholder.png'),
              ),
              SizedBox(width: 10),
              Container(
                  width: 90,
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(match.awayName, style: Theme.of(context).textTheme.bodyText1)
                  ])),
            ],
          );
        }));
  }
}