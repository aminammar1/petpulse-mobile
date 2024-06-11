import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/activity_provider.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepProvider = Provider.of<ActivityProvider>(context, listen: false);
    final TextEditingController timesleepController = TextEditingController();
    final TextEditingController qualitysleepController =
        TextEditingController();
    final TextEditingController timeWakeUpController = TextEditingController();

    Future<void> selectTimeSleep(BuildContext context) async {
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
        var isoformat = selectedDateTime.toIso8601String();
        timesleepController.text = localizations.formatTimeOfDay(selectedTime);
        sleepProvider.setTimesleep(isoformat);
      }
    }

    Future<void> selectTimewakeup(BuildContext context) async {
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
        timeWakeUpController.text = localizations.formatTimeOfDay(selectedTime);
        sleepProvider.setTimewakeup(isoString);
      }
    }

    bool validateTimeSelection(String sleepTime, String wakeupTime) {
      if (sleepTime.isEmpty || wakeupTime.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter both times.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      DateTime sleepDateTime = DateTime.parse(sleepTime);
      DateTime wakeupDateTime = DateTime.parse(wakeupTime);
      if (sleepDateTime.isAtSameMomentAs(wakeupDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sleep and wake-up times cannot be the same.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      if (wakeupDateTime.isBefore(sleepDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wake-up time must be after sleep time.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      return true;
    }

    void createSleepActivity(BuildContext context) async {
      sleepProvider.setqualitySleep(qualitysleepController.text);
      if (validateTimeSelection(
          sleepProvider.timeSleep, sleepProvider.timeWakeUp)) {
        bool isSuccess = await sleepProvider.createsleepActivity();
        String message = isSuccess
            ? 'Sleep activity added successfully!'
            : 'Failed to add sleep activity.';
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
    }

    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Add Sleep Activity'),
          backgroundColor: Colors.lightGreen[100]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/sleep.png',
                width: 220,
                height: 220,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: qualitysleepController,
                decoration: const InputDecoration(
                  labelText: 'how was the sleep of the good boi?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: timesleepController,
                decoration: const InputDecoration(
                    labelText: 'Start Time',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.timer)),
                onTap: () {
                  selectTimeSleep(context);
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: timeWakeUpController,
                decoration: const InputDecoration(
                  labelText: 'Wake Up Time',
                  icon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  selectTimewakeup(context);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => createSleepActivity(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  'Create Sleep Activity',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
