import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_club_app/bases/api/event_details.dart';
import 'package:multi_club_app/bases/api/feedback.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/event_details_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

String selectedOption = 'present'; // Default selected option

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<EventAPI> _eventDetailsFuture = EventAPI.details();

  @override
  void initState() {
    super.initState();
    // Fetch event details when the screen initializes
    _eventDetailsFuture = EventAPI.details();
  }

  Future<void> _refreshEvents() async {
    // Fetch event details again
    setState(() {
      _eventDetailsFuture = EventAPI.details();
    });
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
          'Events',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: FutureBuilder<EventAPI>(
          future: _eventDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(), // Show loading indicator while fetching data
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error: ${snapshot.error}'), // Show error message if fetching data fails
              );
            } else {
              // Once data is fetched successfully, display the events
              return ListView(
                children: [
                  if (Webservice.appNickname != 'madhuban' &&
                      Webservice.appNickname != 'milleNniumMams')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 145,
                            height: 31,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOption = 'past';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedOption == 'past'
                                    ? AppThemes.getBackground()
                                    : AppThemes.brc_textcolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fixedSize: const Size(
                                    120, 40), // Set fixed width and height
                                elevation: 5, // Add elevation for shadow effect
                              ),
                              child: Text(
                                'PAST',
                                style: TextStyle(
                                  color: selectedOption == 'past'
                                      ? Colors.white
                                      : AppThemes.brc_spotsbooking_hint_text,
                                  fontSize: 14,
                                  fontWeight: selectedOption == 'past'
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          SizedBox(
                            height: 31,
                            width: 145,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOption = 'present';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedOption == 'present'
                                    ? AppThemes.getBackground()
                                    : AppThemes.brc_textcolor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fixedSize: const Size(120, 40),
                                elevation: 5, // Add elevation for shadow effect
                              ),
                              child: Text(
                                'ONGOING',
                                style: TextStyle(
                                  color: selectedOption == 'present'
                                      ? Colors.white
                                      : AppThemes.brc_spotsbooking_hint_text,
                                  fontSize: 14,
                                  fontWeight: selectedOption == 'present'
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                        ],
                      ),
                    ),
                  Column(
                    children: [
                      if (snapshot.data != null &&
                          snapshot.data!.eventDetails != null) ...[
                        if (Webservice.appNickname == 'madhuban')
                          Column(
                            children: snapshot.data!.eventDetails!
                                .map((event) => EventCards(event: event))
                                .toList(),
                          ),
                        if (Webservice.appNickname != 'madhuwan')
                          if (selectedOption == 'past')
                            Column(
                              children: snapshot.data!.eventDetails!
                                  .where((event) => event.status == 'past')
                                  .map((event) => EventCards(event: event))
                                  .toList(),
                            ),
                        if (Webservice.appNickname != 'madhuwan')
                          if (selectedOption == 'present')
                            Column(
                              children: snapshot.data!.eventDetails!
                                  .where((event) => event.status == 'present')
                                  .map((event) => EventCards(event: event))
                                  .toList(),
                            ),
                      ],
                      if (snapshot.data == null ||
                          snapshot.data!.eventDetails == null ||
                          snapshot.data!.eventDetails!.isEmpty)
                        const Text('No event details available'),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class EventCards extends StatelessWidget {
  final EventDetails event;

  const EventCards({
    required this.event,
    super.key,
  });

  void _showFeedbackModal(BuildContext context) {
  double rating = 0;
  final TextEditingController feedbackController = TextEditingController();
  bool isSubmitting = false;

  void submitFeedback(StateSetter setState) async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await FeedbackApi.directory(
        rating.toString(),
        feedbackController.text,
      );

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          response.processMessage ?? 'Feedback submitted successfully',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor:
            response.processStatus == 'YES' ? Colors.green : Colors.red,
      ));

      if (response.processStatus == 'YES') {
        Navigator.of(context).pop(); // Close the modal after successful submission
      }
    } catch (error) {
      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to submit feedback. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (_, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Rate the Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.blueAccent.shade200,
                      ),
                      onRatingUpdate: (rating) {
                        rating = rating;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: feedbackController,
                      decoration: InputDecoration(
                        labelText: 'Comments',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent.shade200),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    isSubmitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => submitFeedback(setState),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.shade200,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 28),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Submit Feedback',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    bool isSportsEvent = selectedOption == 'past';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    event.eventimage ?? '',
                    fit: BoxFit.cover,
                    color: isSportsEvent ? Colors.grey : null,
                    colorBlendMode: isSportsEvent ? BlendMode.saturation : null,
                  ),
                ),
                if (isSportsEvent)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'EVENT COMPLETED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.feedback_rounded, color: Colors.white),
                              onPressed: () => _showFeedbackModal(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppThemes.getBackground().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${DateTime.parse(event.date ?? '').day}',
                        style: TextStyle(
                          color: AppThemes.getBackground(),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(DateTime.parse(event.date ?? '')),
                        style: TextStyle(
                          color: AppThemes.getBackground(),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Event Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.eventname ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.description ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Button
          if (!isSportsEvent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.getBackground(),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
