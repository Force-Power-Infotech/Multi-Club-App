import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/widgets/CalendarSection.dart';

class TableBooking extends StatefulWidget {
  const TableBooking({Key? key}) : super(key: key);

  @override
  _TableBookingState createState() => _TableBookingState();
}

class _TableBookingState extends State<TableBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.brc_background,
        title: Container(
          child: Text(
            'New Booking',
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
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CalendarSection(),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Select your space',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight
                            .w500), // Adjust font size of the hintText
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 6.0), // Adjust vertical padding
                  ),
                ),
              ),
              SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 5,
                  surfaceTintColor: AppThemes.brc_textcolor,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 500,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppThemes
                                .brc_background, // Background color for the text
                            borderRadius: BorderRadius.circular(
                                1.0), // Adjust the radius as needed
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Waterview',
                              style: TextStyle(
                                color: AppThemes.brc_textcolor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Alfresco   ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SeperationBar(),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                      'Select your slot',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add onPressed action for the first button
                            },
                            child: Text(
                              'LUNCH',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_tablebooking_dark_text),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemes
                                  .brc_separation_bar, // Background color of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust border radius
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Add space between buttons
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add onPressed action for the second button
                            },
                            child: Text(
                              'DINNER',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.brc_textcolor),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppThemes
                                  .brc_background, // Background color of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust border radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CardWidget(
                    time: '01:00 PM',
                    available: true,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardWidget(
                    time: '01:30 PM',
                    available: true,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardWidget(
                    time: '02:00 PM',
                    available: true,
                  ),
                ),
              ],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Special Request"
              Padding(
                padding: const EdgeInsets.only(left: 140, top: 16),
                child: Text(
                  'Special Request',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppThemes.brc_bottom_icon,
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
                          border: InputBorder.none, // Remove border
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Confirm booking button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: ElevatedButton(
                  onPressed: () {
                    // Add onPressed action for confirming booking
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'Confirm Booking',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppThemes.brc_textcolor),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes
                        .brc_bottom_icon, // Background color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
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

class SeperationBar extends StatelessWidget {
  const SeperationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        width: double.infinity, // Expand the width to fill the entire screen
        height: 10, // Set the height of the divider
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              5), // Adjust border radius for rounded edges
          color: AppThemes.brc_separation_bar, // Set the color of the divider
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String time;
  final bool available;

  const CardWidget({
    Key? key,
    required this.time,
    required this.available,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: available
            ? AppThemes.brc_textcolor
            : AppThemes.brc_not_available_bg,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 8), // Adjust padding as needed
            child: Text(
              time,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppThemes.brc_tablebooking_dark_text,
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: available
                  ? AppThemes.brc_background
                  : AppThemes.brc_not_available_bottom_bg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Center(
              child: Text(
                available ? 'AVAILABLE' : 'BOOKED',
                style: TextStyle(
                  fontSize: 8,
                  color: AppThemes.brc_textcolor,
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
