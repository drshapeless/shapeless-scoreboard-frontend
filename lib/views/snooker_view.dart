import 'package:flutter/material.dart';
import 'package:flutter_scoreboard/main.dart';

import '../models/snookers.dart';

class SnookerApp extends StatelessWidget {
  const SnookerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Snooker",
      theme: ThemeData.dark(),
      home: const SnookerHome(),
    );
  }
}

class SnookerHome extends StatefulWidget {
  const SnookerHome({Key? key}) : super(key: key);

  @override
  State<SnookerUploadHome> createState() => _SnookerHomeState();
}

class _SnookerHomeState extends State<SnookerUploadHome> {
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _passController,
          )
        ],
      ),
    );
  }
}
