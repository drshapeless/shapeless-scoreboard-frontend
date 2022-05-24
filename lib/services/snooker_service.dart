import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/snookers.dart';
import 'globals.dart' as globals;

Future<Snooker> createSnooker(
  String pass, String winner, String loser, int diff, int red) async {
  final response = await http.post(
    Uri.parse('${globals.apiBaseURL}/snooker/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'pass': pass,
      'winner': winner,
      'loser': loser,
      'diff': diff,
      'red': red,
  }),
);

if (response.statusCode == 201) {
  return Snooker.fromJson(jsonDecode(response.body)['snooker']);
} else {
  var err = jsonDecode(response.body)['error'];
  throw Exception(err);
}
}

Future<List<Snooker>> getSnookers(int page) async {
  final response =
  await http.get(Uri.parse("${globals.apiBaseURL}/snooker/$page"));

  if (response.statusCode == 200) {
    List<dynamic> lss = json.decode(response.body)['snookers'];
    List<Snooker> lsno = [];
    for (dynamic i in lss) {
      lsno.add(Snooker.fromJson(i));
    }
    return lsno;
  } else {
    var err = jsonDecode(response.body)['error'];
    throw Exception(err);
  }
}
