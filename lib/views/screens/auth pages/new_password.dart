import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/auth_provider.dart';

final TextEditingController newPasswordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class NewPassword extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  NewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (_) => AuthModel(),
      child: Scaffold(
        key: scaffoldKey,
        body: PopScope(
          canPop: true,
          onPopInvoked: (_) async {
            newPasswordController.clear();
            confirmPasswordController.clear();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                _buildLogo(context),
                _buildBackButton(context),
                Consumer<AuthModel>(
                  builder: (context, authProvider, child) {
                    return _buildPasswordChangeInForm(context, authProvider);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Positioned(
      top: 47,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Image.asset(
              "assets/LOGO 1.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 129),
          buildNewPasswordText(),
        ],
      ),
    );
  }

  Positioned _buildBackButton(BuildContext context) {
    return Positioned(
      top: 76,
      left: 20,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new),
        color: const Color.fromARGB(255, 22, 188, 58),
      ),
    );
  }

  Widget _buildPasswordChangeInForm(
      BuildContext context, AuthModel authProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 350.0, 12.0, 12.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align labels to the start (left)
          children: [
            const SizedBox(height: 8),
            const Text(
              "Enter New Password",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordFormField(
                "Enter New Password", newPasswordController, authProvider),
            const SizedBox(height: 32),
            const Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildPasswordFormField(
                "Confirm Password", confirmPasswordController, authProvider),
            const SizedBox(height: 56),
            Center(
              child: _buildPasswordChangeButton(context, authProvider),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildNewPasswordText() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF32CD32),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordFormField(String fieldLabel,
      TextEditingController controller, AuthModel authProvider) {
    return Consumer<AuthModel>(
      builder: (context, model, child) {
        return Material(
          elevation: model.shouldShowElevation ? 3.0 : 0.0,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            controller: controller,
            obscureText: !authProvider.passwordVisible,
            cursorColor: Colors.black,
            decoration: _inputDecoration('*************').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  authProvider.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () => authProvider.togglePasswordVisibility(),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: const Color(0xFF171212).withOpacity(1.0),
          fontSize: 15,
          fontWeight: FontWeight.w500),
      filled: true,
      fillColor: const Color(0xFF00AF19).withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildPasswordChangeButton(
      BuildContext context, AuthModel authProvider) {
    return _buildButton(
      text: "Create new password",
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          Provider.of<AuthModel>(context, listen: false)
              .setShouldShowElevation(true);
          await authProvider.handleResetPassword(
            newPasswordController.text,
            confirmPasswordController.text,
            scaffoldKey,
            context,
          );
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else {
          Provider.of<AuthModel>(context, listen: false)
              .setShouldShowElevation(false);
        }
      },
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 251,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF00AF19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
