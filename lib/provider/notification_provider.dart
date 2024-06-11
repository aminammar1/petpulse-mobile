import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<String> _notificationsHistory = [];
  int _notificationCount = 0;

  NotificationProvider() {
    tz.initializeTimeZones();
    _initializeNotifications();
  }
  int get notificationCount => _notificationCount;

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showImmediateNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
            'immediate_channel_id', 'immediate_channel_name',
            importance: Importance.high, priority: Priority.high);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
    _addToHistory(title, body);
    increment();
  }

  Future<void> scheduleFutureNotification(
      DateTime scheduledTime, String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
            'scheduled_channel_id', 'scheduled_channel_name',
            importance: Importance.high, priority: Priority.high);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    _addToHistory(title, body);
    increment();
  }

  void simulatePeriodicNotifications() {
    //Timer(const Duration(seconds: 5),
    //() => showImmediateNotification('Pet Alert', 'Immediate pet alert!'));
    /*Timer(
        const Duration(seconds: 10),
        () => scheduleFutureNotification(
            DateTime.now().add(const Duration(seconds: 5)),
            ' Petpulse Alert',
            'This petPulse alert .'));*/
    Timer(
        const Duration(hours: 5),
        () => showImmediateNotification('Periodic Pet Check-In',
            'Time for your daily pet activity review!'));
    Timer(
        const Duration(seconds: 20),
        () => scheduleFutureNotification(
            DateTime.now().add(const Duration(seconds: 10)),
            ' Pet in danger Zone',
            'track your pet .'));
  }

  void _addToHistory(String title, String body) {
    final String message = "$title: $body";
    _notificationsHistory.add(message);
    notifyListeners();
  }

  void increment() {
    _notificationCount++;
    notifyListeners();
  }

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }

  List<String> get notificationsHistory =>
      List.unmodifiable(_notificationsHistory);
}
