import 'package:flutter_bloc/flutter_bloc.dart';
import 'league_models.dart';
import 'league_repository.dart';
import 'league_state.dart';

class LeagueCubit extends Cubit<LeagueState> {
  LeagueCubit()
      : super(LeagueState(
          isLoading: true,
          store: new Map<String, SeasonState>(),
          seasons: new List.empty(),
        ));

  void init() async {
    var seasons = await getSeasons();
    var goals = await getGoals();
    LeagueState preState =
        new LeagueState(seasons: seasons, goals: goals, isLoading: true);
    emit(preState);
    var store = new Map<String, SeasonState>();
    for (var season in seasons) {
      store[season.id] = new SeasonState();
    }

    var currentSeason =
        seasons != null && seasons.length > 0 ? seasons[0].id : '2014';
    SeasonState seasonState = await createSeasonState(currentSeason);
    store[currentSeason] = seasonState;
    LeagueState leagueState = new LeagueState(
        currentSeason: currentSeason,
        store: store,
        seasons: seasons,
        isLoading: false);

    emit(leagueState);
  }

  // Create a season state for the store
  Future<SeasonState> createSeasonState(String seasonId) async {
    var seasonCalls = await Future.wait([
      getSeasonStandings(seasonId),
      getSeasonMatches(seasonId),
      getSeasonWeeks(seasonId),
      getSeasonScorers(seasonId),
      getSeasonGoals(seasonId)
    ]);
    var standings = seasonCalls[0]; //await getSeasonStandings(seasonId);
    var matches = seasonCalls[1]; //await getSeasonMatches(seasonId);
    var weeks = seasonCalls[2]; //await getSeasonWeeks(seasonId);
    var scorers = seasonCalls[3]; //await getSeasonScorers(seasonId);
    var seasonGoals = seasonCalls[4]; //await getSeasonScorers(seasonId);
    // var goals = await getSeasonGoals(seasonId);
    var season = state.seasons.firstWhere((element) => element.id == seasonId);
    var seasonState = new SeasonState(
        season: season,
        matches: matches,
        scorers: scorers,
        goals: seasonGoals,
        teamsMap: new Map<String, Team>(),
        standingsResponse: standings,
        weeks: weeks);
    seasonState.refreshed = DateTime.now();
    return seasonState;
  }

  void setSeason(String seasonId) async {
    // Check if season exists in store
    if (state.store[seasonId].refreshed != null) {
      LeagueState tempState = new LeagueState.from(state);
      tempState.currentSeason = seasonId;
      emit(tempState);
      return;
    }
    // Update selected season loading
    LeagueState tempState = new LeagueState.from(state);
    tempState.isLoading = true;
    tempState.currentSeason = seasonId;
    emit(tempState);
    // Download and set season
    SeasonState seasonState = await createSeasonState(seasonId);
    LeagueState leagueState = new LeagueState.from(state);
    leagueState.store[seasonId] = seasonState;
    leagueState.currentSeason = seasonId;
    leagueState.isLoading = false;
    emit(leagueState);
  }

  void setTeamSeasonPlayers(String seasonId, String teamId) async {
    var tempState = new LeagueState.from(state);
    tempState.isLoading = true;
    emit(tempState);
    TeamPlayersResponse response = await getTeamSeasonPlayers(seasonId, teamId);
    var team = new Team();
    if (state.store[state.currentSeason].teamsMap[teamId] != null) {
      team = Team.from(state.store[state.currentSeason].teamsMap[teamId]);
    }
    var newState = new LeagueState.from(state);
    team.seasonPlayers = response.list;
    newState.selectedTeam = team.id;
    newState.store[state.currentSeason].teamsMap[teamId] = team;
    newState.isLoading = false;
    emit(newState);
  }
}
