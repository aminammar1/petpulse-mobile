import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/pet_selection_state.dart';
import 'pet_info.dart';
import 'package:petpulse/views/widgets/navbar.dart';
import 'package:petpulse/api/api.dart';
import 'package:logger/logger.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetSelectionState(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Add Pet',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: const Color.fromARGB(255, 22, 188, 58),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 22, 188, 58)),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const LinearProgressIndicator(
              value: 0.33,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose your pet species',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PetCard(
                    iconAsset: 'assets/cat.png',
                    color: Color(0xFFCDC9B7),
                    label: 'Cat',
                  ),
                  _PetCard(
                    iconAsset: 'assets/dog.png',
                    color: Color(0xFF5B79A7),
                    label: 'Dog',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PetInfo()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AF19),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final String iconAsset;
  final Color color;
  final String label;

  const _PetCard({
    required this.iconAsset,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final petSelectionState = Provider.of<PetSelectionState>(context);
    final bool isSelected = label == 'Cat'
        ? petSelectionState.isCatSelected
        : petSelectionState.isDogSelected;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          if (label == 'Cat') {
            petSelectionState.deselectCat();
          } else {
            petSelectionState.deselectDog();
          }
        } else {
          if (label == 'Cat') {
            petSelectionState.selectCat();
            petSelectionState.deselectDog();
          } else {
            petSelectionState.selectDog();
            petSelectionState.deselectCat();
          }

          Api.addPetType(label).then((result) {
            if (result != null && result['success'] == true) {
              // Handle success
              Logger().i('Pet type added successfully');
            } else {
              // Handle failure
              Logger().e('Failed to add pet type');
            }
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset,
              width: 80,
              height: 80,
              color: isSelected ? Colors.green : null,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
