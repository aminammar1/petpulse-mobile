import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:petpulse/provider/pet_provider.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pet Name: ${context.watch<PetProfileProvider>().petName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  context.read<PetProfileProvider>().pickImage();
                },
                child: context.watch<PetProfileProvider>().petImage != null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          SfCircularChart(
                            series: <CircularSeries>[
                              RadialBarSeries<ChartData, String>(
                                dataSource: [ChartData('', 100)],
                                useSeriesColor: true,
                                innerRadius: '70%',
                                cornerStyle: CornerStyle.bothCurve,
                                radius: '100%',
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                              ),
                            ],
                            annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(context
                                          .watch<PetProfileProvider>()
                                          .petImage!),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('No Image'),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Mood Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SfCircularChart(
                legend: const Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                series: <PieSeries>[
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: context.watch<PetProfileProvider>().moodData,
                    xValueMapper: (Map<String, dynamic> data, _) =>
                        data['mood'],
                    yValueMapper: (Map<String, dynamic> data, _) =>
                        data['percentage'],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this pet profile?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                final snacker = ScaffoldMessenger.of(context);
                Navigator.of(context).pop();
                final petName = context.read<PetProfileProvider>().petName;
                try {
                  await context
                      .read<PetProfileProvider>()
                      .deletePetProfile(petName);
                  snacker.showSnackBar(
                    const SnackBar(
                        content: Text('Pet profile deleted successfully')),
                  );
                } catch (e) {
                  snacker.showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete pet profile')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
