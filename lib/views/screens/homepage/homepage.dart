import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:petpulse/provider/notification_provider.dart';
import 'package:petpulse/views/screens/activity_screens/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map.dart';
import 'package:petpulse/views/screens/pet profile/pet_screen.dart';
import 'package:petpulse/views/screens/petsgallerie_screen/pet_gellerie.dart';
import 'package:petpulse/provider/userimg_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpulse/views/screens/health_screens/health_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:petpulse/provider/googleauth.dart';
import 'package:petpulse/views/screens/setting_screen/account.dart';
import 'package:petpulse/views/screens/pet profile/profile_pet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NotificationProvider>().simulatePeriodicNotifications();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            _buildPetsSection(context),
            buildServiceSection(context),
            _card(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer3<ImageProviderModel, NotificationProvider, AuthService>(
      builder:
          (context, imageProvider, notificationProvider, authService, child) {
        final user = authService.user;
        final isGoogleAuth = user != null;

        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            String firstName = 'User';
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              firstName = snapshot.data?.getString('firstName') ?? 'User';
            }
            if (isGoogleAuth && user.displayName != null) {
              firstName = user.displayName!.split(' ').first;
            }
            return Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountManagement()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: imageProvider.image != null
                          ? FileImage(imageProvider.image!)
                          : (isGoogleAuth && user.photoURL != null)
                              ? NetworkImage(user.photoURL!)
                                  as ImageProvider<Object>
                              : const AssetImage('assets/avatar.jpg')
                                  as ImageProvider<Object>,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Hi, $firstName',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset('assets/Battery.png'),
                    onPressed: null,
                  ),
                  badges.Badge(
                    badgeContent: Text(
                      '${notificationProvider.notificationCount}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    position: badges.BadgePosition.topEnd(top: -5, end: -5),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.lightGreen,
                      padding: EdgeInsets.all(6),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.black),
                      onPressed: () => _showNotificationsHistory(context),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPetsSection(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Failed to load pet data."));
          }

          final prefs = snapshot.data!;
          final String petsData = prefs.getString('petsData') ?? '[]';
          List<Map<String, dynamic>> pets =
              List<Map<String, dynamic>>.from(json.decode(petsData));

          pets.insert(
              0, {'name': 'Add Pet', 'icon': Icons.add, 'imagePath': ''});

          return Card(
            surfaceTintColor: Colors.white,
            margin: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Your Pets',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('See All',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        return _buildPetCircle(context, pets[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildPetCircle(BuildContext context, Map<String, dynamic> pet) {
    return GestureDetector(
      onTap: () {
        if (pet['name'] == 'Add Pet') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PetScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PetProfileScreen(),
            ),
          );
        }
      },
      child: Container(
        width: 60.0,
        height: 60.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: pet['imagePath'].isNotEmpty
                ? FileImage(File(pet['imagePath'])) as ImageProvider<Object>
                : const AssetImage('assets/white.jpg') as ImageProvider<Object>,
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        alignment: Alignment.center,
        child: pet['name'] == 'Add Pet'
            ? const Icon(Icons.add, color: Colors.black, size: 24.0)
            : Container(),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        if (service['name'] == 'Activity') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ActivityScreen()));
        } else if (service['name'] == 'Tracking') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MapScreen()));
        } else if (service['name'] == 'Health') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HealthScreen()));
        }
        if (service['name'] == 'Pet Pictures') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PetPictures()));
        }
      },
      child: Card(
        elevation: 2.0,
        color: service['color'] ?? Colors.blue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                service['image'],
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 3),
              Text(
                service['name'],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildServiceSection(BuildContext context) {
    List<Map<String, dynamic>> services = [
      {
        'name': "Pet Pictures",
        "image": "assets/dogz.png",
        "color": Colors.lightGreen.shade300,
      },
      {
        'name': "Health",
        "image": "assets/daycare-center 1.png",
        "color": Colors.red.shade200
      },
      {
        'name': "Activity",
        "image": "assets/dog 1.png",
        "color": Colors.lightBlue.shade200
      },
      {
        'name': "Tracking",
        "image": "assets/tracking.png",
        "color": Colors.orange.shade200
      },
    ];

    return Card(
      surfaceTintColor: Colors.white,
      elevation: 6,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Services',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(context, services[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  AspectRatio _card() {
    return AspectRatio(
      aspectRatio: 336 / 184,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.lightGreen,
        ),
        child: Stack(children: [
          Image.asset(
            'assets/Group 1_card.png',
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Your ",
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFFDEE1FE),
                            height: 150 / 100),
                        children: const [
                      TextSpan(
                          text: "Partner ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                      TextSpan(text: "in\npet "),
                      TextSpan(
                          text: " wellness\n",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.4),
                      border: Border.all(
                          color: Colors.white.withOpacity(.12), width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Order Now",
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  void _showNotificationsHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final notificationsHistory =
            context.watch<NotificationProvider>().notificationsHistory;
        return notificationsHistory.isEmpty
            ? const Center(child: Text("No notifications history."))
            : ListView.separated(
                itemCount: notificationsHistory.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(notificationsHistory[index]),
                ),
                separatorBuilder: (context, index) => const Divider(),
              );
      },
    );
  }
}
