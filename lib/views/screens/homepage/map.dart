import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:petpulse/provider/googleauth.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationProvider>(
      create: (_) => LocationProvider(),
      child: Consumer<LocationProvider>(
        builder: (context, locationModel, child) {
          final userLocation = locationModel.userLocation ?? const LatLng(0, 0);
          final petLocation = locationModel.petLocation ?? const LatLng(0, 0);
          final currentZoom = locationModel.zoomLevel;

          if (!locationModel.isReady || locationModel.userLocation == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController.move(locationModel.userLocation!, currentZoom);
          });
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: const Text('Pet Location',
                  style: TextStyle(color: Colors.white)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.zoom_in, color: Colors.white),
                  onPressed: () {
                    locationModel.setZoomLevel(currentZoom + 1);
                    mapController.move(
                        mapController.camera.center, currentZoom + 1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out, color: Colors.white),
                  onPressed: () {
                    locationModel.setZoomLevel(currentZoom - 1);
                    mapController.move(
                        mapController.camera.center, currentZoom - 1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: userLocation,
                          initialZoom: currentZoom,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.petpulse',
                          ),
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                'OpenStreetMap contributors',
                                onTap: () => launchUrl(Uri.parse(
                                    'https://openstreetmap.org/copyright')),
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: userLocation,
                                child: Image.asset('assets/costumemarker.png'),
                              ),
                              Marker(
                                point: petLocation,
                                child: Image.asset(
                                  'assets/Group 4.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ],
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: [userLocation, petLocation],
                                strokeWidth: 4.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.25,
                  minChildSize: 0.1,
                  maxChildSize: 0.5,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return _buildBottomSheet(context, scrollController);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet(
      BuildContext context, ScrollController scrollController) {
    var locationProvider = Provider.of<LocationProvider>(context);
    double distance = locationProvider.calculateDistance();

    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final prefs = snapshot.data!;
        var petsData = prefs.getString('petsData') ?? '[]';
        List<dynamic> pets = json.decode(petsData);
        String petName =
            pets.isNotEmpty ? pets.last['petName'] : "No Pet Registered";

        // Fetch username based on authentication method
        String username = prefs.getString('firstName') ?? "User";
        final user = Provider.of<AuthService>(context).user;
        if (user != null && user.displayName != null) {
          username = user.displayName!.split(' ').first;
        }

        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: scrollController,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      petName, // Display the pet name
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${distance.toStringAsFixed(0)} m',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
                Text(
                  'distance between $username and $petName', // Display the username and pet name
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
