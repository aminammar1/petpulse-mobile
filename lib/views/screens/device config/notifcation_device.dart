import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/device_config_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:petpulse/views/widgets/navbar.dart';

class NotifDevice extends StatelessWidget {
  const NotifDevice({super.key});

  void onContinuePressed(BuildContext context) async {
    final navigator = Navigator.of(context);
    await sendLocalNotification(context);
    navigator.push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  Future<void> sendLocalNotification(BuildContext context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'immediate_channel_id',
      'immediate_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Welcome to PetPulse',
      'Your pet is waiting for you!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeviceProvider>(
      create: (_) => DeviceProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Permissions',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        'Push notifications',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: SizedBox(
                        width: 60,
                        child: Consumer<DeviceProvider>(
                          builder: (context, provider, child) => FlutterSwitch(
                            width: 55.0,
                            height: 25.0,
                            value: provider.pushNotifications,
                            onToggle: provider.togglePushNotifications,
                            activeColor: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Email notifications',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: SizedBox(
                        width: 60,
                        child: Consumer<DeviceProvider>(
                          builder: (context, provider, child) => FlutterSwitch(
                            width: 55.0,
                            height: 25.0,
                            value: provider.emailNotifications,
                            onToggle: provider.toggleEmailNotifications,
                            activeColor: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => onContinuePressed(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
