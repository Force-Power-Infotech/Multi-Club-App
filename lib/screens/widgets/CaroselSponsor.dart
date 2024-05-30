import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/priviledge.dart';
import 'package:multi_club_app/bases/api/sponsor.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class CarouselSponsor extends StatefulWidget {
  @override
  _CarouselSponsorState createState() => _CarouselSponsorState();
}

class _CarouselSponsorState extends State<CarouselSponsor> {
  late PageController _pageController;
  late Future<SponsorAPI> _sponsorFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _sponsorFuture = _fetchSponsorData(); // Initialize the Future here
    _startAutoScroll(); // Start auto-scrolling
  }

  Future<SponsorAPI> _fetchSponsorData() async {
    try {
      return await SponsorAPI.details();
    } catch (error) {
      // Error handling
      print('Error fetching SponsorAPI data: $error');
      // Returning an empty SponsorAPI object to avoid null errors
      return SponsorAPI();
    }
  }

  void _startAutoScroll() {
    // Start auto-scrolling every 2 seconds
    Future.delayed(Duration(seconds: 2), () async {
      if (_pageController.hasClients) {
        final int nextPage = (_pageController.page?.round() ?? 0) + 1;
        final SponsorAPI? sponsorData = await _sponsorFuture;
        if (sponsorData != null && sponsorData.images != null) {
          final int itemCount = sponsorData.images!.length;
          _pageController.animateToPage(
            nextPage % itemCount,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _launchMapUrl(String? mapUrl) async {
    if (mapUrl != null && await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      // throw 'Could not launch $mapUrl';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch Map'),
          duration: Duration(seconds: 3), // Adjust as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SponsorAPI>(
      future: _sponsorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // or any loading indicator
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'), // Error message
          );
        } else {
          // Check if snapshot has data
          if (snapshot.hasData && snapshot.data!.images != null) {
            return Container(
              height: 190, // Adjust the height of the carousel as needed
              child: PageView.builder(
                controller: _pageController,
                itemCount: snapshot.data!.images!.length,
                itemBuilder: (context, index) {
                  // Check if data exists at index
                  if (index < snapshot.data!.images!.length &&
                      index < snapshot.data!.hyperlinks!.length) {
                    return GestureDetector(
                      onTap: () async {
                        String url = snapshot.data!.hyperlinks![index];
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Could not launch URL'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    snapshot.data!.images![index],
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Show a grey placeholder if image is not available or link is invalid
                                      return Container(
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Return a placeholder or empty container if data is missing
                    return SizedBox.shrink();
                  }
                },
              ),
            );
          } else {
            // Return a placeholder or empty container if no data
            return SizedBox.shrink();
          }
        }
      },
    );
  }
}
