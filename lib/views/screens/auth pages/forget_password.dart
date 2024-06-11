import 'package:flutter/material.dart';
import 'package:petpulse/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'verification_password.dart';
import 'signup.dart';

class ForgetPassword extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ForgetPassword({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (_) => AuthModel(),
      child: Scaffold(
        key: _scaffoldKey,
        body: PopScope(
          canPop: true,
          onPopInvoked: (_) async {
            emailController.clear();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                _buildLogo(context),
                _buildBackButton(context),
                Consumer<AuthModel>(
                  builder: (context, authProvider, child) {
                    return _buildForgetPasswordForm(context);
                  },
                )
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
          buildForgetPasswordText(),
        ],
      ),
    );
  }

  Widget _buildForgetPasswordForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 450.0, 12.0, 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            _buildEmailFormField(context),
            const SizedBox(height: 18),
            _buildtextButton(context),
            const SizedBox(height: 56),
            _buildForgetPasswordButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailFormField(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, model, child) {
        return Material(
          elevation: model.shouldShowElevation ? 3.0 : 0.0,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            controller: emailController,
            decoration: _inputDecoration('example@example.com'),
            cursorColor: Colors.black,
            textAlign: TextAlign.center,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  Widget buildForgetPasswordText() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forget Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF32CD32),
              ),
            ),
          ],
        ),
        SizedBox(height: 143),
        Text(
          "Enter Email Address",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
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

  Widget _buildForgetPasswordButton(BuildContext context) {
    return _buildButton(
      text: "Send",
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Provider.of<AuthModel>(context, listen: false)
              .setShouldShowElevation(true);
          await _handleForgetPassword(context);
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  TextButton _buildtextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      },
      child: const Text(
        "back to sign in ",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            decoration: TextDecoration.underline,
            decorationColor: Colors.black,
            decorationThickness: 1),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: const Color(0xFF171212).withOpacity(1.0),
          fontSize: 16,
          fontWeight: FontWeight.w400),
      filled: true,
      fillColor: const Color(0xFF00AF19).withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Future<void> _handleForgetPassword(BuildContext context) async {
    final authProvider = Provider.of<AuthModel>(context, listen: false);
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        final email = emailController.text;
        await authProvider.handleForgetPassword(
          scaffoldKey: _scaffoldKey,
          email: email,
          onResetCodeSent: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyPassword(),
              ),
            );
          },
        );
      }
    }
  }
}
