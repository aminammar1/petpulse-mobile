import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petpulse/api/api.dart';
import 'package:logger/logger.dart';
import 'package:petpulse/views/screens/welcome_screen.dart';

class AccountManagementProvider with ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  Future<void> fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstNameController.text = prefs.getString('firstName') ?? '';
    lastNameController.text = prefs.getString('lastName') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    notifyListeners();
  }

  Future<void> updateUserInfo(String userId, BuildContext context) async {
    final scaf = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      Map<String, String> updatedFields = {};

      if (emailController.text.isNotEmpty) {
        updatedFields['email'] = emailController.text;
      }
      if (passwordController.text.isNotEmpty) {
        updatedFields['password'] = passwordController.text;
      }
      if (firstNameController.text.isNotEmpty) {
        updatedFields['firstName'] = firstNameController.text;
      }
      if (lastNameController.text.isNotEmpty) {
        updatedFields['lastName'] = lastNameController.text;
      }

      if (updatedFields.isEmpty) {
        throw Exception('At least one field must be filled');
      }

      final response = await Api.updateUser(userId, updatedFields);

      if (response != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (updatedFields.containsKey('firstName')) {
          await prefs.setString('firstName', updatedFields['firstName']!);
        }
        if (updatedFields.containsKey('lastName')) {
          await prefs.setString('lastName', updatedFields['lastName']!);
        }
        if (updatedFields.containsKey('email')) {
          await prefs.setString('email', updatedFields['email']!);
        }
        if (updatedFields.containsKey('password')) {}
        notifyListeners();

        scaf.showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception('Failed to update user info');
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> deleteUser(String userId, BuildContext context) async {
    final nav = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    try {
      final response = await Api.deleteUser(userId);

      if (response != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        nav.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      notifyListeners();
    }
  }

  void setFirstName(String firstName) {
    firstNameController.text = firstName;
    notifyListeners();
  }

  void setLastName(String lastName) {
    lastNameController.text = lastName;
    notifyListeners();
  }

  void setEmail(String email) {
    emailController.text = email;
    notifyListeners();
  }

  void setPassword(String password) {
    passwordController.text = password;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}
