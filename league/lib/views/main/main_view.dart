import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/common/sliver_section_view.dart';
import 'package:league/views/fixtures/fixtures_view.dart';
import 'package:league/views/main/sponsors_view.dart';
import 'package:league/views/main/table_view.dart';
import 'package:shimmer/shimmer.dart';
import 'image_gallery_view.dart';
import 'package:league/views/main/shimmer_placeholders.dart';

class MainView extends StatelessWidget {
  final scrollController = ScrollController();
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
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      final cubit = BlocProvider.of<LeagueCubit>(context);
                      await cubit.createAndSetSeason(state.currentSeason);
                    },
                  ),
                  SliverToBoxAdapter(
                      child: ChipPlaceholder(
                    count: 1,
                    height: 58.0,
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
                  CupertinoSliverRefreshControl(
                    onRefresh: () async {
                      final cubit = BlocProvider.of<LeagueCubit>(context);
                      await cubit.createAndSetSeason(state.currentSeason);
                    },
                  ),
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
                  SliverToBoxAdapter(child: SponsorsView())
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MainView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 500,
        child: Shimmer.fromColors(
          baseColor: Colors.black,
          highlightColor: Colors.white,
          child: Image.asset("assets/images/LOGO CLEAN BACKGROUND2.png"),
          period: Duration(seconds: 2),
        ),
      ),
    );
  }
}
