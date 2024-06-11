import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:petpulse/provider/auth_provider.dart';
import 'new_password.dart';
import 'package:flutter/gestures.dart';
import 'package:petpulse/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class VerifyPassword extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  VerifyPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (_) => AuthModel(),
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: SizedBox(
            child: Stack(
              children: [
                _buildLogo(context),
                _buildBackButton(context),
                Consumer<AuthModel>(
                  builder: (context, authProvider, child) {
                    return _buildVerificationForm(context);
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
          buildForgetPasswordText(),
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

  Widget _buildVerificationForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 450.0, 12.0, 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          _buildPinCodeField(context),
          const SizedBox(height: 55),
          _buildResendCodeText(context),
          const SizedBox(height: 56),
          _buildVerifyPasswordButton(context),
        ],
      ),
    );
  }

  Widget _buildPinCodeField(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    return PinCodeTextField(
      appContext: context,
      length: 6,
      onChanged: (String value) {
        if (value.isEmpty) {
          authModel.setButtonEnabled(false);
          _showSnackBar('Please enter the verification code.', context);
        } else {
          authModel.setButtonEnabled(true);
        }
      },
      onCompleted: (String? value) => authModel.handleVerifyCode(
          value, (message) => _showSnackBar(message, context)),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(33.1),
        fieldHeight: 33.1,
        fieldWidth: 33.1,
        activeFillColor: Colors.white,
        inactiveColor: Colors.black54,
        selectedColor: Colors.black54,
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      keyboardType: TextInputType.number,
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
              "Verification",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF32CD32),
              ),
            ),
          ],
        ),
        SizedBox(height: 94), // Adjust height as necessary
        Text(
          "Enter Verification Code", // This text stays in the column
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  RichText _buildResendCodeText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "If you didn't receive a code, ",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Resend',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF32CD32),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? email = prefs.getString('resetEmail');
                if (email != null) {
                  var result = await Api.forgotPassword(email);
                  Logger().d(result);
                } else {
                  Logger().e('Email not found');
                }
              },
          )
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    void Function()? onPressed,
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

  Widget _buildVerifyPasswordButton(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context, listen: false);

    return _buildButton(
      text: "Send",
      onPressed: () {
        if (authModel.isButtonEnabled) {
          _navigateToNewPassword(context);
        }
      },
    );
  }

  void _navigateToNewPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPassword()),
    );
  }

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
