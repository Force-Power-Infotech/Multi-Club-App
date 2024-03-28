import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/table_booking.dart';
import 'package:multi_club_app/screens/widgets/CalendarSection.dart';

class SportsBooking extends StatefulWidget {
  const SportsBooking({Key? key}) : super(key: key);

  @override
  _SportsBookingState createState() => _SportsBookingState();
}

class _SportsBookingState extends State<SportsBooking> {
  String dropdownValue = 'Select From Below'; // Initially selected value
  bool isExpanded = false; // Initially options are collapsed
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.brc_background,
        title: Container(
          child: Text(
            'Sports Booking',
            style: TextStyle(
              color: AppThemes.brc_textcolor,
              fontWeight: FontWeight.w700,
              fontSize: 15, // Set text color to white
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CalendarSection(),
          SeperationBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 5,
              surfaceTintColor: AppThemes.brc_textcolor,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select your sport',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            AppThemes.brc_selectyourslot_text.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: AppThemes.brc_background,
                          title: Center(
                              child: Text(
                            dropdownValue,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppThemes.brc_textcolor),
                          )),
                          trailing: Icon(
                              Icons.arrow_drop_down), // Add icon to dropdown
                          onTap: () {
                            setState(() {
                              isExpanded =
                                  !isExpanded; // Toggle expansion state
                            });
                          },
                        ),
                        if (isExpanded)
                          Column(
                            children: [
                              for (String sport in [
                                'Badminton',
                                'Squash',
                                'Snooker/Billiard',
                                'Rowing'
                              ])
                                if (sport !=
                                    dropdownValue) // Exclude selected option
                                  Column(
                                    children: <Widget>[
                                      ListTile(
                                        tileColor: Colors.white,
                                        title: Center(child: Text(sport)),
                                        onTap: () {
                                          setState(() {
                                            dropdownValue = sport;
                                            isExpanded =
                                                false; // Collapse options after selection
                                          });
                                        },
                                      ),
                                      Divider(color: Colors.grey),
                                    ],
                                  ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SeperationBar(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Select Your Slot"
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'Select Your Slot',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppThemes.brc_selectyourslot_text.withOpacity(0.6),
                  ),
                ),
              ),

              // Slots grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child:
                                CardWidget(time: '01:00 PM', available: true)),
                        SizedBox(width: 8),
                        Expanded(
                            child:
                                CardWidget(time: '01:30 PM', available: true)),
                        SizedBox(width: 8),
                        Expanded(
                            child:
                                CardWidget(time: '02:00 PM', available: true)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child:
                                CardWidget(time: '02:30 PM', available: false)),
                        SizedBox(width: 8),
                        Expanded(
                            child:
                                CardWidget(time: '03:00 PM', available: true)),
                        SizedBox(width: 8),
                        Expanded(
                            child:
                                CardWidget(time: '3:30 PM', available: true)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SeperationBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 5,
              surfaceTintColor: AppThemes.brc_textcolor,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add Player Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppThemes.brc_tablebooking_dark_text,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Rakesh Agarwal',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_tablebooking_dark_text),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              '+91 98362589',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_tablebooking_dark_text),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    for (int i = 0; i < 3; i++)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Player Name ${i + 1}',
                                      hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_spotsbooking_hint_text
                                              .withOpacity(
                                                  0.3)), // Reduced font size for hint text

                                      border: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter Mobile Number',
                                      hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppThemes
                                              .brc_spotsbooking_hint_text
                                              .withOpacity(
                                                  0.3)), // Reduced font size for hint text

                                      border: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (i < 2)
                            Divider(
                                thickness:
                                    1), // Add divider for all rows except the last one
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          SeperationBar(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Special Request"
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 0),
                child: Text(
                  'Special Request',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppThemes.brc_tablebooking_dark_text,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 150, // Adjust height as needed
                  child: Card(
                    elevation: 5,
                    surfaceTintColor: AppThemes.brc_textcolor,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: null, // Allow multiple lines of text
                        decoration: InputDecoration(
                          hintText: 'Fill in Here',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppThemes.brc_tablebooking_dark_text
                                  .withOpacity(
                                      0.3)), // Reduced font size for hint text
                          border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SeperationBar(),

              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                child: Card(
                  elevation: 5,
                  surfaceTintColor: AppThemes.brc_textcolor,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'I AM CONFIRMING THIS BOOKING',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppThemes
                                        .brc_spotsbooking_confirm_booking),
                              ),
                            ),
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add onPressed action for confirming booking
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'BOOK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_textcolor,
                                ),
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemes.brc_bottom_icon,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
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
        ],
      ),
    );
  }
}
