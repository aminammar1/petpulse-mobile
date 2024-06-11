import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/auth_provider.dart';
import 'package:logger/logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:petpulse/provider/carousel_provider.dart';

final Color mainColor = const Color(0xFF00AF19).withOpacity(0.15);
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
final Logger logger = Logger();
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class Signup extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarouselModel()),
        ChangeNotifierProvider(create: (_) => AuthModel()),
      ],
      child: Scaffold(
        key: scaffoldKey,
        body: PopScope(
          canPop: true,
          onPopInvoked: (_) async {
            firstNameController.clear();
            lastNameController.clear();
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
                Consumer<AuthModel>(builder: (context, authProvider, child) {
                  return _buildSignupForm(context, authProvider);
                }),
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
              controller: carouselModel.pageController3,
              itemCount: carouselModel.imageList3.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  carouselModel.imageList3[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: carouselModel.pageController3,
            count: carouselModel.imageList3.length,
            effect: const WormEffect(
              dotHeight: 16,
              dotWidth: 16,
              activeDotColor: Colors.green,
              dotColor: Colors.grey,
            ),
            onDotClicked: (index) {
              carouselModel.pageController3.animateToPage(
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

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 76,
      left: 20,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: const Color.fromARGB(255, 22, 188, 58),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context, AuthModel authProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 450.0, 12.0, 12.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextField(firstNameController, 'First Name',
                'Please enter your first name'),
            const SizedBox(height: 10),
            _buildTextField(
                lastNameController, 'Last Name', 'Please enter your last name'),
            const SizedBox(height: 10),
            _buildTextField(emailController, 'Email', 'Please enter your email',
                emailValidator),
            const SizedBox(height: 10),
            _buildPasswordField(passwordController, authProvider),
            const SizedBox(height: 20),
            _buildButton("Create Account",
                () => _handleSignUp(context, scaffoldKey, authProvider)),
            const SizedBox(height: 10),
            const Text(
              "By continuing you agree to terms and conditions",
              style: TextStyle(
                fontSize: 12, color: Colors.grey,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black, // Change the color as needed
                decorationThickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, String emptyMessage,
      [FormFieldValidator<String>? validator]) {
    return Consumer<AuthModel>(
      builder: (context, model, child) {
        return Material(
          elevation: model.shouldShowElevation ? 3.0 : 0.0,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            controller: controller,
            obscureText: hintText == 'Password',
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: _inputDecoration(hintText),
            validator: validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return emptyMessage;
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
      hintStyle: const TextStyle(
          color: Color(0xFF171212), fontSize: 15, fontWeight: FontWeight.w500),
      filled: true,
      fillColor: const Color(0xFF00AF19).withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, AuthModel authProvider) {
    return Consumer<AuthModel>(
      builder: (context, model, child) {
        return Material(
          elevation: model.shouldShowElevation ? 3.0 : 0.0,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            controller: controller,
            obscureText: !authProvider.passwordVisible,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: _inputDecoration('Password').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  authProvider.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0x00000000).withOpacity(1.0),
                ),
                onPressed: authProvider.togglePasswordVisibility,
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

  Widget _buildButton(String text, VoidCallback onPressed) {
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

Future<void> _handleSignUp(BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey, AuthModel authProvider) async {
  if (formKey.currentState!.validate()) {
    Provider.of<AuthModel>(context, listen: false).setShouldShowElevation(true);
    await authProvider.handleSignUp(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
      scaffoldKey: scaffoldKey,
    );
  } else {
    Provider.of<AuthModel>(context, listen: false)
        .setShouldShowElevation(false);
  }
}

FormFieldValidator<String> emailValidator = (value) {
  final RegExp emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (!emailPattern.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
};
