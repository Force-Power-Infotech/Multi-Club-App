import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/priviledge.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class PrivilegeListScreen extends StatefulWidget {
  @override
  _PrivilegeListScreenState createState() => _PrivilegeListScreenState();
}

class _PrivilegeListScreenState extends State<PrivilegeListScreen> {
  late Future<PriviledgeAPI> _priviledgeFuture;

  @override
  void initState() {
    super.initState();
    _priviledgeFuture = _fetchPriviledgeData(); // Initialize the Future here
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

  void _showDetailsBottomSheet(
      BuildContext context, int index, PriviledgeAPI data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.nameArray![index],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    data.descriptionArray![index],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${data.discountArray![index]} OFF",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _launchMapUrl(data.locationUrlArray![index]);
                      },
                      child: Text('View on Map'),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppThemes.brc_textcolor,
          ),
          color: Colors.white, // Set the color to white
        ),
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Privileges',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppThemes.brc_textcolor,
          ),
        ),
      ),
      body: FutureBuilder<PriviledgeAPI>(
        future: _priviledgeFuture,
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
            if (snapshot.hasData) {
              return ListView.builder(
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
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _showDetailsBottomSheet(
                              context, index, snapshot.data!),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      snapshot.data!.imageUrlArray![index],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Show a grey placeholder if image is not available or link is invalid
                                        return Container(
                                          color: Colors.grey,
                                          width: 80,
                                          height: 80,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.nameArray![index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        snapshot.data!.descriptionArray![index],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "${snapshot.data!.discountArray![index]} OFF",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ],
                    );
                  } else {
                    // Return a placeholder or empty container if data is missing
                    return SizedBox.shrink();
                  }
                },
              );
            } else {
              // Return a placeholder or empty container if no data
              return SizedBox.shrink();
            }
          }
        },
      ),
    );
  }
}
