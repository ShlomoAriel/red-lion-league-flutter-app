import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class SeasonState {
  Week nextWeek;
  Season season;
  DateTime refreshed;
  StandingsResponse standingsResponse;
  List<Match> matches;
  List<Scorer> scorers;
  List<Week> weeks;
  List<Goal> goals;
  Map<String, Team> teamsMap;

  SeasonState(
      {this.season,
      this.matches,
      this.weeks,
      this.scorers,
      this.goals,
      this.standingsResponse,
      this.teamsMap}) {
    if (standingsResponse != null) {
      for (var standing in standingsResponse.list) {
        teamsMap[standing.id] = new Team.fromStanding(standing);
      }
    }
    if (weeks != null) {
      for (var week in weeks) {
        week.matches =
            matches.where((element) => element.weekId == week.id).toList();
        // week.fixtures =
        var t = groupBy(week.matches, (Match obj) {
          return DateFormat('yyyy-MM-dd').format(obj.date);
        });
        week.fixtures = t;
      }
      if (this.season.nextWeek != null && this.season.nextWeek != '0') {
        this.nextWeek =
            weeks.firstWhere((element) => element.id == this.season.nextWeek);
      } else {
        this.nextWeek = weeks[0];
      }
    }
  }
  SeasonState.from(SeasonState season) {
    this.season = season.season;
    this.matches = season.matches;
    this.scorers = season.scorers;
    this.goals = season.goals;
    this.teamsMap = season.teamsMap;
    this.weeks = season.weeks;
    this.standingsResponse = season.standingsResponse;
  }
}

class TeamPlayersResponse {
  TeamPlayersResponse({this.list});

  List<Player> list;

  factory TeamPlayersResponse.fromJson(List<dynamic> json) {
    if (json is List) {
      final objectList = json.cast<Map<String, dynamic>>();
      final tableLines = objectList.map((e) => Player.fromJson(e));

      return TeamPlayersResponse(list: tableLines.toList());
    } else {
      throw Exception('No table in response');
    }
  }
}

class Goal {
  Goal(
      {this.id,
      this.matchId,
      this.playerId,
      this.seasonId,
      this.weekId,
      this.match,
      this.player});

  String id;
  String matchId;
  String playerId;
  String seasonId;
  String weekId;
  Player player;
  Match match;

  Goal.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.matchId = json['matchId'];
    this.playerId = json['playerId'] != null ? json['Goals'].toString() : '0';
    this.seasonId = json['seasonId'];
    this.weekId = json['Match']['weekId'];
    this.player = Player.fromJson(json['Player']);
    this.match = Match.fromJson(json['Match']);
  }
}

class Player {
  Player({this.id, this.name, this.goals, this.position});

  String id;
  String name;
  String goals;
  String position;

  Player.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.goals = json['Goals'] != null ? json['Goals'].toString() : '0';
    this.position = json['Position']['Name'];
  }
}

class StandingsResponse {
  StandingsResponse({this.list});

  List<TableLine> list;

  factory StandingsResponse.fromJson(List<dynamic> json) {
    if (json is List) {
      final objectList = json.cast<Map<String, dynamic>>();
      final tableLines = objectList.map((e) => TableLine.fromJson(e));

      return StandingsResponse(list: tableLines.toList());
    } else {
      throw Exception('No table in response');
    }
  }
}

class TableLine {
  TableLine(
      {this.id,
      this.name,
      this.position,
      this.goalsFor,
      this.goalsAgainst,
      this.goalsDifference,
      this.points,
      this.games,
      this.wins,
      this.draws,
      this.losses});

  String id;
  String name;
  List<MatchForm> matchForm;
  int position;
  int goalsFor;
  int goalsAgainst;
  int goalsDifference;
  int points;
  int games;
  int wins;
  int draws;
  int losses;

  TableLine.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.position = json['Position'];
    this.goalsFor = json['GoalsFor'];
    this.matchForm = (json['MatchForm'] as List)
        .map((matchForm) => new MatchForm.fromJson(matchForm))
        .toList();
    this.goalsAgainst = json['GoalsAgainst'];
    this.goalsDifference = json['GoalsDifference'];
    this.points = json['Points'];
    this.games = json['Games'];
    this.wins = json['Wins'];
    this.draws = json['Draws'];
    this.losses = json['Losses'];
  }
}

class MatchForm {
  MatchForm(
      {this.id,
      this.name,
      this.goalsAgainst,
      this.goalsFor,
      this.result,
      this.resultClass});

  String id;
  String name;
  int goalsAgainst;
  int goalsFor;
  String result;
  String resultClass;

  MatchForm.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.goalsAgainst = json['GoalsAgainst'];
    this.goalsFor = json['GoalsFor'];
    this.result = json['Result'];
    this.resultClass = json['ResultClass'];
  }
}

class Season {
  Season({this.id, this.name, this.nextWeek, this.priority, this.hasTable});

  String id;
  String name;
  String nextWeek;
  int priority;
  bool hasTable;

  Season.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.nextWeek = json['NextWeek'].toString();
    this.priority = json['Priority'];
    this.hasTable = json['HasTable'];
  }
}

class Week {
  Week({this.id, this.name, this.seasonId});

  String id;
  String name;
  int seasonId;
  List<Match> matches;
  Map<String, List<Match>> fixtures;

  Week.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Number'];
    this.seasonId = json['SeasonId'];
  }
}

class Scorer {
  Scorer({this.id, this.name, this.goals, this.teamName, this.teamId});

  String id;
  String name;
  int goals;
  String teamName;
  String teamId;

  Scorer.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.goals = json['Goals'];
    this.teamName = json['Team']['Name'];
    this.teamId = json['TeamId'].toString();
  }
}

class Match {
  Match(
      {this.id,
      this.name,
      this.awayGoals,
      this.awayId,
      this.awayName,
      this.date,
      this.homeGoals,
      this.homeId,
      this.homeName,
      this.played,
      this.seasonId,
      this.time,
      this.weekId,
      this.weekName});

  String id;
  String name;
  int awayGoals;
  String awayName;
  String awayId;
  int homeGoals;
  String homeName;
  String homeId;
  DateTime date;
  bool played;
  String seasonId;
  String time;
  String weekId;
  String weekName;

  Match.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.awayGoals = json['AwayGoals'];
    this.awayName = json['Away']['Name'];
    this.awayId = json['AwayId'].toString();
    this.homeGoals = json['HomeGoals'];
    this.homeName = json['Home']['Name'];
    this.homeId = json['HomeId'].toString();
    this.date = DateTime.parse(json['Date']);
    this.played = json['Played'];
    this.seasonId = json['SeasonId'].toString();
    this.time = json['Time'];
    this.weekId = json['WeekId'].toString();
    this.weekName = json['WeekName'];
  }
}

class Team {
  Team(
      {this.id,
      this.name,
      this.matchForm,
      this.allPlayers,
      this.seasonPlayers});

  String id;
  String name;
  List<MatchForm> matchForm;
  List<Player> allPlayers;
  List<Player> seasonPlayers;

  Team.from(Team team) {
    this.id = team.id;
    this.name = team.name;
    this.matchForm = team.matchForm;
    this.allPlayers = team.allPlayers;
    this.seasonPlayers = team.seasonPlayers;
  }

  Team.fromStanding(TableLine team) {
    this.id = team.id;
    this.name = team.name;
    this.matchForm = team.matchForm;
    this.allPlayers = List.empty();
    this.seasonPlayers = List.empty();
  }
}
