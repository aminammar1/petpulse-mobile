import 'package:flutter/material.dart';

class Notificationsettting with ChangeNotifier {
  bool _gpsTracking = false;
  bool _healthTracking = false;
  bool _flutterProvider = false;

  bool get gpsTracking => _gpsTracking;
  bool get healthTracking => _healthTracking;
  bool get flutterProvider => _flutterProvider;

  void toggleGpsTracking() {
    _gpsTracking = !_gpsTracking;
    notifyListeners();
  }

  void toggleHealthTracking() {
    _healthTracking = !_healthTracking;
    notifyListeners();
  }

  void toggleFlutterProvider() {
    _flutterProvider = !_flutterProvider;
    notifyListeners();
  }
}
