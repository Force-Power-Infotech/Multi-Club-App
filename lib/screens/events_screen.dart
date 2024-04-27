import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_club_app/bases/api/event_details.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String selectedOption = 'Club'; // Default selected option
  late Future<EventAPI> _eventDetailsFuture = EventAPI.details();

  @override
  void initState() {
    super.initState();
    // Fetch event details when the screen initializes
    _eventDetailsFuture = EventAPI.details();
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
            : AppThemes.madhuwan_background,
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
      body: FutureBuilder<EventAPI>(
        future: _eventDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                if (Webservice.appNickname != 'madhuban')
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
                                selectedOption = 'Club';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedOption == 'Club'
                                  ? AppThemes.getBackground()
                                  : AppThemes.brc_textcolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              fixedSize:
                                  Size(120, 40), // Set fixed width and height
                              elevation: 5, // Add elevation for shadow effect
                            ),
                            child: Text(
                              'Club',
                              style: TextStyle(
                                color: selectedOption == 'Club'
                                    ? Colors.white
                                    : AppThemes.brc_spotsbooking_hint_text,
                                fontSize: 14,
                                fontWeight: selectedOption == 'Club'
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        SizedBox(
                          height: 31,
                          width: 145,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedOption = 'Sports';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedOption == 'Sports'
                                  ? AppThemes.getBackground()
                                  : AppThemes.brc_textcolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              fixedSize: Size(120, 40),
                              elevation: 5, // Add elevation for shadow effect
                            ),
                            child: Text(
                              'Sports',
                              style: TextStyle(
                                color: selectedOption == 'Sports'
                                    ? Colors.white
                                    : AppThemes.brc_spotsbooking_hint_text,
                                fontSize: 14,
                                fontWeight: selectedOption == 'Sports'
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        Material(
                          elevation: 5, // Set elevation for shadow effect
                          borderRadius:
                              BorderRadius.circular(4), // Set round edges
                          child: Container(
                            width: 31,
                            height: 31,
                            decoration: BoxDecoration(
                              color: AppThemes
                                  .getBackground(), // Set background color
                              borderRadius:
                                  BorderRadius.circular(4), // Set round edges
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: AppThemes.brc_textcolor,
                              onPressed: () {
                                // Add onPressed action for square button
                              },
                              icon: Icon(
                                Icons.filter_alt,
                                size: 28,
                                fill: 0.5,
                              ),
                            ),
                          ),
                        ),
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
                              .map((event) => eventCards(event: event))
                              .toList(),
                        ),
                      if (selectedOption == 'Club')
                        Column(
                          children: snapshot.data!.eventDetails!
                              .map((event) => eventCards(event: event))
                              .toList(),
                        ),
                      if (selectedOption != 'Club' &&
                          snapshot.data!.eventDetails!.isNotEmpty)
                        eventCards(event: snapshot.data!.eventDetails!.first),
                    ],
                    if (snapshot.data == null ||
                        snapshot.data!.eventDetails == null ||
                        snapshot.data!.eventDetails!.isEmpty)
                      Text('No event details available'),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class eventCards extends StatelessWidget {
  final EventDetails event;

  const eventCards({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemes.getBackground(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(event.eventimage ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8, // Adjust top position as needed
                right: 8, // Adjust right position as needed
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppThemes.brc_textcolor,
                    borderRadius: BorderRadius.circular(10), // Make it round
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Add onPressed action for export icon
                    },
                    icon: Icon(Icons.ios_share),
                    color: AppThemes.getBackground(),
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
                        style: TextStyle(
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
                        style: TextStyle(
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
                        event.date ?? '',
                        style: TextStyle(
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
                    borderRadius: BorderRadius.circular(
                        15), // Adjust border radius as needed
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${DateTime.parse(event.date ?? '').day}', // Extract and display the day number
                        style: TextStyle(
                          color: AppThemes.getBackground(),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${DateFormat('MMM').format(DateTime.parse(event.date ?? ''))}', // Extract and display the month abbreviation
                        style: TextStyle(
                          color: AppThemes.getBackground(),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
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
    );
  }
}
