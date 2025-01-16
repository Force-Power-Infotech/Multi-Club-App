import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_club_app/bases/api/event_details.dart';
import 'package:multi_club_app/bases/api/event_update.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/widgets/GoogleMap.dart';
import 'package:multi_club_app/screens/widgets/MapWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventDetails event;
  const EventDetailsScreen({required this.event, super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventDetails _event;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  Future<void> _refreshEventDetails() async {
    try {
      final eventAPI = await EventAPI.details();
      if (eventAPI.eventDetails != null) {
        final updatedEvent = eventAPI.eventDetails!.firstWhere(
          (e) => e.eventid == _event.eventid,
          orElse: () => _event,
        );
        setState(() {
          _event = updatedEvent;
        });
      }
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
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
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshEventDetails,
        child: ListView(
          children: [
            ClipRRect(
              // borderRadius: BorderRadius.circular(8),
              child: _buildImageWidget(_event.eventimage),
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
                      "${_event.eventname}",
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
                          "${_event.dateForHeading}",
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
                          "${_event.time}",
                          style: const TextStyle(
                            color: AppThemes.brc_spotsbooking_hint_text,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (_event.attendingStatus == 'YES')
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
                            "${_event.venue}",
                            style: const TextStyle(
                              color: AppThemes.brc_spotsbooking_hint_text,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    if (_event.attendingStatus == 'YES')
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
                          Expanded(
                            child: Text(
                              _event.city ?? '',
                              style: const TextStyle(
                                color: AppThemes.brc_spotsbooking_hint_text,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              // Copy the city text to clipboard
                              if (_event.city != null && _event.city!.isNotEmpty) {
                                Clipboard.setData(
                                    ClipboardData(text: _event.city!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Copied to clipboard')),
                                );
                              }
                            },
                            color: AppThemes.brc_spotsbooking_hint_text,
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
                      "${_event.description}",
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
                if (_event.status == 'present' && _event.registered !='true')
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Top Bar
                                      // Rectangular Bar at middle
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 100.0),
                                        child: Container(
                                          height:
                                              8, // Adjust the height as needed
                                          width: 80, // Adjust the width as needed
                                          decoration: BoxDecoration(
                                            color: AppThemes.getBackground(),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Event Name
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       '${event.eventname}',
                                      //       style: const TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      const SizedBox(height: 16),

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
                                                  WidgetStateProperty.all(
                                                      AppThemes.getBackground()),
                                              minimumSize:
                                                  WidgetStateProperty.all(
                                                      const Size(100, 40)),
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.zero),
                                              textStyle: WidgetStateProperty.all(
                                                  const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                            onPressed: () async {
                                              // Call the API with 'YES' status
                                              EventUpdateAPI apiResponse =
                                                  await EventUpdateAPI.updation(
                                                      "${_event.eventid}", 'YES');
                                              // Refresh event details after registration
                                              await _refreshEventDetails();
                                              // call event detail api
                                              // Show a snackbar based on the API response
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${apiResponse.processMessage}',
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
                                                  WidgetStateProperty.all(
                                                      AppThemes.getBackground()),
                                              minimumSize:
                                                  WidgetStateProperty.all(
                                                      const Size(100, 40)),
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.zero),
                                              textStyle: WidgetStateProperty.all(
                                                  const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ),
                                            onPressed: () async {
                                              // Call the API with 'YES' status
                                              EventUpdateAPI apiResponse =
                                                  await EventUpdateAPI.updation(
                                                      "${_event.eventid}", 'NO');
                                              // Refresh event details after registration
                                              await _refreshEventDetails();
                                              // Show a snackbar based on the API response
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${apiResponse.processMessage}',
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
                                              Webservice.appNickname !=
                                                  'millmams')
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        AppThemes
                                                            .getBackground()),
                                                minimumSize:
                                                    WidgetStateProperty.all(
                                                        const Size(100, 40)),
                                                padding: WidgetStateProperty.all(
                                                    EdgeInsets.zero),
                                                textStyle:
                                                    WidgetStateProperty.all(
                                                        const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                              ),
                                              onPressed: () async {
                                                // Call the API with 'YES' status
                                                EventUpdateAPI apiResponse =
                                                    await EventUpdateAPI.updation(
                                                        "${_event.eventid}",
                                                        'NOT SURE');
                                                // Refresh event details after registration
                                                await _refreshEventDetails();
                                                // Show a snackbar based on the API response
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${apiResponse.processMessage}',
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
                                                    color:
                                                        AppThemes.brc_textcolor),
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
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
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
