// presentation/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _OnboardingSlide(
                  image: 'assets/onboarding1.png',
                  title: 'Track Your Expenses',
                  description: 'Easily log and categorize your daily expenses.',
                ),
                _OnboardingSlide(
                  image: 'assets/onboarding2.png',
                  title: 'Set Budgets',
                  description: 'Define monthly budgets and avoid overspending.',
                ),
                _OnboardingSlide(
                  image: 'assets/onboarding3.png',
                  title: 'Save Smartly',
                  description: 'Set savings goals and track your progress.',
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: WormEffect(
              activeDotColor: Colors.blue,
              dotColor: Colors.grey[300]!,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_currentPage == 2) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}