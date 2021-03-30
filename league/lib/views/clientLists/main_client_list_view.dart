import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:league/bloc/client/client_list_cubit.dart';
import 'package:league/bloc/client/client_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/views/clientLists/featured_client_lists.dart';

class ClientListView extends StatelessWidget {
  final formatCurrency =
      new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: BlocBuilder<ClientListCubit, ClientListState>(
        cubit: BlocProvider.of<ClientListCubit>(context),
        builder: (context, state) {
          if (state == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 50,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  sliver: SliverToBoxAdapter(
                    child: Text('Clients',
                        style: Theme.of(context).textTheme.headline1),
                  ),
                ),
                headerSection(context, 'HQ Lists'),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  sliver: SliverToBoxAdapter(
                    child: FeaturedClientListsView(
                      clientLists: state.featuredLists,
                    ),
                  ),
                ),
                headerSection(context, 'My Lists'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final clientList = state.myLists[index];
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<ClientListCubit>(context)
                                .setSelectedClientList(clientList);
                            Navigator.of(context).pushNamed(
                              '/clientListMembers',
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              title: Text(
                                clientList.name,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              subtitle: Text(
                                  clientList.clients.length.toString() +
                                      ' Clients'),
                              leading: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 44,
                                    minHeight: 44,
                                    maxWidth: 44,
                                    maxHeight: 44,
                                  ),
                                  child: Icon(
                                    Icons.format_list_bulleted_sharp,
                                    color: Colors.grey[600],
                                    size: 20.0,
                                  )),
                            ),
                          ),
                        );
                      },
                      childCount: state.myLists.length,
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

Widget headerSection(BuildContext context, String title) => SliverPadding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: Theme.of(context).textTheme.headline2),
      ),
    );
