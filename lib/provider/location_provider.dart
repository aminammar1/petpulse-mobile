import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';

class LocationProvider with ChangeNotifier {
  LatLng? _userLocation;
  LatLng? _petLocation;
  final Random _random = Random();
  bool _isReady = false; // Tracks if the provider is ready

  Timer? _locationUpdateTimer;
  double _zoomLevel = 13.0; // Default zoom level

  LatLng? get userLocation => _userLocation;
  LatLng? get petLocation => _petLocation;
  bool get isReady => _isReady;
  double get zoomLevel => _zoomLevel;

  LocationProvider() {
    _initialize();
  }

  void _initialize() async {
    await _fetchInitialLocation();
    _locationUpdateTimer = Timer.periodic(
        const Duration(seconds: 2), // Consider adjusting the frequency
        (_) => updateLocation());
    _isReady = true;
    notifyListeners();
  }

  Future<void> _fetchInitialLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    Position position = await Geolocator.getCurrentPosition();
    _userLocation = LatLng(position.latitude, position.longitude);
    _petLocation = updateCoordinates(_userLocation!, 0.001);
  }

  void updateLocation() async {
    if (!_isReady) return;

    Position position = await Geolocator.getCurrentPosition();
    _userLocation = LatLng(position.latitude, position.longitude);
    _petLocation = updateCoordinates(_petLocation!, 0.0001);

    notifyListeners();
  }

  void setZoomLevel(double zoom) {
    _zoomLevel = zoom;
    notifyListeners();
  }

  LatLng updateCoordinates(LatLng coordinates, double range) {
    double deltaLat = (_random.nextDouble() * range * 2) - range;
    double deltaLong = (_random.nextDouble() * range * 2) - range;
    return LatLng(
        coordinates.latitude + deltaLat, coordinates.longitude + deltaLong);
  }

  double calculateDistance() {
    if (!_isReady) return 0;
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, _userLocation!, _petLocation!);
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }
}
