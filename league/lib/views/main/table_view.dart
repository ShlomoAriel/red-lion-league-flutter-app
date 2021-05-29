import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/views/common/table_header_view.dart';

class _TableViewState extends State<TableView> {
  var _isForm = false;
  @override
  Widget build(Object context) {
    return SliverToBoxAdapter(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: FilterChip(
            labelPadding: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
            backgroundColor: Colors.white,
            label: Text(
              'משחקים אחרונים',
              style: Theme.of(context).textTheme.button,
            ),
            showCheckmark: false,
            selected: _isForm,
            elevation: 1,
            selectedColor: Colors.grey[300],
            onSelected: (bool selected) {
              setState(() {
                _isForm = !_isForm;
              });
            },
          ),
        ),
        Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              _isForm
                  ? TableHeaderRowView(
                      columnList: ['5 משחקים אחרונים'],
                      columnWidth: 150.0,
                    )
                  : TableHeaderRowView(
                      columnList: ['מש', 'נצ', 'תק', 'הפ', 'הש', 'נק'], columnWidth: 20.0),
              ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                physics: const NeverScrollableScrollPhysics(),
                controller: widget.scrollController,
                shrinkWrap: true,
                itemCount: widget.standingsList.length,
                itemBuilder: (context, index) {
                  final standing = widget.standingsList[index];
                  return showRow(standing, context);
                },
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget showRow(standing, context) {
    if (_isForm) {
      return TableFormRowView(
        callback: () {
          BlocProvider.of<LeagueCubit>(context)
              .setTeamSeasonPlayers(widget.seasonId, standing.id.toString());
          Navigator.of(context).pushNamed(
            '/teamDetails',
          );
        },
        tableLine: standing,
      );
    } else {
      return TableRowView(
        callback: () {
          BlocProvider.of<LeagueCubit>(context)
              .setTeamSeasonPlayers(widget.seasonId, standing.id.toString());
          Navigator.of(context).pushNamed(
            '/teamDetails',
          );
        },
        tableLine: standing,
      );
    }
  }
}

class TableView extends StatefulWidget {
  final standingsList;
  final seasonId;
  final scrollController;
  final isForm;
  TableView({Key key, this.standingsList, this.seasonId, this.scrollController, this.isForm})
      : super(key: key);

  _TableViewState createState() => _TableViewState();
}

class TableRowView extends StatelessWidget {
  final VoidCallback callback;
  final TableLine tableLine;

  const TableRowView({Key key, this.callback, this.tableLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
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
                  FadeInImage(
                    width: 30,
                    height: 30,
                    placeholder: AssetImage('assets/images/shield-placeholder.png'),
                    image: AssetImage('assets/images/logos/' + tableLine.id + '.png'),
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
                  alignment: Alignment.center,
                  child: Text(
                    tableLine.games.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    tableLine.wins.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    tableLine.draws.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    tableLine.losses.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(width: 10),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    width: 20,
                    alignment: Alignment.center,
                    child: Text(
                      tableLine.goalsDifference.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    tableLine.points.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(width: 10),
              ]),
            ],
          ),
          SizedBox(height: 9),
        ],
      ),
    );
  }
}

class TableFormRowView extends StatelessWidget {
  final VoidCallback callback;
  final TableLine tableLine;

  const TableFormRowView({Key key, this.callback, this.tableLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
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
                  FadeInImage(
                    width: 30,
                    height: 30,
                    placeholder: AssetImage('assets/images/shield-placeholder.png'),
                    image: AssetImage('assets/images/logos/' + tableLine.id + '.png'),
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8),
                  Text(
                    tableLine.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var item in tableLine.matchForm.reversed.take(5).toList().reversed)
                      Container(
                        decoration: BoxDecoration(
                            color: item.resultColor, borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(4),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 5),
                        width: 25,
                        child: Text(
                          item.resultText,
                          style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.white),
                        ),
                      ),
                    SizedBox(width: 10),
                  ]),
            ],
          ),
          SizedBox(height: 9)
        ],
      ),
    );
  }
}
