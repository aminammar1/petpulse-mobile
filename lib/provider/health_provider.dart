import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HealthScreenProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
   bool _showAd = true;

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  bool get showAd => _showAd;

  void setSelectedDate(DateTime newDate) {
    if (!isSameDay(_selectedDate, newDate)) {
      _selectedDate = newDate;
      setFocusedDate(newDate);
      notifyListeners();
    }
  }

  void setFocusedDate(DateTime newDate) {
    if (!isSameDay(_focusedDate, newDate)) {
      _focusedDate = newDate;
      notifyListeners();
    }
  }
    void showAdScreen() {
    _showAd = true;
    notifyListeners();
  }

  void hideAdScreen() {
    _showAd = false;
    notifyListeners();
  }
}
