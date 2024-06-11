import 'package:flutter/material.dart';
import 'package:petpulse/api/api.dart';
import 'package:logger/logger.dart';
import 'package:petpulse/views/screens/auth pages/password_change.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger logger = Logger();

class AuthModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  bool _isLoggedIn = false;
  bool _isSigningUp = false;
  bool _passwordVisible = false;
  bool _isSendingResetCode = false;
  bool _isButtonEnabled = false;
  bool _isPasswordChanged = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool _shouldShowElevation = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isSigningUp => _isSigningUp;
  bool get passwordVisible => _passwordVisible;
  bool get isSendingResetCode => _isSendingResetCode;
  bool get isButtonEnabled => _isButtonEnabled;
  bool get isPasswordChanged => _isPasswordChanged;
  bool get shouldShowElevation => _shouldShowElevation;

  AuthModel() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  void setShouldShowElevation(bool value) {
    _shouldShowElevation = value;
    notifyListeners();
  }

  void updateElevationBasedOnValidation(bool hasError, bool isFocused) {
    setShouldShowElevation(!hasError && isFocused);
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }

  void setLoggedIn(bool value) async {
    _isLoggedIn = value;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  void setPasswordChanged(bool value) {
    _isPasswordChanged = value;
    notifyListeners();
  }

  void setSigningUp(bool value) {
    _isSigningUp = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    newPasswordVisible = !newPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  void setButtonEnabled(bool isEnabled) {
    _isButtonEnabled = isEnabled;
    notifyListeners();
  }

  Future<void> handleSignUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    try {
      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        _showErrorSnackBar('All fields are required', scaffoldKey);
        return;
      }
      if (password.length < 8) {
        _showErrorSnackBar(
            'Password must be at least 8 characters long', scaffoldKey);
        return;
      }
      final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailPattern.hasMatch(email)) {
        _showErrorSnackBar('Please enter a valid email address', scaffoldKey);
        return;
      }

      final user = await Api.register(firstName, lastName, email, password);
      if (user != null) {
        setLoggedIn(true);
        _showSuccessSnackBar('Signup successful', scaffoldKey);
        logger.i('User registered successfully: $user');
      } else {
        _showErrorSnackBar('User already exists', scaffoldKey);
      }
    } catch (error) {
      _showErrorSnackBar('Signup failed: $error', scaffoldKey);
      logger.e('Signup failed: $error');
    }
  }

  final Logger logger = Logger();

  void _showErrorSnackBar(
      String message, GlobalKey<ScaffoldState>? scaffoldKey) {
    logger.d('Error Snackbar: $message');
    if (scaffoldKey != null && scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      logger.e('Error: Scaffold key or context is null');
    }
  }

  void _showSuccessSnackBar(
      String message, GlobalKey<ScaffoldState> scaffoldKey) {
    logger.d('Success Snackbar: $message');
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<bool> handleLogin({
    required String email,
    required String password,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    try {
      final user = await Api.login(email, password);
      if (user != null) {
        setLoggedIn(true);
        _showSuccessSnackBar('Login successful', scaffoldKey);
        logger.i('User logged in successfully: $user');
        return true; // Login successful
      } else {
        _showErrorSnackBar(
            'Login failed. Please check your credentials.', scaffoldKey);
        return false; // Login failed
      }
    } catch (error) {
      _showErrorSnackBar(
          'Login failed. Please check your credentials ', scaffoldKey);
      logger.e('Login failed: $error');
      return false; // Login failed
    }
  }

  Future<void> handleForgetPassword({
    required String email,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required VoidCallback onResetCodeSent,
  }) async {
    try {
      _isSendingResetCode = true;
      notifyListeners();
      final response = await Api.forgotPassword(email);
      if (response != null && response.containsKey('resetCode')) {
        _showSuccessSnackBar('Reset code sent successfully', scaffoldKey);
        onResetCodeSent();
      } else if (response != null && response.containsKey('message')) {
        _showErrorSnackBar(response['message'], scaffoldKey);
      } else {
        _showErrorSnackBar('An unexpected error occurred', scaffoldKey);
      }
    } catch (error) {
      _showErrorSnackBar('An unexpected error occurred', scaffoldKey);
      logger.e('Forget password failed: $error');
    } finally {
      _isSendingResetCode = false;
      notifyListeners();
    }
  }

  Future<void> handleVerifyCode(
      String? code, void Function(String) showSnackBar) async {
    if (code == null || code.isEmpty) {
      logger.d("Empty code detected. Showing snackbar...");
      showSnackBar('Please enter the verification code.');
      return;
    }

    try {
      Map<String, dynamic>? response;

      response = await Api.verifyResetCode(code);

      if (response != null &&
          response['message'] == 'Reset code verified successfully') {
        _isButtonEnabled = true;
        notifyListeners();
      } else {
        _isButtonEnabled = false;
        notifyListeners();
        showSnackBar('Invalid reset code. Please try again.');
      }
    } catch (error) {
      logger.e('Validate verify code failed: $error');
      showSnackBar('An unexpected error occurred');
    }
  }

  Future<void> handleResetPassword(String newPassword, String confirmPassword,
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) async {
    try {
      if (newPassword != confirmPassword) {
        _showErrorSnackBar('Passwords do not match', scaffoldKey);
        return;
      }

      final bool success =
          await Api.resetPassword(newPassword, confirmPassword);

      if (success && context.mounted) {
        _showSuccessSnackBar('Password reset successfully', scaffoldKey);
        logger.d('Password reset successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PasswordChange()),
        );
      }
    } catch (e) {
      logger.e('Error resetting password:');
    }
  }

  void showSnackbar(
      String message, GlobalKey<ScaffoldMessengerState> scaffoldKey) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
