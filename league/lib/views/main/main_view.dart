import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league/bloc/league/league_cubit.dart';
import 'package:league/bloc/league/league_state.dart';
import 'package:league/views/common/header_view.dart';
import 'package:league/views/common/sliver_section_view.dart';
import 'package:league/views/common/table_header_view.dart';
import 'package:league/views/fixtures/fixtures_view.dart';
import 'package:league/views/main/table_view.dart';
import 'image_gallery_view.dart';
import 'package:league/views/main/shimmer_placeholders.dart';

class MainView extends StatelessWidget {
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
                  MySliverAppBar('ליגת האריה האדום', 'seasonState.season.name'),
                  SliverListPlaceholder(height: 50.0, count: 10),
                  SliverGridPlaceholder(count: 4),
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
            return Container(
              color: Colors.grey[200],
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  MySliverAppBar('ליגת האריה האדום', seasonState.season.name),
                  SliverRow(tableRowColumns: columns),
                  TableView(
                      seasonId: state.currentSeason.id,
                      standingsList: seasonState.standingsResponse.list),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10),
                    sliver: SliverToBoxAdapter(child: ImageGallery()),
                  ),
                  SliverSectionView(title: 'מחזור הבא'),
                  SliverToBoxAdapter(child: FixturesWeekView(week: seasonState.nextWeek)),
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
