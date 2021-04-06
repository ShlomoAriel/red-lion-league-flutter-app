import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:league/views/common/sliver_section_view.dart';
import 'package:league/views/common/table_header_view.dart';
import 'package:league/views/fixtures/fixtures_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../header_view.dart';

class TableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<LeagueCubit, LeagueState>(
        builder: (context, state) {
          if (state == null ||
              state.isLoading ||
              state.store == null ||
              state.store[state.currentSeason.id] == null) {
            return Container(
                color: Colors.grey[200],
                child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      MySliverAppBar(
                          'ליגת האריה האדום', 'seasonState.season.name'),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ]));
          } else {
            var seasonState = state.store[state.currentSeason.id];
            var columns = [
              TableHeaderColumnView(
                index: 1,
                width: 50,
                label: '#',
              ),
              TableHeaderColumnView(
                index: 2,
                width: 45,
                label: 'קבוצה',
              ),
              TableHeaderColumnView(
                index: 2,
                width: 100,
                label: '',
              ),
              TableHeaderColumnView(
                index: 3,
                width: 30,
                label: 'מש',
              ),
              TableHeaderColumnView(
                index: 3,
                width: 30,
                label: 'נצ',
              ),
              TableHeaderColumnView(
                index: 3,
                width: 30,
                label: 'תק',
              ),
              TableHeaderColumnView(
                index: 3,
                width: 30,
                label: 'הפ',
              ),
              TableHeaderColumnView(
                index: 3,
                width: 30,
                label: 'הפרש',
              ),
              TableHeaderColumnView(
                index: 3,
                width: 30,
                label: 'נק',
              )
            ];
            return Container(
              color: Colors.grey[200],
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  MySliverAppBar('ליגת האריה האדום', seasonState.season.name),
                  // SliverPadding(
                  //   sliver: SliverToBoxAdapter(child: SeasonDropDown()),
                  //   padding: EdgeInsets.only(
                  //       left: 20, right: 20, top: 10, bottom: 10),
                  // ),
                  TableHeader(
                    tableRowColumns: columns,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final standing =
                            seasonState.standingsResponse.list[index];
                        return TableRowView(
                          callback: () {
                            BlocProvider.of<LeagueCubit>(context)
                                .setTeamSeasonPlayers(state.currentSeason.id,
                                    standing.id.toString());
                            Navigator.of(context).pushNamed(
                              '/teamDetails',
                            );
                          },
                          tableLine: standing,
                        );
                      },
                      childCount: seasonState.standingsResponse.list.length,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10),
                    sliver: SliverToBoxAdapter(
                        child: CarouselSlider(
                      options: CarouselOptions(
                          height: 220.0,
                          // enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 1),
                      items: [
                        'https://i.imgur.com/128iWylh.jpg',
                        'https://i.imgur.com/IOOuJPzh.jpg',
                        'https://i.imgur.com/CDTbIghh.jpg',
                        'https://i.imgur.com/cEp4nvhh.jpg',
                        'https://i.imgur.com/c0WQhRIh.jpg',
                        'https://i.imgur.com/jJD28Srh.jpg',
                        'https://i.imgur.com/ehdBfUkh.jpg',
                        'https://i.imgur.com/oBAXUCqh.jpg',
                        'https://i.imgur.com/ZAwJAlAh.jpg',
                        'https://i.imgur.com/jJD28Srh.jpg',
                        'https://i.imgur.com/7cSF86Mh.jpg',
                        'https://i.imgur.com/pA6NAkph.jpg'
                      ].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder:
                                      'assets/images/LOGO CLEAN BACKGROUND.png',
                                  image: i,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            );
                            // return Container(
                            //   child: FadeInImage.memoryNetwork(
                            //     placeholder: kTransparentImage,
                            //     image: i,
                            //     fit: BoxFit.contain,
                            //   ),
                            // );
                            // return Container(
                            //     margin: EdgeInsets.symmetric(horizontal: 2.0),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5.0),
                            //       image: DecorationImage(
                            //           image: NetworkImage(i), fit: BoxFit.cover),
                            //     ));
                          },
                        );
                      }).toList(),
                    )),
                  ),
                  SliverSectionView(title: 'מחזור הבא'),
                  SliverToBoxAdapter(
                    child: FixturesWeekView(
                      week: seasonState.nextWeek,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 10),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class SeasonDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueCubit, LeagueState>(builder: (context, state) {
      if (state == null ||
          state.seasons == null ||
          state.currentSeason == null) {
        return Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      } else {
        return Container(
          child: PopupMenuButton<Season>(
            itemBuilder: (BuildContext context) {
              return state.seasons.map((value) {
                return new PopupMenuItem<Season>(
                  value: value,
                  child: new Text(value?.name ?? 'NA'),
                );
              }).toList();
            },
            initialValue: state.currentSeason,
            onSelected: (value) {
              print(value);
              BlocProvider.of<LeagueCubit>(context).setSeason(value);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding:
                    EdgeInsets.only(left: 12, top: 7, bottom: 7, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_drop_down)),
                    Text(state.currentSeason.name,
                        style: Theme.of(context).textTheme.headline6),
                  ],
                )),
            elevation: 16,
          ),
        );
      }
    });
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
              width: 600, height: 100, fit: BoxFit.fill),
        ));
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
