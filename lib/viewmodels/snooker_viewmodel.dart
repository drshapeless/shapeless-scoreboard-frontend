import 'package:flutter/foundation.dart';

import '../models/snookers.dart';
import '../services/snooker_service.dart';

class SnookerViewModel extends ChangeNotifier {
  List<Snooker> snookers = [];

  Future<Snooker> uploadResult(
    String pass, String winner, String loser, int diff, bool red) async {
    int redi = red ? 1 : 0;
    Snooker result = await createSnooker(pass, winner, loser, diff, redi);
    return result;
  }

  Future<List<Snooker>> getResult(int page) async {
    return await getSnookers(page);
  }
}
