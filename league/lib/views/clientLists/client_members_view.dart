import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:league/bloc/client/client_list_cubit.dart';
import 'package:league/bloc/client/client_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/utils/utils.dart';

class ClientMembersView extends StatelessWidget {
  final formatCurrency =
      new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: BlocBuilder<ClientListCubit, ClientListState>(
        builder: (context, state) {
          if (state == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(
                    state.selectedClientList.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  backgroundColor: Color(0xFFEDF2F8),
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                        state.selectedClientList.headerImage,
                        fit: BoxFit.cover),
                  ),
                ),
                // SliverPersistentHeader(
                //   pinned: true,
                //   floating: false,
                //   delegate: ClientMembersDelegate(
                //       Colors.white, state.name, state.headerImage, state.name),
                // ),
                // SliverPadding(
                //   padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                //   sliver: SliverToBoxAdapter(
                //     child: Text(state.name,
                //         style: Theme.of(context).textTheme.headline1),
                //   ),
                // ),
                headerSection(context,
                    state.selectedClientList.listDescription ?? 'List Members'),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final client = state.selectedClientList.clients[index];
                        final clientSegmentCode =
                            (client.currentSegment != null)
                                ? client.currentSegment
                                : 'VVIC';
                        return GestureDetector(
                          onTap: () {
                            // Set current selected client in the state
                            BlocProvider.of<ClientListCubit>(context)
                                .setSelectedClients(client.id);
                          },
                          child: Container(
                            // padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              color: state.selectedClientIds.contains(client.id)
                                  ? Colors.grey[100]
                                  : Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 10),
                                          CircleAvatar(
                                            backgroundColor: Colors.green[200],
                                            radius: 3.4,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            client.firstName +
                                                ' ' +
                                                client.lastName.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ],
                                      ),
                                      Row(children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              color: segmentColorMap[
                                                  clientSegmentCode],
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(3),
                                                  topLeft: Radius.circular(3),
                                                  bottomLeft:
                                                      Radius.circular(3),
                                                  bottomRight:
                                                      Radius.circular(3)),
                                            ),
                                            // color: Colors.red,
                                            padding:
                                                EdgeInsets.fromLTRB(5, 3, 5, 3),
                                            child: Text(
                                              client.currentSegmentLabel,
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontFamily:
                                                      'Montserrat-Medium',
                                                  color: Colors.white),
                                            )),
                                        SizedBox(width: 20),
                                      ]),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      SizedBox(width: 24),
                                      Text(
                                        'Last contact ' +
                                            client.lastContactedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
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
                      },
                      childCount: state.selectedClientList.clients.length,
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

class ClientMembersDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;
  final String imageURL;
  final String sku;

  ClientMembersDelegate(
      this.backgroundColor, this._title, this.imageURL, this.sku);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: backgroundColor,
        child: Center(
          child: Image.network(imageURL,
              width: 600, height: 400, fit: BoxFit.fitWidth),
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
