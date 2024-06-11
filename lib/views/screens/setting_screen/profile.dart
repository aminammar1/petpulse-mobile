import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/auth_provider.dart';
import 'package:petpulse/provider/userimg_provider.dart';
import 'package:petpulse/views/screens/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpulse/provider/navigation_provider.dart';
import 'package:petpulse/provider/googleauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account.dart';
import 'notifcationsetting.dart';
import 'privacy.dart';
import "device.dart";

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<String> data = [
    "Account",
    "Notifications",
    "Devices",
    "Privacy Policy",
    "Logout",
  ];

  Future<Map<String, String>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firstName = prefs.getString('firstName') ?? "First";
    String lastName = prefs.getString('lastName') ?? "Last";
    String email = prefs.getString('email') ?? "email@example.com";
    return {
      "fullName": "$firstName $lastName",
      "email": email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade400,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: headerTitle("Settings"),
            ),
            const SizedBox(height: 10),
            Center(
              child: Consumer<ImageProviderModel>(
                builder: (context, model, child) {
                  return Consumer<AuthService>(
                    builder: (context, authService, _) {
                      final user = authService.user;
                      final isGoogleAuth = user != null;

                      return FutureBuilder<Map<String, String>>(
                        future: getUserDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }
                          var userDetails = snapshot.data!;
                          return Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (model.image != null) {
                                          showRemoveImageDialog(context);
                                        } else {
                                          model.pickImage(ImageSource.gallery);
                                        }
                                      },
                                      child: Container(
                                        height: 130,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade400,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: model.image != null
                                                ? FileImage(model.image!)
                                                : (isGoogleAuth &&
                                                        user.photoURL != null)
                                                    ? NetworkImage(
                                                        user.photoURL!)
                                                    : const AssetImage(
                                                            "assets/placeimage.png")
                                                        as ImageProvider,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      isGoogleAuth
                                          ? user.displayName ??
                                              userDetails["fullName"]!
                                          : userDetails["fullName"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      isGoogleAuth
                                          ? user.email ?? userDetails["email"]!
                                          : userDetails["email"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      if (data[index] == "Account") {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AccountManagement(),
                                          ),
                                        );
                                      }
                                      if (data[index] == "Notifications") {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationScreen(),
                                          ),
                                        );
                                      }
                                      if (data[index] == "Privacy Policy") {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PrivacyPolicyScreen(),
                                          ),
                                        );
                                      }
                                      if (data[index] == "Devices") {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DeviceScreen(),
                                          ),
                                        );
                                      } else if (data[index] == "Logout") {
                                        _logout(context);
                                      }
                                    },
                                    title: Text(
                                      data[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                      color: Colors.white.withOpacity(0.5));
                                },
                                itemCount: data.length,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _logout(BuildContext context) async {
  Provider.of<AuthModel>(context, listen: false).logout();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    (route) => false,
  );
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

Container customDivider(Color color) {
  return Container(
    height: 2,
    width: double.infinity,
    color: color,
  );
}

void showRemoveImageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Remove Image'),
        content: const Text('Do you want to remove your profile image?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel',
                style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Remove',
                style: TextStyle(color: Colors.lightGreen)),
            onPressed: () {
              Provider.of<ImageProviderModel>(context, listen: false)
                  .removeImage();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
