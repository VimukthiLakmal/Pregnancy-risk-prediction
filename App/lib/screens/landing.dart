import 'package:flutter/material.dart';
import 'package:pregnancy/components/screen_two.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/screen_one.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController pageController = PageController();
  String buttonText = 'Skip';
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/top.png',
              width: 120,
            ),
          ),
          PageView(
              controller: pageController,
              onPageChanged: (index) {
                currentIndex = index;
                if (index == 2) {
                  buttonText = 'Finish';
                } else {
                  buttonText = 'Skip';
                }
                setState(() {});
              },
              children: const [
                Center(
                    child: ScreenOne(
                  text: 'Welcome',
                  img: 'assets/images/im1.png',
                  text2:
                      'Your trusted partner for a safe and healthy pregnancy journey.',
                )),
                Center(
                    child: ScreenOne(
                  text: 'Educational',
                  img: 'assets/images/im2.png',
                  text2:
                      'The app will provide educational resources to help users learn about maternal health, including articles, videos, and podcasts.',
                )),
                Center(
                    child: ScreenTwo(
                  text: 'Support',
                  img: 'assets/images/im3.png',
                  text2:
                      'The app will provide a community support feature to help users connect with other users, share experiences, and receive support.',
                )),
              ]),
          Container(
              alignment: const Alignment(0, 0.8),
              child: (Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text(buttonText),
                  ),
                  SmoothPageIndicator(controller: pageController, count: 3),
                  currentIndex == 2
                      ? const SizedBox(width: 10)
                      : GestureDetector(
                          onTap: () {
                            pageController.nextPage(
                                duration: const Duration(microseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: const Text('Next'))
                ],
              )))
        ]));
  }
}
