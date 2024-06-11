import 'package:flutter/material.dart';
import 'walk.dart';
import 'food.dart';
import 'play.dart';
import 'sleep.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/navigation_provider.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            var navigationProvider =
                Provider.of<NavigationProvider>(context, listen: false);
            if (navigationProvider.currentIndex != 0) {
              navigationProvider.currentIndex = 0;
              navigationProvider.pageController.jumpToPage(0);
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Add Activity',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Please Select an Activity to Add',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ActivityTile(
            color: Colors.pinkAccent[100]!,
            text: 'Walk',
            assetPath: 'assets/walk.png',
            destination: const WalkScreen(),
          ),
          ActivityTile(
            color: Colors.orange[100]!,
            text: 'Food',
            assetPath: 'assets/food.png',
            destination: const FoodActivityScreen(),
          ),
          ActivityTile(
              color: Colors.lightBlue[100]!,
              text: 'Play',
              assetPath: 'assets/play.png',
              destination: const PlayScreen()),
          ActivityTile(
              color: Colors.lightGreen[100]!,
              text: 'Sleep',
              assetPath: 'assets/sleep.png',
              destination: const SleepScreen()),
        ],
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final Color color;
  final String text;
  final String assetPath;
  final Widget destination;

  const ActivityTile({
    super.key,
    required this.color,
    required this.text,
    required this.assetPath,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(20),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(assetPath, width: 80),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
