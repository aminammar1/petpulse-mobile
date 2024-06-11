import 'dart:async';
import 'package:flutter/material.dart';

class CarouselModel with ChangeNotifier {
  final PageController pageController1 = PageController(viewportFraction: 1);
  final PageController pageController2 = PageController(viewportFraction: 1);
  final PageController pageController3 = PageController(viewportFraction: 1);
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;

  final List<String> imageList1 = [
    'assets/dog image.png',
    'assets/pets-3715733_1280.jpg',
    'assets/pexels-pixabay-45170 (2).jpg',
  ];
  final List<String> imageList2 = [
    'assets/pexels-goochie-poochie-grooming-3361739 1.png',
    'assets/dog and cat.jpeg',
    'assets/image3.jpeg',
  ];
  final List<String> imageList3 = [
    'assets/image2.png',
    'assets/pic2.jpeg',
    'assets/pexels-johann-1254140.jpg',
  ];

  CarouselModel() {
    _autoSlide(pageController1, imageList1, _timer1);
    _autoSlide(pageController2, imageList2, _timer2);
    _autoSlide(pageController3, imageList3, _timer3);
  }

  void _autoSlide(
      PageController controller, List<String> images, Timer? timer) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (controller.hasClients) {
          int nextPage = controller.page!.toInt() + 1;
          if (nextPage >= images.length) {
            nextPage = 0;
          }
          controller.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    pageController1.dispose();
    pageController2.dispose();
    pageController3.dispose();
    super.dispose();
  }
}
