import 'package:flutter/material.dart';
import 'package:flutter_scoreboard/viewmodels/snooker_viewmodel.dart';

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
  State<SnookerHome> createState() => _SnookerHomeState();
}

class _SnookerHomeState extends State<SnookerHome> {
  final _passController = TextEditingController();
  final _usernameController1 = TextEditingController();
  final _usernameController2 = TextEditingController();

  final List<MaterialColor> _ballColors = List.filled(16, Colors.pink);

  bool isRed = true;

  SnookerViewModel vm = SnookerViewModel();

  List<Snooker> history = [];

  void displayMessenge(String m) {
    final snackbar = SnackBar(
      content: Text(m),
    );
  }

  void loadHistory() {
    vm.getResult(1).then((result) {
      setState(() => history = result);
      print("loaded");
      // displayMessenge("success loading");
  }).catchError((e) {
      print(e);
      // displayMessenge(e.toString());
  });
}

@override
void initState() {
  super.initState();
  for (int i = 0; i < 8; i++) {
    _ballColors[i] = Colors.red;
  }
  for (int i = 8; i < 16; i++) {
    _ballColors[i] = Colors.yellow;
  }

  vm.getResult(1).then((result) {
      setState(() => history = result);
  });
}

@override
Widget build(BuildContext context) {
  return ScaffoldMessenger(
    child: Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _passController,
            decoration: const InputDecoration(
              labelText: "Pass",
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          _buildPlayerTextfields(),
          _buildRedSwitch(),
          Padding(
            padding: EdgeInsets.only(right: 40),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBalls8(true, constraints.maxWidth),
                    _buildBalls8(false, constraints.maxWidth),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          // debug(),
          Expanded(
            child: _buildHistoryList(),
          ),
          const Divider(),
          _buildReloadButton(),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          )
        ],
      ),
    ),
  );
}

ElevatedButton _buildReloadButton() {
  return ElevatedButton(
    onPressed: () {
      loadHistory();
    },
    child: const Text("reload"),
  );
}

ElevatedButton debug() {
  return ElevatedButton(
    onPressed: () {
      loadHistory();
    },
    child: const Text("debug"),
  );
}

Row _buildPlayerTextfields() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: _buildPlayerTextfield1(_usernameController1, "Player 1"),
      ),
      Expanded(
        child: _buildPlayerTextfield1(_usernameController2, "Player 2"),
      ),
    ],
  );
}

TextField _buildPlayerTextfield1(TextEditingController con, String label) {
  return TextField(
    controller: con,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.person),
    ),
  );
}

Switch _buildRedSwitch() {
  return Switch(
    value: isRed,
    onChanged: (value) {
      setState(() {
          isRed = value;
          if (isRed) {
            for (int i = 0; i < 8; i++) {
              _ballColors[i] = Colors.red;
            }
            for (int i = 8; i < 16; i++) {
              _ballColors[i] = Colors.yellow;
            }
          } else {
            for (int i = 0; i < 8; i++) {
              _ballColors[i] = Colors.yellow;
            }
            for (int i = 8; i < 16; i++) {
              _ballColors[i] = Colors.red;
            }
          }
      });
    },
    activeColor: Colors.red,
    inactiveThumbColor: Colors.yellow,
  );
}

Column _buildBalls8(bool isPlayer1, double width) {
  double usableWidth = width / 2;
  double size = usableWidth / 5;
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBallButton1(
            0,
            isPlayer1,
            size,
          ),
          _buildBallButton1(
            1,
            isPlayer1,
            size,
          ),
          _buildBallButton1(
            2,
            isPlayer1,
            size,
          ),
          _buildBallButton1(
            3,
            isPlayer1,
            size,
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 5),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBallButton1(
            4,
            isPlayer1,
            size,
          ),
          _buildBallButton1(
            5,
            isPlayer1,
            size,
          ),
          _buildBallButton1(
            6,
            isPlayer1,
            size,
          ),
          _buildBallButton1(
            7,
            isPlayer1,
            size,
          ),
        ],
      ),
    ],
  );
}

// Padding _buildBallButtonPadding1(int n, bool isPlayer1, double padding) {
//   return Padding(
//     padding: EdgeInsets.all(padding),
//     child: _buildBallButton1(n, isPlayer1),
//   );
// }

ElevatedButton _buildBallButton1(int n, bool isPlayer1, double size) {
  return ElevatedButton(
    onPressed: () {
      String winner, loser;
      if (isPlayer1) {
        winner = _usernameController1.text;
        loser = _usernameController2.text;
      } else {
        winner = _usernameController2.text;
        loser = _usernameController1.text;
      }

      bool isWinnerRed = true;
      if ((!isRed && isPlayer1) || (isRed && !isPlayer1)) {
        isWinnerRed = false;
      }

      vm
      .uploadResult(_passController.text, winner, loser, n, isWinnerRed)
      .then((value) {
          setState(() {
              history.insert(0, value);
          });
      });
    },
    onHover: (value) {
      if (value) {
        setState(() {
            if (isPlayer1) {
              _ballColors[n] = Colors.green;
            } else {
              _ballColors[n + 8] = Colors.green;
            }
        });
      } else {
        setState(() {
            if (isPlayer1) {
              _ballColors[n] = isRed ? Colors.red : Colors.yellow;
            } else {
              _ballColors[n + 8] = isRed ? Colors.yellow : Colors.red;
            }
        });
      }
    },
    child: Text(
      n.toString(),
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: ElevatedButton.styleFrom(
      primary: isPlayer1 ? _ballColors[n] : _ballColors[n + 8],
      shape: const CircleBorder(),
      padding: EdgeInsets.all(size >= 20 ? (size - 20) / 2 : 0),
    ),
  );
}

Widget _buildHistoryList() {
  List<TableRow> rows = [];
  rows.add(const TableRow(children: [
        Text("id "),
        Text("winner "),
        Text("loser "),
        Text("diff "),
        Text("color "),
        Text("date "),
  ]));
  for (int i = 0; i < history.length; i++) {
    var date = DateTime.parse(history[i].date);
    date.add(Duration(hours: 8)).toString();

    rows.add(TableRow(children: [
          Text(history[i].id.toString()),
          Text(history[i].winner),
          Text(history[i].loser),
          Text(history[i].diff.toString()),
          Text(history[i].red == 1 ? "red" : "yellow"),
          Text(date.add(Duration(hours: 8)).toString()),
    ]));
  }
  return Table(
    columnWidths: {
      0: IntrinsicColumnWidth(),
      1: IntrinsicColumnWidth(),
      2: IntrinsicColumnWidth(),
      3: IntrinsicColumnWidth(),
      4: IntrinsicColumnWidth(),
      5: FlexColumnWidth(),
    },
    children: rows,
  );
}
}
