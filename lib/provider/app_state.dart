import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isFirstTime = true;
  Future? initialLoadComplete;

  AppState() {
    initialLoadComplete = _checkFirstTime();
  }

  bool get isFirstTime => _isFirstTime;

  Future<void> _checkFirstTime() async {
    await Future.delayed(
        const Duration(seconds: 4)); // Ensure minimum splash screen duration
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;
    notifyListeners();
  }

  void setFirstTime(bool value) async {
    _isFirstTime = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', value);
    notifyListeners();
  }
}
