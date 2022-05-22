import 'dart:convert';

class Snooker {
  final String winner;
  final String loser;
  final int diff;
  final int red;
  final String date;
  final int id;

  const Snooker({
    required this.winner,
    required this.loser,
    required this.diff,
    required this.red,
    required this.date,
    required this.id,
  });

  const Snooker.simple(String winner, String loser, int diff, int red)
  : this(
    winner: winner,
    loser: loser,
    diff: diff,
    red: red,
    date: "",
    id: 0,
  );

  factory Snooker.fromJson(Map<String, dynamic> json) {
    return Snooker(
      winner: json['winner'],
      loser: json['loser'],
      diff: json['diff'],
      red: json['red'],
      date: json['date'],
      id: json['id'],
    );
  }
}
