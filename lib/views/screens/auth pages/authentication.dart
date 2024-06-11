import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petpulse/util/animation/fadeanimation.dart';
import 'package:petpulse/provider/googleauth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'signup.dart';
import 'userinfo.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:petpulse/provider/carousel_provider.dart';

class Authentication extends StatelessWidget {
  final AuthService _authService = AuthService();

  Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CarouselModel>(
      create: (_) => CarouselModel(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildLogo(MediaQuery.of(context).size),
            Consumer<CarouselModel>(
              builder: (context, carouselModel, child) {
                return _buildCarouselWithIndicator(
                    MediaQuery.of(context).size, carouselModel);
              },
            ),
            _buildBackButton(context),
            _buildAuthButtons(context, MediaQuery.of(context).size),
          ],
        ),
      ),
    );
  }

  Positioned _buildLogo(Size size) {
    return Positioned(
      top: 47,
      left: 129,
      right: 130,
      child: SizedBox(
        height: size.height * 0.1,
        child: Image.asset("assets/LOGO 1.png", fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildCarouselWithIndicator(Size size, CarouselModel carouselModel) {
    return Positioned(
      top: 150,
      left: 0,
      right: 0,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.3,
            child: PageView.builder(
              controller: carouselModel.pageController2,
              itemCount: carouselModel.imageList2.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  carouselModel.imageList2[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: carouselModel.pageController2,
            count: carouselModel.imageList2.length,
            effect: const WormEffect(
              dotHeight: 16,
              dotWidth: 16,
              activeDotColor: Colors.green,
              dotColor: Colors.grey,
            ),
            onDotClicked: (index) {
              carouselModel.pageController2.animateToPage(
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

  Positioned _buildAuthButtons(BuildContext context, Size size) {
    return Positioned(
      top: size.height * 0.70,
      left: 20,
      right: 20,
      child: Column(
        children: [
          _buildAuthButton(
            context: context,
            label: "Sign In With Google",
            icon: SvgPicture.asset('assets/icons8-google.svg',
                height: 20, width: 19),
            onPressed: () => _signInWithGoogle(context),
            backgroundColor: Colors.white,
            textColor: const Color.fromARGB(255, 10, 8, 8),
            borderColor: Colors.black,
            delay: 2,
          ),
          const SizedBox(height: 20),
          _buildAuthButton(
            context: context,
            label: "Sign Up",
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signup())),
            backgroundColor: const Color(0xFF00AF19),
            delay: 2.5,
          ),
          const SizedBox(height: 50),
          FadeInAnimation(
            delay: 2.5,
            child: TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login())),
              child: const Text(
                "Sign in with email",
                style: TextStyle(
                  fontSize: 12, color: Colors.black,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black, // Change the color as needed
                  decorationThickness: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    double delay = 2,
    Widget? icon,
    Color textColor = Colors.white,
    Color? borderColor,
  }) {
    return SizedBox(
      height: 45,
      width: 260,
      child: FadeInAnimation(
        delay: delay,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon ?? const SizedBox.shrink(),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Urbanist-SemiBold",
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 2.0,
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: borderColor != null
                  ? BorderSide(color: borderColor)
                  : BorderSide.none,
            ),
            padding: const EdgeInsets.symmetric(vertical: 13.0),
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle(BuildContext context) async {
    await _authService.signInWithGoogle();
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const UserProfileScreen()));
    }
  }
}
