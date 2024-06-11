import 'package:flutter/material.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health & GPS Pro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/health&gps_pro.png',
                width: 300,
                height: 300,
              ),
            ),
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Real-time GPS tracking\n'
              '• Health monitoring\n'
              '• Activity tracking\n'
              '• Health alerts\n'
              '• Long battery life\n'
              '• Water-resistant design',
            ),
          ],
        ),
      ),
    );
  }
}
