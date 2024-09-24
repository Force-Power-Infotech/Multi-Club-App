import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/gallery.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Add this import for date formatting and parsing

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Future<GalleryAPI>? _galleryFuture;

  @override
  void initState() {
    super.initState();
    _galleryFuture = fetchGalleryData();
  }

  Future<GalleryAPI> fetchGalleryData() async {
    return GalleryData.updation(DateTime.now().toString());
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
          'Gallery',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<GalleryAPI>(
        future: _galleryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.galleryData == null) {
            return const Center(child: Text('No data available'));
          } else {
            List<GalleryData> galleryData = snapshot.data!.galleryData!;
            final appNickname = Webservice.appNickname;

            if (appNickname == 'mm') {
              galleryData.sort(
                  (a, b) => parseDate(b.date!).compareTo(parseDate(a.date!)));
            } else if (appNickname == 'madhuban') {
              galleryData
                  .sort((a, b) => a.event_name!.compareTo(b.event_name!));
            }

            return ListView(
              children: [
                if (appNickname == 'ma') ...[
                  SectionWidget(
                      sectionTitle: 'Today\'s Session',
                      galleryData: galleryData
                          .where((data) => isToday(parseDate(data.date!)))
                          .toList()),
                  SectionWidget(
                      sectionTitle: 'Last Week',
                      galleryData: galleryData
                          .where((data) => isLastWeek(parseDate(data.date!)))
                          .toList()),
                  SectionWidget(
                      sectionTitle: 'Last Month',
                      galleryData: galleryData
                          .where((data) => isLastMonth(parseDate(data.date!)))
                          .toList()),
                ] else if (appNickname == 'millmams' ||
                    appNickname == 'madhuban') ...[
                  for (var eventGroup in groupByevent_name(galleryData).entries)
                    SectionWidget(
                      sectionTitle: eventGroup.key,
                      galleryData: eventGroup.value,
                    ),
                ]
              ],
            );
          }
        },
      ),
    );
  }

  DateTime parseDate(String date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.parse(date);
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isLastWeek(DateTime date) {
    DateTime now = DateTime.now();
    DateTime startOfCurrentWeek =
        now.subtract(Duration(days: now.weekday - 1)); // Monday of this week
    DateTime startOfLastWeek = startOfCurrentWeek
        .subtract(const Duration(days: 7)); // Monday of last week
    DateTime endOfLastWeek = startOfCurrentWeek
        .subtract(const Duration(days: 1)); // Sunday of last week

    return date.isAfter(startOfLastWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfLastWeek.add(const Duration(days: 1)));
  }

  bool isLastMonth(DateTime date) {
    DateTime now = DateTime.now();
    DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime startOfLastMonth =
        DateTime(startOfCurrentMonth.year, startOfCurrentMonth.month - 1, 1);
    DateTime endOfLastMonth =
        DateTime(startOfCurrentMonth.year, startOfCurrentMonth.month, 1)
            .subtract(const Duration(days: 1));

    return date.isAfter(startOfLastMonth.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfLastMonth.add(const Duration(days: 1)));
  }

  Map<String, List<GalleryData>> groupByevent_name(
      List<GalleryData> galleryData) {
    Map<String, List<GalleryData>> groupedData = {};
    for (var data in galleryData) {
      if (!groupedData.containsKey(data.event_name)) {
        groupedData[data.event_name!] = [];
      }
      groupedData[data.event_name]!.add(data);
    }
    return groupedData;
  }
}

class SectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<GalleryData> galleryData;

  const SectionWidget({
    Key? key,
    required this.sectionTitle,
    required this.galleryData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              sectionTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: galleryData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context); // Close the dialog when tapped
                          },
                          child: Center(
                            child: InteractiveViewer(
                              boundaryMargin:
                                  EdgeInsets.all(20), // Optional: Adjust margin
                              minScale: 0.1, // Optional: Minimum scale
                              maxScale: 4.0, // Optional: Maximum scale
                              constrained: false, // Allow over-zooming
                              child: Image.network(
                                galleryData[index].imageUrl!,
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context)
                                    .size
                                    .height, // Use the full screen height
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // Use the full screen width
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    galleryData[index].imageUrl!,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
