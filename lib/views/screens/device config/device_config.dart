import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'device_connect.dart';
import 'package:petpulse/provider/device_config_provider.dart';

class DeviceConfig extends StatelessWidget {
  const DeviceConfig({super.key});

  @override
  Widget build(BuildContext context) {
    final Color cardHeaderColor = const Color(0xFF00AF19).withOpacity(0.15);

    return ChangeNotifierProvider<DeviceProvider>(
      create: (_) => DeviceProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Petpulse Tracker Setup',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Text(
                'Select your device',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeviceCard(
                      deviceName: 'Health & GPS +',
                      imageAsset: 'assets/health&gps_pro.png',
                      color: cardHeaderColor,
                    ),
                    const SizedBox(height: 8.0),
                    DeviceCard(
                      deviceName: 'Health & GPS',
                      imageAsset: 'assets/health&gps.png',
                      color: cardHeaderColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomAppBar(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Not sure which device you have?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String imageAsset;
  final Color color;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.imageAsset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: color,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imageAsset,
            width: 56.0,
            height: 56.0,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          deviceName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: () {
          final provider = Provider.of<DeviceProvider>(context, listen: false);
          provider.addDeviceType(deviceName).then((success) {
            if (success) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeviceConnect()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to add device type.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        },
      ),
    );
  }
}
