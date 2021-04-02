import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              showSliver(seasonState),
              showSliver(seasonState)
            ]),
      );
    });
  }

  Widget showSliver(SeasonState seasonState) {
    if (seasonState == null || seasonState.scorers == null) {
      return SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else {
      return SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            itemCount: seasonState.scorers.length,
            itemBuilder: (context, index) {
              final scorer = seasonState.scorers[index];
              return ScorerRowView(
                  scorer: scorer, position: (index + 1).toString());
            },
          ),
        ),
      );
    }
  }
}

class ScorerRowView extends StatelessWidget {
  final Scorer scorer;
  final String position;

  const ScorerRowView({Key key, this.scorer, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      SizedBox(width: 20),
                      Container(
                        width: 20,
                        child: Text(position,
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      FadeInImage(
                        width: 30,
                        height: 30,
                        placeholder:
                            AssetImage('assets/images/shield-placeholder.png'),
                        image: AssetImage(
                            'assets/images/logos/' + scorer.teamId + '.png'),
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8),
                      Text(
                        scorer.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(children: [
                    SizedBox(width: 10),
                    Container(
                      width: 20,
                      child: Text(scorer.goals.toString() ?? ''),
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
