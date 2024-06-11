import 'package:flutter/material.dart';
import 'package:petpulse/api/api.dart';

class ActivityProvider with ChangeNotifier {
  String _food = '';
  String _time = '';
  String _calorie = '';
  String _game = '';
  String _qualitySleep = '';
  String _timeSleep = '';
  String _timeWakeUp = '';

  String get food => _food;
  String get time => _time;
  String get calorie => _calorie;
  String get game => _game;
  String get qualitySleep => _qualitySleep;
  String get timeSleep => _timeSleep;
  String get timeWakeUp => _timeWakeUp;

  void setFood(String value) {
    _food = value;
    notifyListeners();
  }

  void setTime(String value) {
    _time = value;
    notifyListeners();
  }

  void setTimesleep(String value) {
    _timeSleep = value;
    notifyListeners();
  }

  void setTimewakeup(String value) {
    _timeWakeUp = value;
    notifyListeners();
  }

  void setCalorie(String value) {
    _calorie = value;
    notifyListeners();
  }

  void setGame(String value) {
    _game = value;
    notifyListeners();
  }

  void setqualitySleep(String value) {
    _qualitySleep = value;
    notifyListeners();
  }

  void setTimeSleep(String value) {
    _timeSleep = value;
    notifyListeners();
  }

  void setTimeWakeUp(String value) {
    _timeWakeUp = value;
    notifyListeners();
  }

  Future<bool> createFoodActivity() async {
    var response = await Api.foodActivity(_food, _time, _calorie);
    return response != null;
  }

  Future<bool> createPlayActivity() async {
    var response = await Api.playActivity(_game, _time);
    return response != null;
  }

  Future<bool> createsleepActivity() async {
    var response =
        await Api.sleepActivity(_qualitySleep, _timeSleep, _timeWakeUp);
    return response != null;
  }
}
