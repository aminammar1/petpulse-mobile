import 'package:flutter/material.dart';
import 'package:petpulse/views/widgets/costume_calendar.dart';
import 'package:petpulse/provider/health_provider.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/views/widgets/costume_widget_health.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:petpulse/views/screens/pet profile/profile_pet.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthScreenProvider>(builder: (context, provider, child) {
      return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final prefs = snapshot.data!;
          var petsData = prefs.getString('petsData') ?? '[]';
          List<dynamic> pets = json.decode(petsData);
          String petName =
              pets.isNotEmpty ? pets.last['petName'] : "No Pet Registered";
          String imagePath =
              pets.isNotEmpty ? pets.last['imagePath'] : "No image Registered";

          ImageProvider<Object> imageProvider;
          if (File(imagePath).existsSync()) {
            imageProvider = FileImage(File(imagePath));
          } else {
            imageProvider = const AssetImage('assets/iconimage.png');
          }

          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.green,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: headerTitle("Hi, $petName"),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PetProfileScreen()),
                                    );
                                  },
                                  child: ClipOval(
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomTableCalendar(
                            onDaySelected: (selectedDate, focusedDate) {
                              provider.setSelectedDate(selectedDate);
                            },
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Consumer<HealthScreenProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            padding: const EdgeInsets.only(top: 5),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: SingleChildScrollView(
                                key: ValueKey<DateTime>(provider.selectedDate),
                                child:
                                    healthGridviewCard(provider.selectedDate),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.showAd)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: provider.hideAdScreen,
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Stack(
                          children: [
                            Image.asset('assets/vv.png', fit: BoxFit.cover),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: provider.hideAdScreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    });
  }
}

Text headerTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),
  );
}
