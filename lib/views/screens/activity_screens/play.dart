import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/activity_provider.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playProvider = Provider.of<ActivityProvider>(context, listen: false);
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController playController = TextEditingController();

    Future<void> selectTime(BuildContext context) async {
      final localizations = MaterialLocalizations.of(context);
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        var selectedDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            selectedTime.hour,
            selectedTime.minute);
        var isoString = selectedDateTime.toIso8601String();
        startTimeController.text = localizations.formatTimeOfDay(selectedTime);
        playProvider.setTime(isoString);
      }
    }

    void createPlayActivity(BuildContext context) async {
      playProvider.setGame(playController.text);
      bool isSuccess = await playProvider.createPlayActivity();
      String message = isSuccess
          ? 'play activity added successfully!'
          : 'Failed to add play activity.';
      Color bgColor = isSuccess ? Colors.green : Colors.red;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: bgColor,
          ),
        );
      }
    }

    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(),
      child: Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Add Play Activity'),
            backgroundColor: Colors.lightBlue[100]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<ActivityProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/play.png', height: 220, width: 220),
                    const SizedBox(height: 100),
                    TextField(
                      controller: playController,
                      decoration: const InputDecoration(
                        labelText: 'What did the good boi want to play today?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: startTimeController,
                      decoration: const InputDecoration(
                          labelText: 'Start Time',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.timer)),
                      onTap: () {
                        selectTime(context); // Pass context here
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => createPlayActivity(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Customize your color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                      ),
                      child: const Text(
                        'Create play Activity',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Additional space at the bottom
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
