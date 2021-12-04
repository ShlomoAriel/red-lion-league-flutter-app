import 'dart:convert';
import 'package:http/http.dart' as http;

import 'league_models.dart';

final baseUrl = 'domain.redlionleague.com';

final client = http.Client();

Future<List<Season>> getSeasons() async {
  final uri = Uri.http(baseUrl, '///api/Seasons');
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final seasons = (json as List).map((listingJson) => Season.fromJson(listingJson)).toList();
  seasons.sort((a, b) => b.priority!.compareTo(a.priority!));
  return seasons;
}

Future<ImageGalleryModel?> getGallery() async {
  final uri = Uri.https('user-management-template.herokuapp.com', '/api/findPublic/ImageGallery');
  final body = jsonEncode({
    'filter': {'name': 'Gallery'},
    'type': 'exactly'
  });
  final response = await client.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  final json = jsonDecode(response.body);
  final result = ImageGalleryResponse.fromJson(json);
  if (result.result.length > 0) {
    return result.result[0];
  }
  return null;
}

Future<List<Team>?> getTeamSpecs(List<String?> ids) async {
  final uri = Uri.https('user-management-template.herokuapp.com', '/api/findPublic/Team');
  final body = jsonEncode({
    'filter': {'id': ids},
    'type': 'exactly'
  });
  // final uri = Uri.https('user-management-template.herokuapp.com', '/api/getPublic/Team');
  final response = await client.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  final json = jsonDecode(response.body);
  final result = TeamSpecsResponse.fromJson(json);
  if (result.result!.length > 0) {
    return result.result;
  }
  return null;
}

Future<List<Sponsor>?> getSponsors() async {
  final uri = Uri.https('user-management-template.herokuapp.com', '/api/getPublic/Sponsor');
  // final uri = Uri.https('user-management-template.herokuapp.com', '/api/getPublic/Team');
  final response = await client.get(uri, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  final json = jsonDecode(response.body);
  final result = SponsorsResponse.fromJson(json);
  if (result.result!.length > 0) {
    return result.result;
  }
  return null;
}

Future<TeamPlayersResponse> getTeamSeasonPlayers(String? seasonId, String teamId) async {
  final body = jsonEncode(<String, String?>{'SeasonId': seasonId, 'teamId': teamId});
  final uri = Uri.http(baseUrl, '///api/Match/GetTeamSeasonPlayers');
  final response = await client.post(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  final json = jsonDecode(response.body);

  return TeamPlayersResponse.fromJson(json);
}

Future<StandingsResponse> getSeasonStandings(String? seasonId) async {
  final queryParameters = {'id': seasonId};
  final uri = Uri.http(baseUrl, '///api/Match/GetStandings', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  return StandingsResponse.fromJson(json);
}

Future<List<Match>> getSeasonMatches(String? seasonId) async {
  final queryParameters = {'seasonId': seasonId};
  final uri = Uri.http(baseUrl, '///api/Match/GetMatchesBySeason', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final matches = (json as List).map((listingJson) => Match.fromJson(listingJson)).toList();
  return matches;
}

Future<List<Week>> getSeasonWeeks(String? seasonId) async {
  final queryParameters = {'seasonId': seasonId};
  final uri = Uri.http(baseUrl, '///api/Match/GetWeeksBySeason', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final weeks = (json as List).map((listingJson) => Week.fromJson(listingJson)).toList();
  return weeks;
}

Future<List<Goal>> getSeasonGoals(String? seasonId) async {
  final queryParameters = {'seasonId': seasonId};
  final uri = Uri.http(baseUrl, '///api/Match/GetGoalsBySeason', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final weeks = (json as List).map((listingJson) => Goal.fromJson(listingJson)).toList();
  return weeks;
}

Future<List<Scorer>> getSeasonScorers(String? seasonId) async {
  final queryParameters = {'season': seasonId};
  final uri = Uri.http(baseUrl, '///api/Match/GetScorers', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final scorers = (json as List).map((listingJson) => Scorer.fromJson(listingJson)).toList();
  return scorers;
}

Future<List<Goal>> getGoals() async {
  final uri = Uri.http(baseUrl, '///api/Goal');
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final goals = (json as List).map((listingJson) => Goal.fromJson(listingJson)).toList();
  return goals;
}
