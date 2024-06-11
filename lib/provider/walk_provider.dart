import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:petpulse/config/config.dart';

class WalkState with ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  Duration _duration = Duration.zero;
  int _distance = 0;

  Duration get duration => _duration;
  int get distance => _distance;
  bool get isWalking => _stopwatch.isRunning;

  void startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => updateDistance());
  }

  void stopTimer() async {
    _stopwatch.stop();
    _timer?.cancel();
    resetTimer();
    notifyListeners();
    final response = await http.post(
      Uri.parse(URL.walkurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'distance': _distance,
        'duration': _duration.inSeconds,
      }),
    );

    if (response.statusCode == 200) {
      Logger().i('Walk data successfully sent to the server');
    } else {
      Logger().d('Failed to send walk data');
      Logger().i(response.body);
    }
  }

  void resetTimer() {
    _stopwatch.reset();
    _duration = Duration.zero;
    notifyListeners();
  }

  void resetDistance() {
    _distance = 0; // Reset the distance
    notifyListeners();
  }

  void updateDistance() {
    _duration = _stopwatch.elapsed;
    _distance = (_duration.inSeconds / 60 * ((50 + 100) / 2)).round();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
