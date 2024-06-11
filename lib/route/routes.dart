import 'package:flutter/material.dart';
import 'package:petpulse/views/screens/communityscreen/community.dart';
import 'package:petpulse/views/screens/health_screens/health_screen.dart';
import 'package:petpulse/views/screens/setting_screen/profile.dart';
import 'package:petpulse/views/screens/homepage/homepage.dart';
import 'package:petpulse/views/screens/activity_screens/activity.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings route) {
    switch (route.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/community':
        return MaterialPageRoute(builder: (context) => const Community());
      case '/health':
        return MaterialPageRoute(builder: (context) => const HealthScreen());
      case '/activity':
        return MaterialPageRoute(builder: (context) => const ActivityScreen());
      case '/setting':
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('screen  not found')),
      );
    });
  }
}
