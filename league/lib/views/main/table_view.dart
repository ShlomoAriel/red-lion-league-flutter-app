import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_models.dart';

class TableView extends StatelessWidget {
  final standingsList;
  final seasonId;

  const TableView({Key key, this.standingsList, this.seasonId})
      : super(key: key);

  @override
  Widget build(Object context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final standing = standingsList[index];
          return TableRowView(
            callback: () {
              BlocProvider.of<LeagueCubit>(context)
                  .setTeamSeasonPlayers(seasonId, standing.id.toString());
              Navigator.of(context).pushNamed(
                '/teamDetails',
              );
            },
            tableLine: standing,
          );
        },
        childCount: standingsList.length,
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
