import 'package:flutter/material.dart';
import 'dart:io';

class PetSelectionState extends ChangeNotifier {
  bool _isDogSelected = false;
  bool _isCatSelected = false;
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  DateTime? _selectedDate;
  File? _selectedImage;
  String? _petName;
  String? _petDescription;

  bool get isDogSelected => _isDogSelected;
  bool get isCatSelected => _isCatSelected;
  bool get isMaleSelected => _isMaleSelected;
  bool get isFemaleSelected => _isFemaleSelected;
  DateTime? get selectedDate => _selectedDate;
  File? get selectedImage => _selectedImage;
  String? get petName => _petName;
  String? get petDescription => _petDescription;

  void selectDog() {
    _isDogSelected = true;
    _isCatSelected = false;
    notifyListeners();
  }

  void selectCat() {
    _isDogSelected = false;
    _isCatSelected = true;
    notifyListeners();
  }

  void deselectAll() {
    _isDogSelected = false;
    _isCatSelected = false;
    notifyListeners();
  }

  void deselectDog() {
    _isDogSelected = false;
    notifyListeners();
  }

  void deselectCat() {
    _isCatSelected = false;
    notifyListeners();
  }

  void selectMale() {
    _isMaleSelected = true;
    _isFemaleSelected = false;
    notifyListeners();
  }

  void selectFemale() {
    _isMaleSelected = false;
    _isFemaleSelected = true;
    notifyListeners();
  }

  void deselectMale() {
    _isMaleSelected = false;
    notifyListeners();
  }

  void deselectFemale() {
    _isFemaleSelected = false;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void updateSelectedImage(File image) {
    _selectedImage = image;
    notifyListeners();
  }

  void updatePetName(String name) {
    _petName = name;
    notifyListeners();
  }

  void updatePetDescription(String description) {
    _petDescription = description;
    notifyListeners();
  }
}
