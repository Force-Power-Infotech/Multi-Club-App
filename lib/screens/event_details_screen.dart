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

  Widget _buildInfoRow(IconData icon, String text, {bool showCopy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppThemes.getBackground().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppThemes.getBackground(), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
          if (showCopy)
            IconButton(
              icon: Icon(Icons.copy_rounded, color: AppThemes.getBackground()),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Navigator.pop(context),
            color: Colors.black87,
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshEventDetails,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image with Gradient Overlay
              Stack(
                children: [
                  _buildImageWidget(_event.eventimage),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Content Section
              Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _event.eventname ?? '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow(Icons.calendar_today_rounded, _event.dateForHeading ?? ''),
                            _buildInfoRow(Icons.access_time_rounded, _event.time ?? ''),
                            if (_event.attendingStatus == 'YES') ...[
                              _buildInfoRow(Icons.location_on_rounded, _event.venue ?? ''),
                              _buildInfoRow(Icons.location_city_rounded, _event.city ?? '', showCopy: true),
                            ],
                          ],
                        ),
                      ),

                      // Description Section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _event.description ?? '',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Registration Button
                      if (_event.status == 'present' && _event.registered != 'true')
                        Container(
                          margin: const EdgeInsets.all(20),
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
                                                    try {
                                                      // Call the API with 'YES' status
                                                      EventUpdateAPI apiResponse =
                                                          await EventUpdateAPI.updation(
                                                              "${_event.eventid}", 'YES');
                                                      
                                                      // Refresh event details first
                                                      await _refreshEventDetails();
                                                      
                                                      if (mounted) {  // Check if widget is still mounted
                                                          // Close the bottom sheet
                                                          Navigator.pop(context);
                                                          
                                                          // Show snackbar only if widget is still mounted
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      '${apiResponse.processMessage}',
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                          color: AppThemes.brc_textcolor),
                                                                  ),
                                                                  backgroundColor: AppThemes.brc_otp_success,
                                                                  behavior: SnackBarBehavior.floating,
                                                              ),
                                                          );
                                                      }
                                                  } catch (e) {
                                                      if (mounted) {  // Check if widget is still mounted
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                  content: Text('Failed to update status'),
                                                              ),
                                                          );
                                                      }
                                                  }
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
                                                    try {
                                                      // Call the API with 'NO' status
                                                      EventUpdateAPI apiResponse =
                                                          await EventUpdateAPI.updation(
                                                              "${_event.eventid}", 'NO');
                                                      
                                                      // Refresh event details first
                                                      await _refreshEventDetails();
                                                      
                                                      if (mounted) {  // Check if widget is still mounted
                                                          // Close the bottom sheet
                                                          Navigator.pop(context);
                                                          
                                                          // Show snackbar only if widget is still mounted
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      '${apiResponse.processMessage}',
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                          color: AppThemes.brc_textcolor),
                                                                  ),
                                                                  backgroundColor: AppThemes.brc_otp_success,
                                                                  behavior: SnackBarBehavior.floating,
                                                              ),
                                                          );
                                                      }
                                                  } catch (e) {
                                                      if (mounted) {  // Check if widget is still mounted
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                  content: Text('Failed to update status'),
                                                              ),
                                                          );
                                                      }
                                                  }
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
                                                      try {
                                                        // Call the API with 'YES' status
                                                        EventUpdateAPI apiResponse =
                                                            await EventUpdateAPI.updation(
                                                                "${_event.eventid}",
                                                                'NOT SURE');
                                                        // Refresh event details first
                                                        await _refreshEventDetails();
                                                            
                                                        if (mounted) {  // Check if widget is still mounted
                                                            // Close the bottom sheet
                                                            Navigator.pop(context);
                                                            
                                                            // Show snackbar only if widget is still mounted
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                    content: Text(
                                                                        '${apiResponse.processMessage}',
                                                                        textAlign: TextAlign.center,
                                                                        style: const TextStyle(
                                                                            color: AppThemes.brc_textcolor),
                                                                    ),
                                                                    backgroundColor: AppThemes.brc_otp_success,
                                                                    behavior: SnackBarBehavior.floating,
                                                                ),
                                                            );
                                                        }
                                                    } catch (e) {
                                                        if (mounted) {  // Check if widget is still mounted
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(
                                                                    content: Text('Failed to update status'),
                                                                ),
                                                            );
                                                        }
                                                    }
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
                              backgroundColor: AppThemes.getBackground(),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
