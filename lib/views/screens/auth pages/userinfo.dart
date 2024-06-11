import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/googleauth.dart';
import 'package:petpulse/views/screens/pet profile/pet_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final user = authService.user;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('User Profile'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PetScreen()),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: user != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoURL ?? ''),
                      ),
                      const SizedBox(height: 20),
                      Text('Name: ${user.displayName ?? 'N/A'}'),
                      const SizedBox(height: 10),
                      Text('Email: ${user.email ?? 'N/A'}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _signOut(context);
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  )
                : const Text('User not signed in'),
          ),
        );
      },
    );
  }

  void _signOut(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut().then((_) {
      Navigator.pop(context);
    });
  }
}
