import 'dart:async';
import 'package:flutter/material.dart';

class SlideshowWidget extends StatefulWidget {
  @override
  _SlideshowWidgetState createState() => _SlideshowWidgetState();
}

class _SlideshowWidgetState extends State<SlideshowWidget> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final List<String> _imagePaths = [
    'assets/images/demologo.png',
    'assets/images/demo-logo.png',
    'assets/images/sponsordemo1.png',
  ];

  @override
  void initState() {
    super.initState();
    // Start the slideshow
    startSlideshow();
  }

  void startSlideshow() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPageIndex < _imagePaths.length - 1) {
        _currentPageIndex++;
      } else {
        _currentPageIndex = 0;
      }
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 30, // Height of the container
        color: Colors.transparent,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            return Container(
              height: 30, // Height of the red bar
              decoration: BoxDecoration(
                color: Colors.transparent, // Red color for the bar
                borderRadius: BorderRadius.circular(5), // Round edges
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/demo-logo.png'), // Path to your image asset
                  fit: BoxFit
                      .contain, // Cover the entire container with the image
                ),
              ),
            );
          },
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
