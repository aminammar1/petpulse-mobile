import 'package:flutter/material.dart';
import 'package:petpulse/provider/walk_provider.dart';
import 'package:provider/provider.dart';

class WalkScreen extends StatelessWidget {
  const WalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Provider.of<WalkState>(context, listen: false).resetDistance();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.pink[200],
            ),
          ),
          Center(
            child: Consumer<WalkState>(
              builder: (context, walkState, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Distance Text
                    Text(
                      '${walkState.distance} m',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black87,
                              ),
                    ),
                    // Timer Text
                    Text(
                      walkState.duration
                          .toString()
                          .split('.')
                          .first
                          .padLeft(8, "0"),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.black54,
                              ),
                    ),
                    // Start/Stop Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: walkState.isWalking
                            ? walkState.stopTimer
                            : walkState.startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              walkState.isWalking ? Colors.red : Colors.green,
                          minimumSize:
                              const Size(150, 60), // Set the button size
                        ),
                        child: Text(
                          walkState.isWalking ? 'STOP' : 'START',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Positioned cat illustration at the bottom of the screen.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/walk.png', // Add your cat illustration asset path here.
              height: 200, // Adjust the size accordingly.
            ),
          ),
        ],
      ),
    );
  }
}
