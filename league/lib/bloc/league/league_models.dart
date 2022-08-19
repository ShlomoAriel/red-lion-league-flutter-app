import 'dart:ui';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SeasonState {
  Week? nextWeek;
  Season? season;
  DateTime? refreshed;
  StandingsResponse? standingsResponse;
  List<Match>? matches;
  List<Scorer>? scorers;
  List<Week>? weeks;
  List<Week>? filteredWeeks;
  List<Goal>? goals;
  Map<String?, Team>? teamsMap;
  List<Stat>? stats;
  Team? weeksTeam;
  Week? weeksWeek;

  SeasonState(
      {this.season,
      this.matches,
      this.weeks,
      this.scorers,
      this.goals,
      this.standingsResponse,
      this.teamsMap}) {
    weeksTeam = null;
    weeksWeek = null;
    if (standingsResponse != null) {
      // for (var standing in standingsResponse.list) {
      //   Team standingTeam = new Team.fromStanding(standing);
      //   standingTeam =
      //   teamsMap[standing.id] =
      // }
      var mostWins = standingsResponse!.list!.reduce((a, b) => a.wins! > b.wins! ? a : b);
      var mostGoals = standingsResponse!.list!.reduce((a, b) => a.goalsFor! > b.goalsFor! ? a : b);
      var leastGoals =
          standingsResponse!.list!.reduce((a, b) => a.goalsAgainst! < b.goalsAgainst! ? a : b);
      var goalDifference = standingsResponse!.list!
          .reduce((a, b) => a.goalsDifference! > b.goalsDifference! ? a : b);
      var draws = standingsResponse!.list!.reduce((a, b) => a.draws! > b.draws! ? a : b);
      var losses = standingsResponse!.list!.reduce((a, b) => a.losses! > b.losses! ? a : b);
      this.stats = [
        Stat('נצחונות', mostWins.id, mostWins.wins),
        Stat('שערים', mostGoals.id, mostGoals.goalsFor),
        Stat('ספיגות', leastGoals.id, leastGoals.goalsAgainst),
        Stat('תיקו', draws.id, draws.draws),
        Stat('הפסדים', losses.id, losses.losses),
        Stat('הפרש שערים', goalDifference.id, goalDifference.goalsDifference)
      ];
    }
    if (weeks != null) {
      initializeDateFormatting();
      for (var week in weeks!) {
        week.matches = matches!.where((element) => element.weekId == week.id).toList();
        // week.fixtures =

        var t = groupBy(week.matches!, (Match obj) {
          return DateFormat('EEEE dd MMMM yyyy', 'HE').format(obj.date!);
        });
        week.fixtures = t;
      }
      filteredWeeks = weeks;
      if (this.nextWeek != null && this.season!.nextWeek != '0') {
        this.nextWeek = weeks!.firstWhere((element) => element.id == this.season!.nextWeek);
      } else {
        this.nextWeek = weeks![0];
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
    this.weeksTeam = season.weeksTeam;
    this.weeksWeek = season.weeksWeek;
    this.nextWeek = season.nextWeek;
    this.refreshed = season.refreshed;
    this.stats = season.stats;
  }
}

class TeamPlayersResponse {
  TeamPlayersResponse({this.list});

  List<Player>? list;

  factory TeamPlayersResponse.fromJson(List<dynamic>? json) {
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
  Goal({this.id, this.matchId, this.playerId, this.seasonId, this.weekId, this.match, this.player});

  String? id;
  String? matchId;
  String? playerId;
  String? seasonId;
  String? weekId;
  String? teamId;
  Player? player;
  Match? match;

  Goal.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'].toString();
    this.matchId = json['match']['_id'].toString();
    this.playerId = json['player']['_id'].toString();
    this.seasonId = json['season'].toString();
    this.weekId = json['match']['_id'].toString();
    this.player = Player.fromJson(json['player']);
    this.teamId = json['player']['team'].toString();
    // this.match = Match.fromJson(json['match']);
  }
}

class Player {
  Player({this.id, this.name, this.goals, this.position});

  String? id;
  String? name;
  String? goals;
  String? teamId;
  String? position;

  Player.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'].toString();
    this.name = json['name'];
    this.goals = json['goals'] != null ? json['goals'].toString() : '0';
    this.position = json['positionName'];
    this.teamId = json['team'].toString();
  }
}

class ImageGalleryResponse {
  late List<ImageGalleryModel> result;

  ImageGalleryResponse.fromJson(Map<String, dynamic> json) {
    this.result = (json['result'] as List)
        .map((imageGalleryJson) => new ImageGalleryModel.fromJson(imageGalleryJson))
        .toList();
  }
}

class TeamSpecsResponse {
  List<Team>? result;

  TeamSpecsResponse.fromJson(Map<String, dynamic> json) {
    this.result = (json['result'] as List)
        .map((imageGalleryJson) => new Team.fromJson(imageGalleryJson))
        .toList();
  }
}

class SponsorsResponse {
  List<Sponsor>? result;

  SponsorsResponse.fromJson(Map<String, dynamic> json) {
    this.result =
        (json['result'] as List).map((sponsorsJson) => new Sponsor.fromJson(sponsorsJson)).toList();
  }
}

class ImageGalleryModel {
  List<String>? imageURLs;
  String? name;

  ImageGalleryModel({this.imageURLs, this.name});

  ImageGalleryModel.fromJson(Map<String, dynamic> json) {
    this.imageURLs = json['images'].cast<String>();
    this.name = json['Name'];
  }
}

class StandingsResponse {
  StandingsResponse({this.list});

  List<TableLine>? list;

  factory StandingsResponse.fromJson(List<dynamic>? json) {
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

  String? id;
  String? name;
  String? colorHEXPrimary;
  List<MatchForm>? matchForm;
  int? position;
  int? goalsFor;
  int? goalsAgainst;
  late double goalsAgainstAverage;
  late double goalsFortAverage;
  int? goalsDifference;
  int? points;
  int? games;
  int? wins;
  int? draws;
  int? losses;
  late String logoURL;

  TableLine.fromJson(Map<String, dynamic> json) {
    this.id = json['teamId'];
    this.name = json['teamName'];
    this.logoURL = json['logoURL'] ?? "";
    this.colorHEXPrimary = json['colorHEXPrimary'];
    this.position = json['position'];
    this.goalsFor = json['goalsFor'];
    this.matchForm = []; //
    // (json['matchForm'] as List).map((matchForm) => new MatchForm.fromJson(matchForm)).toList();
    this.goalsAgainst = json['goalsAgainst'];
    this.goalsDifference = json['goalsDifference'];
    this.games = json['games'];
    this.goalsFortAverage = (this.goalsFor! / this.games!);
    this.goalsAgainstAverage = (this.goalsAgainst! / this.games!);
    this.points = json['points'];
    this.wins = json['wins'];
    this.draws = json['draws'];
    this.losses = json['losses'];
  }
}

class MatchForm {
  MatchForm({this.id, this.name, this.goalsAgainst, this.goalsFor, this.result, this.resultClass});

  String? id;
  String? name;
  int? goalsAgainst;
  int? goalsFor;
  String? result;
  Color? resultColor;
  String? resultClass;
  String? resultText;

  MatchForm.fromJson(Map<String, dynamic> json) {
    this.id = json['Id'].toString();
    this.name = json['Name'];
    this.goalsAgainst = json['GoalsAgainst'];
    this.goalsFor = json['GoalsFor'];
    this.result = json['Result'];
    this.resultText = formTextMap[json['ResultClass'].toString()];
    this.resultClass = json['ResultClass'];
    this.resultColor = formColorMap[json['ResultClass'].toString()];
  }
  static var formColorMap = {
    'win': Color(0xff92C47D),
    'draw': Color(0xff6D9EEB),
    'loss': Color(0xffE06666),
  };
  var formTextMap = {
    'win': 'W',
    'draw': 'D',
    'loss': 'L',
  };
}

class SeasoneResponse {
  List<Season>? entities;

  // SeasoneResponse.fromJson(Map<String, dynamic> json) {
  //   this.entities =
  //       (json['entities'] as List).map((seasonJson) => new Season.fromJson(seasonJson)).toList();
  // }
  SeasoneResponse.fromJson(List<dynamic> json) {
    this.entities = json.map((seasonJson) => new Season.fromJson(seasonJson)).toList();
  }
}

class Season {
  Season({this.id, this.name, this.nextWeek, this.priority, this.hasTable});

  String? id;
  String? name;
  String? nextWeek;
  int? priority;
  int? hasTable;

  Season.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'].toString();
    this.name = json['name'];
    this.nextWeek = json['nextWeek'].toString();
    this.priority = json['priority'];
    this.hasTable = json['hasTable'];
  }
}

class Week {
  Week({this.id, this.name, this.seasonId});

  String? id;
  String? name;
  String? seasonId;
  List<Match>? matches;
  Map<String, List<Match>>? fixtures;

  Week.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'].toString();
    this.name = json['name'].toString();
    this.seasonId = json['season'];
  }

  Week.clone(Week week) {
    id = week.id;
    name = week.name;
    seasonId = week.seasonId;
    matches = week.matches;
    fixtures = week.fixtures;
  }

  getWeekFixtures() {
    var t = groupBy(this.matches!, (Match obj) {
      return DateFormat('yyyy-MM-dd').format(obj.date!);
    });
    this.fixtures = t;
  }
}

class Scorer {
  Scorer({this.id, this.name, this.goals, this.teamName, this.teamId});

  String? id;
  String? name;
  int? goals;
  String? teamName;
  String? teamId;

  Scorer.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'].toString();
    this.name = json['player']['name'];
    this.goals = json['goals'];
    this.teamName = ''; //json['Team']['Name'];
    this.teamId = json['team']['_id'];
  }
}

class Match {
  Match(
      {this.id,
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

  String? id;
  int? awayGoals;
  String? awayName;
  String? awayId;
  int? homeGoals;
  String? homeName;
  String? homeId;
  DateTime? date;
  bool? played;
  String? seasonId;
  String? time;
  String? weekId;
  String? weekName;

  Match.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'].toString();
    this.awayGoals = json['awayGoals'];
    this.awayName = json['awayTeam']['name'];
    this.awayId = json['awayTeam']['_id'];
    this.homeGoals = json['homeGoals'];
    this.homeName = json['homeTeam']['name'];
    this.homeId = json['homeTeam']['_id'];
    this.date = DateTime.parse(json['date']);
    this.played = json['played'];
    this.seasonId = json['season']['_id'];
    this.time = json['time'];
    this.weekId = json['week'];
    this.weekName = json['season']['name'];
  }
}

class Team {
  Team({this.id, this.name, this.matchForm, this.allPlayers, this.seasonPlayers});

  String? id;
  String? mongooseId;
  String? name;
  String? logoURL;
  String? colorHEX;
  TableLine? standing;
  List<MatchForm>? matchForm;
  List<Player>? allPlayers;
  List<Player>? seasonPlayers;

  Team.from(Team team) {
    this.id = team.id;
    this.name = team.name;
    this.matchForm = team.matchForm;
    this.standing = team.standing;
    this.allPlayers = team.allPlayers;
    this.seasonPlayers = team.seasonPlayers;
    this.colorHEX = team.colorHEX;
    this.logoURL = team.logoURL;
  }

  Team.fromStanding(TableLine team) {
    this.id = team.id;
    this.name = team.name;
    this.matchForm = team.matchForm;
    this.standing = team;
    this.allPlayers = List.empty();
    this.seasonPlayers = List.empty();
    this.logoURL = team.logoURL;
    this.colorHEX = team.colorHEXPrimary;
  }

  Team.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.mongooseId = json['_id'];
    this.name = json['name'];
    this.logoURL = json['logoURL'];
    this.colorHEX = json['colorHEXPrimary'];
  }
}

class Stat {
  final title;
  final teamId;
  final value;

  Stat(this.title, this.teamId, this.value);
}

class Sponsor {
  String? id;
  String? name;
  String? imageURL;

  Sponsor(this.id, this.name, this.imageURL);

  Sponsor.fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.name = json['name'];
    this.imageURL = json['imageURL'];
  }
}
