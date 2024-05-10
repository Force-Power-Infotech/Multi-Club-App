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
    startSlideshow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void startSlideshow() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients &&
          _pageController.position.maxScrollExtent > 0) {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 30, // Height of the container
        child: PageView.builder(
          controller: _pageController,
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            return Image.asset(
              _imagePaths[index], // Load image from image path list
              fit: BoxFit.contain,
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
