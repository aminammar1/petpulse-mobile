import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/auth_provider.dart';
import 'forget_password.dart';
import 'package:petpulse/views/screens/pet profile/pet_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:petpulse/provider/carousel_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final mainColor = const Color(0xFF00AF19).withOpacity(0.15);

class Login extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarouselModel()),
        ChangeNotifierProvider(create: (_) => AuthModel()),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        body: PopScope(
          canPop: true,
          onPopInvoked: (_) async {
            emailController.clear();
            passwordController.clear();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                _buildLogo(context),
                Consumer<CarouselModel>(
                  builder: (context, carouselModel, child) {
                    return _buildCarouselWithIndicator(size, carouselModel);
                  },
                ),
                _buildBackButton(context),
                Consumer<AuthModel>(
                  builder: (context, authProvider, child) {
                    return _buildSignInForm(context, authProvider);
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
      left: 129,
      right: 130,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Image.asset(
          "assets/LOGO 1.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCarouselWithIndicator(Size size, CarouselModel carouselModel) {
    return Positioned(
      top: size.height * 0.2,
      left: 0,
      right: 0,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.3,
            child: PageView.builder(
              controller: carouselModel.pageController1,
              itemCount: carouselModel.imageList1.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  carouselModel.imageList1[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: carouselModel.pageController1,
            count: carouselModel.imageList1.length,
            effect: const WormEffect(
              dotHeight: 16,
              dotWidth: 16,
              activeDotColor: Colors.green,
              dotColor: Colors.grey,
            ),
            onDotClicked: (index) {
              carouselModel.pageController1.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
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

  Widget _buildSignInForm(BuildContext context, AuthModel authProvider) {
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
            const SizedBox(height: 27),
            _buildPasswordFormField(authProvider),
            const SizedBox(height: 56),
            _buildSignInButton(context),
            const SizedBox(height: 10),
            _buildForgotPasswordButton(context),
            const SizedBox(height: 9),
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
            decoration: _inputDecoration('email'),
            cursorColor: Colors.black,
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

  Widget _buildPasswordFormField(AuthModel authProvider) {
    return Consumer<AuthModel>(
      builder: (context, model, child) {
        return Material(
          elevation: model.shouldShowElevation ? 3.0 : 0.0,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            controller: passwordController,
            obscureText: !authProvider.passwordVisible,
            cursorColor: Colors.black,
            decoration: _inputDecoration('Password').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  authProvider.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey, // Set your preferred icon color here
                ),
                onPressed: () => authProvider.togglePasswordVisibility(),
                splashColor:
                    Colors.transparent, // Prevents splash effect color on click
                highlightColor:
                    Colors.transparent, // Prevents highlight color on click
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return _buildButton(
      text: "Sign In",
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          Provider.of<AuthModel>(context, listen: false)
              .setShouldShowElevation(true);
          await _handleSignIn(context);
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

  TextButton _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgetPassword()),
        );
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            decoration: TextDecoration.underline,
            decorationColor: Colors.black, // Change the color as needed
            decorationThickness: 1),
      ),
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

  Future<void> _handleSignIn(BuildContext context) async {
    final navigator = Navigator.of(context);
    final authProvider = Provider.of<AuthModel>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      EasyLoading.show(status: 'Loading...');
      final loginSuccess = await authProvider.handleLogin(
        email: email,
        password: password,
        scaffoldKey: _scaffoldKey,
      );
      EasyLoading.dismiss();

      if (loginSuccess) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => const PetScreen(),
          ),
        );
      }
    }
  }
}
