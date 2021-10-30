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
    // var goals = await getGoals();
    var store = new Map<String, SeasonState>();
    for (var season in seasons) {
      store[season.id] = new SeasonState(season: season);
    }
    var currentSeason =
        seasons != null && seasons.length > 0 ? seasons[0] : Season(id: '2014', name: 'טמפ');

    LeagueState preState = new LeagueState(
        seasons: seasons,
        // goals: goals,
        store: store,
        isLoading: true,
        currentSeason: currentSeason);
    emit(preState);

    SeasonState seasonState = await createSeasonState(currentSeason.id);
    store[currentSeason.id] = seasonState;
    LeagueState leagueState = new LeagueState(
        currentSeason: currentSeason, store: store, seasons: seasons, isLoading: false);

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
    StandingsResponse standingsResponse = seasonCalls[0]; //await getSeasonStandings(seasonId);
    var matches = seasonCalls[1]; //await getSeasonMatches(seasonId);
    var weeks = seasonCalls[2]; //await getSeasonWeeks(seasonId);
    var scorers = seasonCalls[3]; //await getSeasonScorers(seasonId);
    var seasonGoals = seasonCalls[4]; //await getSeasonScorers(seasonId);
    // var goals = await getSeasonGoals(seasonId);
    var season = state.seasons.firstWhere((element) => element.id == seasonId);
    List<String> teamIds = [];
    for (var standing in standingsResponse.list) {
      teamIds.add(standing.id);
    }
    Map<String, Team> teamsMap = new Map<String, Team>();
    for (var standing in standingsResponse.list) {
      Team standingTeam = new Team.fromStanding(standing);
      teamsMap[standing.id] = standingTeam;
    }
    List<Team> teamsSpecs = await getTeamSpecs(teamIds);
    for (var teamSpec in teamsSpecs) {
      teamsMap[teamSpec.id].colorHEX = teamSpec.colorHEX;
      teamsMap[teamSpec.id].logoURL = teamSpec.logoURL;
    }
    for (var standing in standingsResponse.list) {
      standing.logoURL = teamsMap[standing.id].logoURL ?? '';
    }
    var seasonState = new SeasonState(
        season: season,
        matches: matches,
        scorers: scorers,
        goals: seasonGoals,
        teamsMap: teamsMap,
        standingsResponse: standingsResponse,
        weeks: weeks);
    seasonState.refreshed = DateTime.now();
    return seasonState;
  }

  void setSeason(Season season) async {
    // Check if season exists in store
    if (state.store[season.id].refreshed != null) {
      LeagueState tempState = new LeagueState.from(state);
      tempState.currentSeason = season;
      emit(tempState);
      return;
    }
    // Update selected season loading
    LeagueState tempState = new LeagueState.from(state);
    tempState.isLoading = true;
    tempState.currentSeason = season;
    emit(tempState);
    // Download and set season
    SeasonState seasonState = await createSeasonState(season.id);
    LeagueState leagueState = new LeagueState.from(state);
    leagueState.store[season.id] = seasonState;
    leagueState.currentSeason = season;
    leagueState.isLoading = false;
    emit(leagueState);
  }

  void setTeamSeasonPlayers(String seasonId, String teamId) async {
    var tempState = new LeagueState.from(state);
    tempState.isLoading = true;
    emit(tempState);
    TeamPlayersResponse response = await getTeamSeasonPlayers(seasonId, teamId);
    var team = new Team();
    if (state.store[state.currentSeason.id].teamsMap[teamId] != null) {
      team = Team.from(state.store[state.currentSeason.id].teamsMap[teamId]);
    }
    var newState = new LeagueState.from(state);
    team.seasonPlayers = response.list;
    newState.selectedTeam = team.id;
    newState.store[state.currentSeason.id].teamsMap[teamId] = team;
    newState.isLoading = false;
    emit(newState);
  }

  void setWeeksTeam(Team team) {
    LeagueState leagueState = new LeagueState.from(state);
    leagueState.store[state.currentSeason.id].weeksWeek = null;
    leagueState.store[leagueState.currentSeason.id].filteredWeeks =
        state.store[leagueState.currentSeason.id].weeks.map((e) => Week.clone(e)).toList();
    if (team == leagueState.store[state.currentSeason.id].weeksTeam || team.id == '-1') {
      leagueState.store[state.currentSeason.id].weeksTeam = null;
    } else {
      leagueState.store[state.currentSeason.id].weeksTeam = team;
      for (Week week in leagueState.store[leagueState.currentSeason.id].filteredWeeks) {
        var filteredMatches = new Map<String, List<Match>>();
        week.fixtures.forEach((key, value) {
          for (var item in value) {
            if (item.awayId == leagueState.store[state.currentSeason.id].weeksTeam.id ||
                item.homeId == leagueState.store[state.currentSeason.id].weeksTeam.id) {
              filteredMatches[key] = [item];
              break;
            }
          }
        });
        week.fixtures = filteredMatches;
      }
    }
    emit(leagueState);
  }

  void setWeeksWeek(Week week) {
    LeagueState leagueState = new LeagueState.from(state);

    var seasonState = state.store[state.currentSeason.id];
    leagueState.store[state.currentSeason.id].weeksWeek = week;
    leagueState.store[state.currentSeason.id].weeksTeam = null;
    if (week.id == '-1') {
      leagueState.store[state.currentSeason.id].weeksWeek = null;
      leagueState.store[leagueState.currentSeason.id].filteredWeeks =
          state.store[leagueState.currentSeason.id].weeks.toList();
    } else {
      leagueState.store[leagueState.currentSeason.id].filteredWeeks = state
          .store[leagueState.currentSeason.id].weeks
          .where((element) => element.id == seasonState.weeksWeek.id)
          .toList();
    }
    emit(leagueState);
  }
}
