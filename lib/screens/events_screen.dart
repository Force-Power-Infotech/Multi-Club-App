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
  const EventsScreen({Key? key}) : super(key: key);

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
    Key? key,
  }) : super(key: key);

  void _showFeedbackModal(BuildContext context) {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  void _submitFeedback(StateSetter setState) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await FeedbackApi.directory(
        _rating.toString(),
        _feedbackController.text,
      );

      setState(() {
        _isSubmitting = false;
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
        _isSubmitting = false;
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
                        _rating = rating;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _feedbackController,
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
                    _isSubmitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _submitFeedback(setState),
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

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: ColorFiltered(
            colorFilter: isSportsEvent
          ? const ColorFilter.mode(
              Colors.white,
              BlendMode.saturation,
            )
          : const ColorFilter.mode(
              Colors.transparent,
              BlendMode.multiply,
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
          color: AppThemes.getBackground(),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
              ),
              child: Column(
          children: [
            Stack(
              children: [
                Container(
            height: 109,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: NetworkImage(event.eventimage ?? ''),
                fit: BoxFit.cover,
              ),
            ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                top: 16, left: 16, right: 16, bottom: 4),
                  child: Text(
              event.description ?? '',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppThemes.brc_textcolor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 4),
                  child: Text(
              event.eventname ?? '',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppThemes.brc_textcolor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 4),
                  child: Text(
              event.dateForHeading ?? '',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppThemes.brc_textcolor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
                  ),
                ),
              ],
            ),
                ),
                Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 70,
              height: 68,
              decoration: BoxDecoration(
                color: AppThemes.brc_textcolor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
              '${DateTime.parse(event.date ?? '').day}',
              style: TextStyle(
                color: AppThemes.getBackground(),
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
                  ),
                  Text(
              DateFormat('MMM')
                  .format(DateTime.parse(event.date ?? '')),
              style: TextStyle(
                color: AppThemes.getBackground(),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
                  ),
                ],
              ),
            ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 16.0),
              child: ElevatedButton(
                onPressed: isSportsEvent
              ? null
              : () {
                  Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EventDetailsScreen(
                event: event,
              ),
                  ));
                },
                style: ElevatedButton.styleFrom(
            backgroundColor: AppThemes.brc_textcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
                ),
                child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                'VIEW DETAILS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppThemes.brc_selectyourslot_text,
                ),
              ),
            ),
                ),
              ),
            ),
          ],
              ),
            ),
          ),
        ),
        if (isSportsEvent)
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 155, 120, 120),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'EVENT DONE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showFeedbackModal(context);
                      },
                      icon: const Icon(
                        Icons.feedback,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
