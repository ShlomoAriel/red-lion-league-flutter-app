import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_models.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/common/sliver_section_view.dart';
import 'package:league/views/fixtures/fixtures_view.dart';
import 'package:league/views/main/table_view.dart';
import 'image_gallery_view.dart';
import 'package:league/views/main/shimmer_placeholders.dart';

class MainView extends StatelessWidget {
  final scrollController = ScrollController();
  final sponsors = [
    Sponser('Tezos', 'https://cryptologos.cc/logos/tezos-xtz-logo.png'),
    Sponser('הכל כאן',
        'https://scontent.fsdv3-1.fna.fbcdn.net/v/t1.6435-9/97980055_886905228513312_522014925065814016_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=FjgaZSkct-AAX_CGhMX&_nc_ht=scontent.fsdv3-1.fna&oh=dfeaccf9496753e55172be33f3b50587&oe=60BA2933'),
    Sponser('מתנס אפרת',
        'https://scontent.fsdv3-1.fna.fbcdn.net/v/t1.18169-9/27657192_1577902965621993_8240875625499441220_n.jpg?_nc_cat=110&ccb=1-3&_nc_sid=174925&_nc_ohc=mFlgWDR3jB0AX9fEf1q&_nc_ht=scontent.fsdv3-1.fna&oh=44adefc49f20dc3d59c4189ad6c1bfed&oe=60BA9178')
  ];
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
                child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
                  MainAppBar('ליגת האריה האדום', 'seasonState.season.name'),
                  SliverToBoxAdapter(
                      child: ChipPlaceholder(
                    count: 1,
                    height: 53.0,
                  )),
                  SliverListPlaceholder(height: 40.0, count: 10),
                  SliverToBoxAdapter(
                      child: Card(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child:
                        ClipRRect(borderRadius: BorderRadius.circular(5.0), child: ImageGallery()),
                  )),
                  SliverSectionView(title: 'מחזור הבא'),
                  FixturesPlaceholder(count: 1),
                ]));
          } else {
            var seasonState = state.store[state.currentSeason.id];
            return Container(
              color: Colors.grey[200],
              child: CustomScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  MainAppBar('ליגת האריה האדום', seasonState.season.name),
                  TableView(
                      scrollController: scrollController,
                      seasonId: state.currentSeason.id,
                      standingsList: seasonState.standingsResponse.list),
                  SliverToBoxAdapter(
                      child: Card(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child:
                        ClipRRect(borderRadius: BorderRadius.circular(5.0), child: ImageGallery()),
                  )),
                  SliverSectionView(title: 'מחזור הבא'),
                  SliverToBoxAdapter(child: FixturesWeekView(week: seasonState.nextWeek)),
                  SliverToBoxAdapter(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(children: [
                        Container(
                            margin: EdgeInsets.only(top: 20, bottom: 40),
                            child: Text('בחסות', style: Theme.of(context).textTheme.headline6)),
                        GridView.builder(
                          padding: EdgeInsets.only(top: 0, left: 15, right: 15),
                          shrinkWrap: true,
                          controller: scrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 40,
                            childAspectRatio: MediaQuery.of(context).size.width /
                                (MediaQuery.of(context).size.height / 3),
                          ),
                          itemBuilder: (context, index) {
                            final category = sponsors[index];
                            return Column(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text(category.name,
                                        style: Theme.of(context).textTheme.headline5)),
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: NetworkImage(category.logoURL),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: sponsors.length,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            '© Shlomo Ariel',
                            style: TextStyle(fontFamily: 'Montserrat-Medium'),
                            textDirection: TextDirection.ltr,
                          ),
                        )
                      ]),
                    ),
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
