import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/sponsor.dart';

class SlideshowWidget extends StatefulWidget {
  @override
  _SlideshowWidgetState createState() => _SlideshowWidgetState();
}

class _SlideshowWidgetState extends State<SlideshowWidget> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<String> _imagePaths = []; // Use dynamic list for image paths

  @override
  void initState() {
    super.initState();
    fetchImagePaths(); // Fetch image paths from SponsorAPI
    startSlideshow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void fetchImagePaths() async {
    // Fetch image paths from SponsorAPI
    SponsorAPI sponsorData = await SponsorAPI.details();
    setState(() {
      _imagePaths =
          List.from(sponsorData.images as Iterable); // Copy image paths
      _imagePaths.removeAt(0); // Exclude the first image path
    });
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
            return Image.network(
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
