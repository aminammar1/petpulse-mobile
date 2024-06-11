import 'package:flutter/material.dart';
import 'package:petpulse/provider/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/route/routes.dart';
import 'package:petpulse/views/screens/health_screens/health_screen.dart';
import 'package:petpulse/views/screens/setting_screen/profile.dart';
import 'package:petpulse/views/screens/homepage/homepage.dart';
import 'package:petpulse/views/screens/activity_screens/activity.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationProvider>(
      create: (_) => NavigationProvider(),
      child: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return PopScope(
            canPop: false,
            onPopInvoked: (_) async {
              if (navigationProvider.currentIndex != 0) {
                navigationProvider.pageController.jumpToPage(0);
                navigationProvider.currentIndex = 0;
              }
            },
            child: Scaffold(
              body: PageView(
                controller: navigationProvider.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const HomePage(),
                  const Navigator(
                    onGenerateRoute: RouteGenerator.generateRoute,
                    initialRoute: '/community',
                  ),
                  const HealthScreen(),
                  const ActivityScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navigationProvider.currentIndex,
                onTap: (index) {
                  navigationProvider.currentIndex = index;
                  navigationProvider.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuad,
                  );
                },
                items: [
                  _buildBottomNavItem('assets/Home.png', 'Home',
                      navigationProvider.currentIndex == 0),
                  _buildBottomNavItem('assets/Network.png', 'Network',
                      navigationProvider.currentIndex == 1),
                  _buildBottomNavItem('assets/h.png', 'Health',
                      navigationProvider.currentIndex == 2),
                  _buildBottomNavItem('assets/Adopt.png', 'Activity',
                      navigationProvider.currentIndex == 3),
                  _buildBottomNavItem('assets/Profile.png', 'Profile',
                      navigationProvider.currentIndex == 4),
                ],
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.green.shade400,
                unselectedItemColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

BottomNavigationBarItem _buildBottomNavItem(
    String iconPath, String label, bool isSelected) {
  return BottomNavigationBarItem(
    icon: ColorFiltered(
      colorFilter: isSelected
          ? ColorFilter.mode(Colors.green.shade400, BlendMode.srcIn)
          : const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      child: Image.asset(
        iconPath,
        width: 30,
        height: 30,
      ),
    ),
    label: label,
  );
}
