import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/sponsor.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class SlideshowWidget extends StatefulWidget {
  const SlideshowWidget({super.key});

  @override
  _SlideshowWidgetState createState() => _SlideshowWidgetState();
}

class _SlideshowWidgetState extends State<SlideshowWidget> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  List<String> _imagePaths = []; // Use dynamic list for image paths
  List<String> _hyperlinks = []; // Use dynamic list for hyperlinks

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
    // Fetch image paths and hyperlinks from SponsorAPI
    SponsorAPI sponsorData = await SponsorAPI.details();
    List<String> imageHyperlinks = sponsorData.images ?? [];
    List<String> hyperlinks = sponsorData.hyperlinks ?? [];
    setState(() {
      _imagePaths = List<String>.from(
          imageHyperlinks.skip(1)); // Skip the first image hyperlink
      _hyperlinks =
          List<String>.from(hyperlinks.skip(1)); // Copy all hyperlinks
    });
  }

  void startSlideshow() {
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients &&
          _pageController.position.maxScrollExtent > 0) {
        if (_currentPageIndex < _imagePaths.length - 1) {
          _currentPageIndex++;
        } else {
          _currentPageIndex = 0;
        }
        _pageController.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 30, // Height of the container
        child: PageView.builder(
          controller: _pageController,
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Launch the corresponding hyperlink when image is tapped
                print(_hyperlinks[index]);

                if (index < _hyperlinks.length) {
                  launch(_hyperlinks[index]);
                }
              },
              child: Image.network(
                _imagePaths[index], // Load image from image path list
                fit: BoxFit.contain,
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
