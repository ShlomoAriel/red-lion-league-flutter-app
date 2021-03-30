import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FixturesView extends StatelessWidget {
  final Week week;

  const FixturesView({Key key, this.week}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: week.fixtures.keys.toList().length,
          itemBuilder: (context, index) {
            final keys = week.fixtures.keys.toList();
            final list = week.fixtures[keys[index]];
            return FixtureDayView(dateString: keys[index], matches: list);
          },
        ),
      ),
    );
  }
}

class FixtureDayView extends StatelessWidget {
  final List<Match> matches;
  final String dateString;

  const FixtureDayView({Key key, this.matches, this.dateString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 20),
          alignment: Alignment.centerLeft,
          child:
              Text(dateString, style: Theme.of(context).textTheme.subtitle2)),
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
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment:
                CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  width: 100,
                  child: Text(match.homeName,
                      style: Theme.of(context).textTheme.bodyText1)),
              SizedBox(width: 10),
              FadeInImage(
                width: 30,
                height: 30,
                placeholder: AssetImage('assets/images/shield-placeholder.png'),
                image:
                    AssetImage('assets/images/logos/' + match.homeId + '.png'),
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Text(match.played ? match.homeGoals.toString() : '',
                  style: Theme.of(context).textTheme.bodyText1),
              Text(match.played ? ' - ' : match.time,
                  style: Theme.of(context).textTheme.bodyText1),
              Text(match.played ? match.awayGoals.toString() : '',
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(width: 10),
              FadeInImage(
                width: 30,
                height: 30,
                placeholder: AssetImage('assets/images/shield-placeholder.png'),
                image:
                    AssetImage('assets/images/logos/' + match.awayId + '.png'),
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Container(
                  alignment: Alignment.centerLeft,
                  width: 100,
                  child: Text(match.awayName,
                      style: Theme.of(context).textTheme.bodyText1)),
            ],
          );
        }));
  }
}
