import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:petpulse/api/api.dart';

class PetProfileProvider with ChangeNotifier {
  String _petName = '';
  Uint8List? _petImage;
  final List<Map<String, dynamic>> _moodData = [
    {'mood': 'Happy', 'percentage': 40},
    {'mood': 'Angry', 'percentage': 20},
    {'mood': 'Sad', 'percentage': 10},
    {'mood': 'Relaxed', 'percentage': 30},
  ];

  PetProfileProvider() {
    _loadPetData();
  }

  String get petName => _petName;
  Uint8List? get petImage => _petImage;
  List<Map<String, dynamic>> get moodData => _moodData;

  void _loadPetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var petsData = prefs.getString('petsData') ?? '[]';
    List<dynamic> pets = json.decode(petsData);
    if (pets.isNotEmpty) {
      var latestPet = pets.last;
      _petName = latestPet['petName'];
      String imagePath = latestPet['imagePath'];
      if (File(imagePath).existsSync()) {
        _petImage = File(imagePath).readAsBytesSync();
      }
    } else {
      _petName = 'No Pet Name';
      _petImage = null;
    }
    notifyListeners();
  }

  void setPetName(String name) async {
    _petName = name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var petsData = prefs.getString('petsData') ?? '[]';
    List<dynamic> pets = json.decode(petsData);
    if (pets.isNotEmpty) {
      pets.last['petName'] = name;
      prefs.setString('petsData', json.encode(pets));
    }
    notifyListeners();
  }

  void setPetImage(Uint8List image) async {
    _petImage = image;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var petsData = prefs.getString('petsData') ?? '[]';
    List<dynamic> pets = json.decode(petsData);
    if (pets.isNotEmpty) {
      String imagePath = pets.last['imagePath'];
      File(imagePath).writeAsBytesSync(image);
      prefs.setString('petsData', json.encode(pets));
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setPetImage(imageBytes);
    }
  }

  Future<void> deletePetProfile(String petName) async {
    // Delete from the server
    var response = await Api.deletePetProfile(petName);

    if (response != null && response['success'] == true) {
      // Delete from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var petsData = prefs.getString('petsData') ?? '[]';
      List<dynamic> pets = json.decode(petsData);
      pets.removeWhere((pet) => pet['petName'] == petName);
      prefs.setString('petsData', json.encode(pets));
      _petName = '';
      _petImage = null;
      notifyListeners();
    } else {
      // Handle server error
      throw Exception('Failed to delete pet profile');
    }
  }
}
