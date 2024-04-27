import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/sports_booking.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/table_booking.dart';
import 'package:multi_club_app/screens/widgets/CalendarSection.dart';

class SportsBooking extends StatefulWidget {
  const SportsBooking({Key? key}) : super(key: key);

  @override
  _SportsBookingState createState() => _SportsBookingState();
}

class _SportsBookingState extends State<SportsBooking> {
  String? selectedSport; // Variable to track the selected sport
  bool isLoading = false;

  String dropdownValue = 'Select From Below'; // Initially selected value
  bool isExpanded = false; // Initially options are collapsed
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.brc_background,
        title: Container(
          child: const Text(
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
          const SeperationBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(
              children: [
                // Container with "Select your sport" text
                Container(
                  width: double.infinity,
                  height: 102,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Set round edges
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                    color: AppThemes.brc_textcolor, // Background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
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
                ),

                // Dropdown options

                Padding(
                  padding: const EdgeInsets.only(top: 35.0, left: 8, right: 8),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppThemes.brc_background,

                            borderRadius: BorderRadius.circular(
                                2), // Adjust the value to change the roundness
                          ),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                dropdownValue,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppThemes.brc_textcolor,
                                ),
                              ),
                            ),
                            trailing: Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: AppThemes.brc_textcolor,
                            ), // Change icon based on expansion state
                            onTap: () {
                              setState(() {
                                isExpanded =
                                    !isExpanded; // Toggle expansion state
                              });
                            },
                          ),
                        ),
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
                              if (sport != dropdownValue)
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppThemes
                                          .dropdown_border, // Border color
                                      width: 1, // Border width
                                      // Optionally, you can specify the border style
                                      // style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: AppThemes.brc_textcolor,
                                        child: ListTile(
                                          title: Center(child: Text(sport)),
                                          onTap: () {
                                            setState(() {
                                              dropdownValue = sport;
                                              isExpanded =
                                                  false; // Collapse options after selection
                                            });
                                          },
                                        ),
                                      ),
                                      // Divider(
                                      //   height: 0,
                                      //   thickness: 1,
                                      //   color: Colors.grey,
                                      // ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SeperationBar(),
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
              const Padding(
                padding: EdgeInsets.all(16),
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
          const SeperationBar(),
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
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Add Player Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppThemes.brc_tablebooking_dark_text,
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
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
                            padding: EdgeInsets.only(right: 16.0),
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
                    const Divider(thickness: 1),
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
                            const Divider(
                                thickness:
                                    1), // Add divider for all rows except the last one
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SeperationBar(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Special Request"
              const Padding(
                padding: EdgeInsets.only(left: 30, top: 0),
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
              const SeperationBar(),

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
                            const Expanded(
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
                      // Confirm booking button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 32),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Call the booking method to make a booking
                            try {
                              String? bookingDate = "2024-04-25";
                              //     .toString(); // Replace 'Booking' with the actual booking date variable
                              if (bookingDate != null &&
                                  bookingDate.isNotEmpty) {
                                setState(() {
                                  isLoading =
                                      true; // Set isLoading to true when button is pressed
                                });
                                // Make the booking request
                                SportsBookingAPI booking =
                                    await SportsBookingAPI.booking();

                                setState(() {
                                  isLoading =
                                      false; // Set isLoading to false after data is fetched
                                });
                                // Check the booking response
                                if (booking.processStatus == 'YES') {
                                  // Booking successful
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${booking.processMessage}  on ${booking.bkDateFormat}',
                                        style: const TextStyle(
                                          color: AppThemes.brc_textcolor,
                                        ),
                                      ),
                                      backgroundColor:
                                          AppThemes.brc_otp_success,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  print(
                                      'Booking successful. Booking ID: ${booking.bookingId}');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${booking.processMessage}',
                                        style: const TextStyle(
                                          color: AppThemes.brc_textcolor,
                                        ),
                                      ),
                                      backgroundColor: AppThemes.brc_otp_error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  // Booking failed
                                  print(
                                      'Booking failed: ${booking.processMessage}');
                                }
                              } else {
                                print('No booking date selected.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'No booking date selected.',
                                      style: const TextStyle(
                                        color: AppThemes.brc_textcolor,
                                      ),
                                    ),
                                    backgroundColor: AppThemes.brc_otp_error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (error) {
                              // Error occurred during booking
                              print('Error during booking: $error');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemes
                                .brc_bottom_icon, // Background color of the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      // Show CircularProgressIndicator when isLoading is true
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppThemes
                                            .brc_textcolor, // Set the color of the spinner
                                      ),
                                    )
                                  : Text(
                                      // Show button text when isLoading is false
                                      'Confirm Booking',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppThemes.brc_textcolor,
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
            ],
          ),
        ],
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppThemes.brc_tablebooking_dark_text,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: available
                  ? AppThemes.brc_background
                  : AppThemes.brc_not_available_bottom_bg,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Center(
              child: Text(
                available ? 'AVAILABLE' : 'BOOKED',
                style: const TextStyle(
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
