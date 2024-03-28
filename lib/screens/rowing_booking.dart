import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/table_booking.dart';
import 'package:multi_club_app/screens/widgets/CalendarSection.dart';

class RowingBooking extends StatefulWidget {
  const RowingBooking({Key? key}) : super(key: key);

  @override
  _RowingBookingState createState() => _RowingBookingState();
}

class _RowingBookingState extends State<RowingBooking> {
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
            'Rowing',
            style: TextStyle(
              color: AppThemes.brc_textcolor,
              fontWeight: FontWeight.w700,
              fontSize: 15, // Set text color to white
            ),
          ),
        ),
        actions: [],
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
                      'Rowing',
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
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
                                color:
                                    AppThemes.brc_spotsbooking_confirm_booking),
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
          SeperationBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppThemes
                                      .brc_background, // Example color for not available
                                  borderRadius: BorderRadius.circular(
                                      4), // Adjust the radius value as needed
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.3), // Adjust opacity and color as needed
                                      spreadRadius:
                                          1, // Adjust spread radius as needed
                                      blurRadius:
                                          3, // Adjust blur radius as needed
                                      offset: Offset(
                                          0, 2), // Adjust offset as needed
                                    ),
                                  ],
                                ), // Example color for available
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Available',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppThemes
                                      .brc_inprogress_color, // Example color for not available
                                  borderRadius: BorderRadius.circular(
                                      4), // Adjust the radius value as needed
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.3), // Adjust opacity and color as needed
                                      spreadRadius:
                                          1, // Adjust spread radius as needed
                                      blurRadius:
                                          3, // Adjust blur radius as needed
                                      offset: Offset(
                                          0, 2), // Adjust offset as needed
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'In Progress',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppThemes
                                      .brc_blocked_color, // Example color for not available
                                  borderRadius: BorderRadius.circular(
                                      4), // Adjust the radius value as needed
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.3), // Adjust opacity and color as needed
                                      spreadRadius:
                                          1, // Adjust spread radius as needed
                                      blurRadius:
                                          3, // Adjust blur radius as needed
                                      offset: Offset(
                                          0, 2), // Adjust offset as needed
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Blocked',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppThemes
                                        .brc_not_available_bottom_bg, // Example color for not available
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.3), // Adjust opacity and color as needed
                                        spreadRadius:
                                            1, // Adjust spread radius as needed
                                        blurRadius:
                                            3, // Adjust blur radius as needed
                                        offset: Offset(
                                            0, 2), // Adjust offset as needed
                                      ),
                                    ], // Adjust the radius value as needed
                                  ),
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Unavailable',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppThemes.brc_mybooking_color,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.3), // Adjust opacity and color as needed
                                        spreadRadius:
                                            1, // Adjust spread radius as needed
                                        blurRadius:
                                            3, // Adjust blur radius as needed
                                        offset: Offset(
                                            0, 2), // Adjust offset as needed
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'My Booking',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
