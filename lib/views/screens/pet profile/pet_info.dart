import 'package:flutter/material.dart';
import 'pet_describe.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/pet_selection_state.dart';
import 'package:petpulse/api/api.dart';
import 'package:logger/logger.dart';

class PetInfo extends StatelessWidget {
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  PetInfo({super.key});

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
        ),
        body: Consumer<PetSelectionState>(
          builder: (context, petSelectionState, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const LinearProgressIndicator(
                      value: 0.50,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _PetCard(
                          color: const Color(0xFF0050C9),
                          label: 'Male',
                          isSelected: petSelectionState.isMaleSelected,
                          onTap: () {
                            petSelectionState.selectMale();
                            petSelectionState.deselectFemale();
                          },
                        ),
                        _PetCard(
                          color: const Color(0xFFFF3C9A),
                          label: 'Female',
                          isSelected: petSelectionState.isFemaleSelected,
                          onTap: () {
                            petSelectionState.selectFemale();
                            petSelectionState.deselectMale();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: const InputDecorationTheme(
                            labelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        child: TextField(
                          controller: _breedController,
                          decoration: InputDecoration(
                            labelText: 'Breed',
                            border: InputBorder.none,
                            filled: true,
                            fillColor:
                                const Color(0xFF00AF19).withOpacity(0.15),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 43),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: const InputDecorationTheme(
                            labelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.grey,
                            floatingLabelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        child: TextField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            border: InputBorder.none,
                            filled: true,
                            fillColor:
                                const Color(0xFF00AF19).withOpacity(0.15),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<PetSelectionState>(
            builder: (context, petSelectionState, _) {
              return _buildButton(
                text: 'Next',
                onPressed: () {
                  String breed = _breedController.text;
                  String weight = _weightController.text;
                  String gender;
                  if (petSelectionState.isMaleSelected) {
                    gender = 'male';
                  } else if (petSelectionState.isFemaleSelected) {
                    gender = 'female';
                  } else {
                    Logger().w('Please select one gender');
                    return;
                  }

                  Api.addPetInfo(gender, breed, weight).then((result) {
                    if (result != null) {
                      Logger().i(result);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDescribe(),
                        ),
                      );
                    } else {
                      Logger().e('Failed to add pet info');
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 230,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF00AF19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetCard({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 57,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.black,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
