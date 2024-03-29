import 'dart:convert';
import 'package:http/http.dart' as http;

import 'league_models.dart';

final baseUrl = 'red-lion-league-backend.herokuapp.com';
// final baseUrl = 'localhost:3001';

final client = http.Client();

Future<List<Season>> getSeasons() async {
  final uri = Uri.https(baseUrl, '/api/getPublic/Season');
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final seasonResponse = SeasoneResponse.fromJson(json);
  final seasons = seasonResponse.entities ?? [];
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
    'filter': {'_id': ids},
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
  final queryParameters = {'seasonId': seasonId, 'teamId': teamId};
  final uri = Uri.https(baseUrl, '/api/GetTeamSeasonPlayers', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  return TeamPlayersResponse.fromJson(json);
}

Future<StandingsResponse> getSeasonStandings(String? seasonId) async {
  final uri = Uri.https(baseUrl, '/api/getStandings/' + seasonId.toString());
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  return StandingsResponse.fromJson(json);
}

Future<List<Match>> getSeasonMatches(String? seasonId) async {
  final queryParameters = {'seasonId': seasonId};
  final uri = Uri.https(baseUrl, '/api/GetSeasonMatches', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final matches =
      (json['result'] as List).map((listingJson) => Match.fromJson(listingJson)).toList();
  return matches;
}

Future<List<Match>> getMatcheHistory(String team1, String team2) async {
  final queryParameters = {'team1': team1, 'team2': team2};
  final uri = Uri.https(baseUrl, '/api/GetMatcHistory', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final matches =
      (json['result'] as List).map((listingJson) => Match.fromJson(listingJson)).toList();
  return matches;
}

Future<List<Week>> getSeasonWeeks(String? seasonId) async {
  final uri = Uri.https(baseUrl, '/api/GetSeasonWeeks/' + seasonId.toString());
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final weeks = (json['result'] as List).map((listingJson) => Week.fromJson(listingJson)).toList();
  return weeks;
}

Future<List<Goal>> getSeasonGoals(String? seasonId) async {
  final uri = Uri.https(baseUrl, '/api/GetSeasonGoals/' + seasonId.toString());
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final goals = (json['result'] as List).map((listingJson) {
    return Goal.fromJson(listingJson);
  }).toList();
  return goals;
}

Future<List<Scorer>> getSeasonScorers(String? seasonId) async {
  final queryParameters = {'seasonId': seasonId};
  final uri = Uri.https(baseUrl, '/api/getScorers', queryParameters);
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final scorers =
      (json['result'] as List).map((listingJson) => Scorer.fromJson(listingJson)).toList();
  return scorers;
}

Future<List<Goal>> getGoals() async {
  final uri = Uri.https(baseUrl, '/api/Goal');
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  final goals = (json as List).map((listingJson) {
    return Goal.fromJson(listingJson);
  }).toList();
  return goals;
}
