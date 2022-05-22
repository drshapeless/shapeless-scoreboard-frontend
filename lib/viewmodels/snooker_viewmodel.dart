import 'package:flutter/foundation.dart';

import '../models/snookers.dart';
import '../services/snooker_service.dart';

class SnookerViewModel extends ChangeNotifier {
  List<Snooker> snookers = [];
}
