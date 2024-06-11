import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/settingnotif_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NotificationOption(
              title: 'GPS Tracking',
              icon: Icons.location_on,
              value: context.watch<Notificationsettting>().gpsTracking,
              onChanged: (bool value) {
                context.read<Notificationsettting>().toggleGpsTracking();
              },
            ),
            NotificationOption(
              title: 'Health Tracking',
              icon: Icons.favorite,
              value: context.watch<Notificationsettting>().healthTracking,
              onChanged: (bool value) {
                context.read<Notificationsettting>().toggleHealthTracking();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationOption({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}
