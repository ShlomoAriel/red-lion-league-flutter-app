import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/views/common/table_header_view.dart';

class _TableViewState extends State<TableView> {
  var _isForm = false;
  var columns = [
    TableHeaderColumnView(
      width: 50,
      label: '#',
    ),
    TableHeaderColumnView(
      width: 45,
      label: 'קבוצה',
    ),
    TableHeaderColumnView(
      width: 100,
      label: '',
    ),
    TableHeaderColumnView(
      width: 30,
      label: 'מש',
    ),
    TableHeaderColumnView(
      width: 30,
      label: 'נצ',
    ),
    TableHeaderColumnView(
      width: 30,
      label: 'תק',
    ),
    TableHeaderColumnView(
      width: 30,
      label: 'הפ',
    ),
    TableHeaderColumnView(
      width: 30,
      label: 'הפרש',
    ),
    TableHeaderColumnView(
      width: 40,
      label: 'נק',
    )
  ];

  @override
  Widget build(Object context) {
    return SliverToBoxAdapter(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 53,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: FilterChip(
            labelPadding: EdgeInsets.only(top: 2, bottom: 2, left: 15, right: 15),
            backgroundColor: Colors.white,
            label: Text(
              'כושר',
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
        Container(color: Colors.white, child: TableHeader(tableRowColumns: columns)),
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

class TableFormRowView extends StatelessWidget {
  final VoidCallback callback;
  final TableLine tableLine;

  const TableFormRowView({Key key, this.callback, this.tableLine}) : super(key: key);

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
                  for (var item in tableLine.matchForm.getRange(0, 5))
                    Container(
                      decoration: BoxDecoration(color: item.resultColor, shape: BoxShape.circle),
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 5),
                      width: 30,
                      child: Text(
                        item.resultText,
                        style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.white),
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