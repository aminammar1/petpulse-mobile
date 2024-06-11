import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:petpulse/api/api.dart';

class DeviceProvider with ChangeNotifier {
  String _selectedDeviceType = '';
  bool _isCardSelected = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  String get selectedDeviceType => _selectedDeviceType;
  bool get isCardSelected => _isCardSelected;
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;

  Future<bool> addDeviceType(String deviceType) async {
    try {
      final response = await Api.addDeviceType(deviceType);
      if (response != null) {
        _selectedDeviceType = deviceType;
        _isCardSelected = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Logger().e(
          "Error adding device type: $error"); // Log the error including the error message
      return false;
    }
  }

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void toggleEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }
  
}
