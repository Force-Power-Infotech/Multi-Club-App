import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/event_details.dart';
import 'package:multi_club_app/bases/api/event_update.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/widgets/GoogleMap.dart';
import 'package:multi_club_app/screens/widgets/MapWidget.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventDetails event;

  const EventDetailsScreen({required this.event, Key? key}) : super(key: key);

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
        backgroundColor: Webservice.appNickname == 'forcempower'
            ? AppThemes.getBackground()
            : AppThemes.getBackground(),
        title: const Text(
          "Event Details", // Use event name in the title
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ClipRRect(
            // borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(event.eventimage),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppThemes.brc_textcolor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${event.eventname}",
                    style: const TextStyle(
                      color: AppThemes.brc_spotsbooking_hint_text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 0, right: 8, bottom: 8),
                        child: Image.asset(
                          'assets/images/calendar_clock.png',
                          width: 24,
                          height: 24,
                          color: Webservice.appNickname == 'forcempower'
                              ? AppThemes.getBackground()
                              : AppThemes.getBackground(),
                        ),
                      ),
                      Text(
                        "${event.dateForHeading}",
                        style: const TextStyle(
                          color: AppThemes.brc_spotsbooking_hint_text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 0, right: 8, bottom: 8),
                        child: Image.asset(
                          'assets/images/Time Icon 1.png',
                          width: 24,
                          height: 24,
                          color: Webservice.appNickname == 'forcempower'
                              ? AppThemes.getBackground()
                              : AppThemes.getBackground(),
                        ),
                      ),
                      Text(
                        "${event.time}",
                        style: const TextStyle(
                          color: AppThemes.brc_spotsbooking_hint_text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 0, right: 8, bottom: 8),
                        child: Icon(
                          Icons.location_on,
                          color: Webservice.appNickname == 'forcempower'
                              ? AppThemes.getBackground()
                              : AppThemes.getBackground(),
                        ),
                      ),
                      Text(
                        "${event.venue}",
                        style: const TextStyle(
                          color: AppThemes.brc_spotsbooking_hint_text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 0, right: 8, bottom: 8),
                        child: Icon(
                          Icons.location_city,
                          color: Webservice.appNickname == 'forcempower'
                              ? AppThemes.getBackground()
                              : AppThemes.getBackground(),
                        ),
                      ),
                      Text(
                        "${event.city ?? 'Not decided yet'}",
                        style: const TextStyle(
                          color: AppThemes.brc_spotsbooking_hint_text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppThemes.brc_textcolor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ABOUT THE EVENT',
                    style: TextStyle(
                      color: AppThemes.brc_spotsbooking_hint_text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${event.description}",
                    style: const TextStyle(
                      color: AppThemes.brc_spotsbooking_hint_text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (Webservice.appNickname != 'madhuban' &&
                  Webservice.appNickname != 'millmams')
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 4.0, right: 4, bottom: 32),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add onPressed action for confirming booking
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.brc_bottom_icon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/forward_icon.png',
                              width: 24,
                              height: 24,
                              color: AppThemes.brc_textcolor,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Share',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_textcolor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (Webservice.appNickname != 'madhuban' &&
                  Webservice.appNickname != 'millmams')
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 4.0, right: 4, bottom: 32),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add onPressed action for confirming booking
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.brc_bottom_icon,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/forward_icon.png',
                              width: 24,
                              height: 24,
                              color: AppThemes.brc_textcolor,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Locate',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_textcolor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              // if (Webservice.appNickname == 'madhuban' &&
              //     Webservice.appNickname == 'millmams')
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 4.0, right: 4, bottom: 32),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Top Bar
                                  // Rectangular Bar at middle
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 100.0),
                                    child: Container(
                                      height: 8, // Adjust the height as needed
                                      width: 80, // Adjust the width as needed
                                      decoration: BoxDecoration(
                                        color: AppThemes.getBackground(),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Event Name
                                  Row(
                                    children: [
                                      Text(
                                        '${event.eventname}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Demo Google Map
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: MapWidget(
                                      googleMapsLink:
                                          event.locationOnMap.toString(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Text "Going to attend the event"
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Going to attend the event ?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Options Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppThemes.getBackground()),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(100, 40)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ),
                                        onPressed: () async {
                                          // Call the API with 'YES' status
                                          EventUpdateAPI apiResponse =
                                              await EventUpdateAPI.updation(
                                                  "${event.eventid}", 'YES');
                                          // Show a snackbar based on the API response
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${apiResponse.processMessage} on ${apiResponse.eventname}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: AppThemes
                                                        .brc_textcolor),
                                              ),
                                              backgroundColor:
                                                  AppThemes.brc_otp_success,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'YES',
                                          style: TextStyle(
                                              color: AppThemes.brc_textcolor),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppThemes.getBackground()),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(100, 40)),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ),
                                        onPressed: () async {
                                          // Call the API with 'YES' status
                                          EventUpdateAPI apiResponse =
                                              await EventUpdateAPI.updation(
                                                  "${event.eventid}", 'NO');
                                          // Show a snackbar based on the API response
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${apiResponse.processMessage} on ${apiResponse.eventname}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: AppThemes
                                                        .brc_textcolor),
                                              ),
                                              backgroundColor:
                                                  AppThemes.brc_otp_success,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'NO',
                                          style: TextStyle(
                                              color: AppThemes.brc_textcolor),
                                        ),
                                      ),
                                      if (Webservice.appNickname ==
                                              'madhuban' &&
                                          Webservice.appNickname != 'millmams')
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppThemes.getBackground()),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    const Size(100, 40)),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.zero),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                          ),
                                          onPressed: () async {
                                            // Call the API with 'YES' status
                                            EventUpdateAPI apiResponse =
                                                await EventUpdateAPI.updation(
                                                    "${event.eventid}",
                                                    'NOT SURE');
                                            // Show a snackbar based on the API response
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${apiResponse.processMessage} on ${apiResponse.eventname}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: AppThemes
                                                          .brc_textcolor),
                                                ),
                                                backgroundColor:
                                                    AppThemes.brc_otp_success,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'NOT SURE',
                                            style: TextStyle(
                                                color: AppThemes.brc_textcolor),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.brc_bottom_icon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppThemes.brc_textcolor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildImageWidget(String? imageUrl) {
  try {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl, // URL from the API

        errorBuilder: (context, error, stackTrace) {
          // If there's an error loading the image, return the placeholder
          return _buildPlaceholderImage();
        },
      );
    }
  } catch (e) {
    // Handle any exception that might occur during image loading
    print('Error loading image: $e');
  }
  // Return the placeholder if no valid image URL is provided
  return _buildPlaceholderImage();
}

Widget _buildPlaceholderImage() {
  return Container(
    height: 300,
    color: AppThemes.madhuwan_home_birthday_card, // Grey color for the block
    child: const Center(
      child: Text('No Image'),
    ),
  );
}
