import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/priviledge.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late PageController _pageController;
  late Future<PriviledgeAPI> _priviledgeFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _priviledgeFuture = _fetchPriviledgeData(); // Initialize the Future here
    _startAutoScroll(); // Start auto-scrolling
  }

  Future<PriviledgeAPI> _fetchPriviledgeData() async {
    try {
      return await PriviledgeAPI.details();
    } catch (error) {
      // Error handling
      print('Error fetching PriviledgeAPI data: $error');
      // Returning an empty PriviledgeAPI object to avoid null errors
      return PriviledgeAPI();
    }
  }

  void _startAutoScroll() {
    // Start auto-scrolling every 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      if (_pageController.hasClients) {
        final int nextPage = (_pageController.page?.round() ?? 0) + 1;
        final PriviledgeAPI priviledgeData = await _priviledgeFuture;
        if (priviledgeData != null && priviledgeData.imageUrlArray != null) {
          final int itemCount = priviledgeData.imageUrlArray!.length;
          _pageController.animateToPage(
            nextPage % itemCount,
            duration: const Duration(milliseconds: 500),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch Map'),
          duration: Duration(seconds: 3), // Adjust as needed
        ),
      );
    }
  }

  void _showDetailsBottomSheet(
      BuildContext context, int index, PriviledgeAPI data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                  bottom: Radius.zero,
                ),
                child: Image.network(
                  data.imageUrlArray![index],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      width: double.infinity,
                      height: 200,
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.nameArray![index],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.descriptionArray![index],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${data.discountArray![index]} OFF",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchMapUrl(data.locationUrlArray![index]);
                      },
                      child: const Text('View on Map'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PriviledgeAPI>(
      future: _priviledgeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // or any loading indicator
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'), // Error message
          );
        } else {
          // Check if snapshot has data
          if (snapshot.hasData) {
            return SizedBox(
              height: 194, // Adjust the height of the carousel as needed
              child: PageView.builder(
                controller: _pageController,
                itemCount: snapshot.data!.imageUrlArray?.length ?? 0,
                itemBuilder: (context, index) {
                  // Check if data exists at index
                  if (snapshot.data!.imageUrlArray != null &&
                      snapshot.data!.nameArray != null &&
                      snapshot.data!.descriptionArray != null &&
                      snapshot.data!.discountArray != null &&
                      index < snapshot.data!.imageUrlArray!.length &&
                      index < snapshot.data!.nameArray!.length &&
                      index < snapshot.data!.descriptionArray!.length &&
                      index < snapshot.data!.discountArray!.length) {
                    return GestureDetector(
                      onTap: () => _showDetailsBottomSheet(
                          context, index, snapshot.data!),
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
                                    snapshot.data!.imageUrlArray![index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Show a grey placeholder if image is not available or link is invalid
                                      return Container(
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data!.nameArray![index],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                snapshot.data!
                                                    .descriptionArray![index],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                                maxLines:
                                                    1, // Limit to a maximum of 1 line
                                                overflow: TextOverflow
                                                    .ellipsis, // Handle overflow with ellipsis (...)
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Add some space between the text and the container
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              _launchMapUrl(snapshot.data!
                                                  .locationUrlArray![index]);
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "${snapshot.data!.discountArray![index]} OFF",
                                          style: const TextStyle(
                                            fontSize: 38,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Return a placeholder or empty container if data is missing
                    return const SizedBox.shrink();
                  }
                },
              ),
            );
          } else {
            // Return a placeholder or empty container if no data
            return const SizedBox.shrink();
          }
        }
      },
    );
  }
}
