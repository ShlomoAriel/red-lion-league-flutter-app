import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:league/bloc/client/client_list_state.dart';

final baseUrl = '2cc2f67f-e3ad-4729-ba68-88fbfe6f4cae.mock.pstmn.io';
final client = http.Client();

Future<ClientListState> getClientList() async {
  final uri = Uri.http(baseUrl, '/clientLists');
  final response = await client.get(uri);
  final json = jsonDecode(response.body);
  return ClientListState.fromJson(json);
}
