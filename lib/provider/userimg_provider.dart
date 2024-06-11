import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageProviderModel with ChangeNotifier {
  File? _image;

  File? get image => _image;

  ImageProviderModel() {
    loadImage();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
      saveImage(pickedFile.path);
    }
  }

  Future<void> saveImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      _image = File(imagePath);
      notifyListeners();
    }
  }

  Future<void> removeImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
    _image = null;
    notifyListeners();
  }
}
