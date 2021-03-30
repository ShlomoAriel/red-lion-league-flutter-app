import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:league/bloc/client/client_list_cubit.dart';
import 'package:league/bloc/client/client_list_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedClientListsView extends StatelessWidget {
  // 2
  final List<ClientList> clientLists;

  const FeaturedClientListsView({Key key, this.clientLists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 0);
        },
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        itemCount: clientLists.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final standingsLine = clientLists[index];
          return GestureDetector(
            onTap: () {
              BlocProvider.of<ClientListCubit>(context)
                  .setSelectedClientList(standingsLine);
              Navigator.of(context).pushNamed(
                '/clientListMembers',
              );
            },
            child: Card(
              elevation: 3,
              shadowColor: Colors.black12,
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 150,
                      height: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(standingsLine.headerImage),
                        ),
                      ),
                    ),
                    Container(
                        height: 30,
                        padding: EdgeInsets.only(left: 20.0, top: 15),
                        child: Text(standingsLine.name.toUpperCase(),
                            style: Theme.of(context).textTheme.headline3)),
                    Container(
                        height: 20,
                        padding: EdgeInsets.only(left: 20.0, top: 7),
                        child: Text(
                            standingsLine.clientIds.length.toString() +
                                ' Clients',
                            style: Theme.of(context).textTheme.headline5))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
