import 'package:flutter/material.dart';
import 'messure_result.dart';
import 'new_messure.dart';

final heartrate = NewMeasure(
  name: "Heart rate",
  color: Colors.pink,
  icon: Icons.favorite_border_outlined,
);

final sleep = NewMeasure(
  name: "Sleep",
  color: const Color(0xFFB991EB),
  icon: Icons.nights_stay_outlined,
);
final walk = NewMeasure(
  name: "Walk Activity ",
  color: Colors.cyan,
  icon: Icons.directions_run,
);
final temperature = NewMeasure(
  name: "Temperature",
  color: Colors.red,
  icon: Icons.thermostat_outlined,
);

final List<NewMeasure> measurelist = [
  heartrate,
  sleep,
  walk,
  temperature,
];

final heartrateMeasure = MeasureResult(
  measuredata: heartrate,
  values: 82,
  unit: "bpm",
  isradial: "false",
);
final sleepMeasure = MeasureResult(
  measuredata: sleep,
  values: 6,
  unit: "hr",
  isradial: "true",
);

final walkMeasure = MeasureResult(
  measuredata: walk,
  values: 200,
  unit: "m",
  isradial: "false",
);
final temperatureMeasure = MeasureResult(
  measuredata: temperature,
  values: 37,
  unit: "°C",
  isradial: "true",
);

final List<MeasureResult> measure = [
  heartrateMeasure,
  temperatureMeasure,
  sleepMeasure,
  walkMeasure,
];
