import 'league_models.dart';

class LeagueState {
  bool? isLoading;
  Season? currentSeason;
  Match? selectedMatch;
  String? selectedTeam;
  List<Season>? seasons;
  List<Goal>? goals;
  Map<String?, SeasonState>? store;

  LeagueState({this.isLoading, this.currentSeason, this.seasons, this.goals, this.store});

  LeagueState.from(LeagueState state) {
    this.currentSeason = state.currentSeason;
    this.isLoading = state.isLoading;
    this.seasons = state.seasons;
    this.goals = state.goals;
    this.store = state.store;
    this.selectedTeam = state.selectedTeam;
    this.selectedMatch = state.selectedMatch;
  }
}
