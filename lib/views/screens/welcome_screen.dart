import 'package:flutter/material.dart';
import 'auth pages/authentication.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/HeroImage.png',
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Image.asset(
                "assets/LOGO 1.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Authentication()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AF19),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                ),
                child: const Text(
                  "Let's Go",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
