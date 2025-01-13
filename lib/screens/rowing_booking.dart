import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/location_for_rowing_booking.dart';
import 'package:multi_club_app/bases/api/rowing_booking.dart';
import 'package:multi_club_app/bases/api/time_slot_rowing_booking.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/widgets/CalendarSection.dart';
import 'package:multi_club_app/screens/widgets/SeparationBar.dart';

class RowingBooking extends StatefulWidget {
  const RowingBooking({super.key});

  @override
  _RowingBookingState createState() => _RowingBookingState();
}

class _RowingBookingState extends State<RowingBooking> {
  bool isLoading = false;
  String? Booking;
  List<LocationData> locations =
      []; // List to hold sports categories as LocationData
  String selectedLocation = ''; // Change the type to String
  String selectedLocationKey = ''; // Declare selected location key variable
  List<LocationData>? locationData; // Define a variable to store location data
  String selectedTime = '';

  String dropdownValue = 'Select From Below'; // Initially selected value
  bool isExpanded = false; // Initially options are collapsed
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    fetchLocationData(); // Fetch sports categories when the widget initializes
  }

  void handleCardTap(String selectedTime) {
    setState(() {
      // Update selectedTime with the time of the tapped card
      this.selectedTime = selectedTime;
      // Print or use selectedTime for further processing
      print('Selected time: $selectedTime');
    });
  }

  Future<Widget> buildTimeSlots() async {
    try {
      String bookingDate =
          Booking ?? ''; // Providing a default value if Booking is null
      String formattedDate = bookingDate.split(' ')[0];
      print(formattedDate);

      TimeSlotRowingBookingAPI? timeSlotData =
          await TimeSlotRowingBookingAPI.slots(formattedDate);

      List<Widget> rows = [];
      List<TimingListArr>? timingList = timeSlotData.timingListArr;

      if (timingList != null && timingList.isNotEmpty) {
        for (int i = 0; i < timingList.length; i += 3) {
          List<Widget> timeSlots = [];
          for (int j = i; j < i + 3 && j < timingList.length; j++) {
            TimingListArr slot = timingList[j];
            // final color = '0xFF${slot.hexCode?.replaceAll('#', '')}';
            final hexCode = slot.hexCode?.replaceAll('#', '') ??
                '000000'; // Replace '#' if exists
            final color = int.tryParse('0xFF$hexCode') ??
                0xFF000000; // Parse as hexadecimal

            timeSlots.add(
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardWidget(
                    time: slot.timeSlot ?? '',
                    available: slot.status == 'AVAILABLE',
                    isSelected: selectedTime == (slot.timeSlot ?? ''),
                    boxcolor: Color(color),
                    onTap: () {
                      handleCardTap(slot.timeSlot ?? '');
                    },
                  ),
                ),
              ),
            );
            print('this show what color is coming${color}');
          }
          rows.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.from(timeSlots),
              ),
            ),
          );
        }
      }

      return Column(
        children: rows,
      );
        } catch (error) {
      // Handle error while fetching time slots
      print('Error fetching time slots: $error');
      return const Center(
        child: Text('Error fetching time slots.'),
      );
    }
  }

// Method to fetch and set location data
  Future<void> fetchLocationData() async {
    try {
      // Set loading state to true
      setState(() {
        isLoading = true;
      });

      // Call the method to fetch location data
      List<LocationData> fetchedData =
          await LocationRowingBookingAPI.getLocationData();

      // Extract locVal and locKey from LocationData objects
      List<String> locValList =
          fetchedData.map((location) => location.locVal ?? '').toList();
      List<String> locKeyList =
          fetchedData.map((location) => location.locKey ?? '').toList();

      // Create List<LocationData> with locVal and locKey
      List<LocationData> locationsData = [];
      for (int i = 0; i < locValList.length; i++) {
        locationsData
            .add(LocationData(locVal: locValList[i], locKey: locKeyList[i]));
      }

      // Set the location data and loading state
      setState(() {
        locations = locationsData;
        isLoading = false;
        print('Location data fetched successfully: $locations');
      });
    } catch (error) {
      print('Error fetching location data: $error');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.brc_background,
        title: const Text(
          'Rowing',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15, // Set text color to white
          ),
        ),
        // actions: [],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CalendarSection(
            onDateSelected: (DateTime selectedDate) {
              // Do something with the selected date
              Booking = selectedDate.toString();
              print('Selected Date: $Booking');
            },
          ),
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
                        offset: const Offset(0, 3), // Shadow offset
                      ),
                    ],
                    color: AppThemes.brc_textcolor, // Background color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
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
                ),

                // UI code to display the dropdown list
                Padding(
                  padding: const EdgeInsets.only(top: 35.0, left: 8, right: 8),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppThemes.brc_background,
                            borderRadius: BorderRadius.circular(
                              2, // Adjust the value to change the roundness
                            ),
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
                            // Show spinner if location data is loading
                            if (isLoading)
                              const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            // Show list once location data is loaded
                            if (!isLoading)
                              for (LocationData location in locations)
                                if (location.locVal != dropdownValue &&
                                    location.locVal != 'Rowing')
                                  GestureDetector(
                                    onTap: () {
                                      print(
                                          'Tapped on ${location.locVal ?? 'Unknown'}');
                                      setState(() {
                                        dropdownValue = location.locVal ?? '';
                                        selectedLocationKey =
                                            location.locKey ?? '';
                                        print(selectedLocationKey);
                                        isExpanded = false;
                                      });
                                    },
                                    child: Container(
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
                                              title: Center(
                                                  child: Text(
                                                      location.locVal ?? '')),
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, top: 16),
              //   child: Text(
              //     'Select Your Slot',
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //       color: AppThemes.brc_selectyourslot_text.withOpacity(0.6),
              //     ),
              //   ),
              // ),

              // Slots grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: "Select Your Slot"
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 0),
                      child: Text(
                        'Select Your Slot',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppThemes.brc_selectyourslot_text
                              .withOpacity(0.6),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: FutureBuilder(
                        future: buildTimeSlots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.data ?? const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SeperationBar(),
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
                        const Expanded(
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
                      onPressed: isChecked
                          ? () async {
// Call the booking method to make a booking
                              try {
                                String? bookingDate = Booking
                                    .toString(); // Replace 'Booking' with the actual booking date variable
                                if (bookingDate.isNotEmpty) {
                                  setState(() {
                                    isLoading =
                                        true; // Set isLoading to true when button is pressed
                                  });
                                  // Make the booking request
                                  RowingBookingAPI booking =
                                      await RowingBookingAPI.booking(
                                          bookingDate,
                                          selectedLocationKey,
                                          selectedTime);
                                  print('rowing booking doing');

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
                                          '${booking.processMessage} at ${booking.restaurentName} on ${booking.bkDateFormat}',
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
                                        backgroundColor:
                                            AppThemes.brc_otp_error,
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
                                    const SnackBar(
                                      content: Text(
                                        'No booking date selected.',
                                        style: TextStyle(
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
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isChecked
                            ? AppThemes.brc_bottom_icon
                            : AppThemes.brc_not_available_bottom_bg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ), // Disable button if checkbox is not checked
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SeperationBar(),
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
                          Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,

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
                                          offset: const Offset(
                                              0, 2), // Adjust offset as needed
                                        ),
                                      ],
                                    ), // Example color for available
                                  ),
                                  const SizedBox(height: 4),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
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
                                          .brc_helpdesk_screen_card_bg, // Example color for not available
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
                                          offset: const Offset(
                                              0, 2), // Adjust offset as needed
                                        ),
                                      ],
                                    ), // Example color for available
                                  ),
                                  const SizedBox(height: 4),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Unavailable',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                          offset: const Offset(
                                              0, 2), // Adjust offset as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
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
                                          .brc_mybooking_color, // Example color for not available
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
                                          offset: const Offset(
                                              0, 2), // Adjust offset as needed
                                        ),
                                      ],
                                    ), // Example color for available
                                  ),
                                  const SizedBox(height: 4),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'My Booking',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                          offset: const Offset(
                                              0, 2), // Adjust offset as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Blocked',
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
                                      color: Colors.transparent, // Example color for not available
                                      borderRadius: BorderRadius.circular(
                                          4), // Adjust the radius value as needed
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(
                                      //         0.3), // Adjust opacity and color as needed
                                      //     spreadRadius:
                                      //         1, // Adjust spread radius as needed
                                      //     blurRadius:
                                      //         3, // Adjust blur radius as needed
                                      //     offset: const Offset(
                                      //         0, 2), // Adjust offset as needed
                                      //   ),
                                      // ],
                                    ), // Example color for available
                                  ),
                                  const SizedBox(height: 4),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Available',
                                      style: TextStyle(fontSize: 10,
                                      color: Colors.transparent),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               width: 20,
                    //               height: 20,
                    //               decoration: BoxDecoration(
                    //                 color: AppThemes
                    //                     .brc_not_available_bottom_bg, // Example color for not available
                    //                 borderRadius: BorderRadius.circular(4),
                    //                 boxShadow: [
                    //                   BoxShadow(
                    //                     color: Colors.grey.withOpacity(
                    //                         0.3), // Adjust opacity and color as needed
                    //                     spreadRadius:
                    //                         1, // Adjust spread radius as needed
                    //                     blurRadius:
                    //                         3, // Adjust blur radius as needed
                    //                     offset: const Offset(
                    //                         0, 2), // Adjust offset as needed
                    //                   ),
                    //                 ], // Adjust the radius value as needed
                    //               ),
                    //             ),
                    //             // const SizedBox(height: 4),
                    //             const Padding(
                    //               padding: EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 'Unavailable',
                    //                 style: TextStyle(fontSize: 10),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding:
                    //             const EdgeInsets.symmetric(horizontal: 8.0),
                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               width: 20,
                    //               height: 20,
                    //               decoration: BoxDecoration(
                    //                 color: AppThemes.brc_mybooking_color,
                    //                 borderRadius: BorderRadius.circular(4),
                    //                 boxShadow: [
                    //                   BoxShadow(
                    //                     color: Colors.grey.withOpacity(
                    //                         0.3), // Adjust opacity and color as needed
                    //                     spreadRadius:
                    //                         1, // Adjust spread radius as needed
                    //                     blurRadius:
                    //                         3, // Adjust blur radius as needed
                    //                     offset: const Offset(
                    //                         0, 2), // Adjust offset as needed
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             const SizedBox(height: 4),
                    //             const Padding(
                    //               padding: EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 'My Booking',
                    //                 style: TextStyle(fontSize: 10),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final String time;
  final bool available;
  final bool isSelected;
  final Color boxcolor;

  final VoidCallback onTap; // Callback function to handle tap

  const CardWidget({
    super.key,
    required this.time,
    required this.available,
    required this.isSelected, // Add this line

    required this.onTap,
    required this.boxcolor, // Receive the callback function
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(); // Call the onTap callback when the card is tapped
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.available
              ? AppThemes.brc_textcolor
              : AppThemes.brc_not_available_bg,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: AppThemes.slider_button_off,
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: widget.isSelected
                ? AppThemes.brc_otp_success
                : AppThemes.slider_button_off,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.time,
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
                // color: widget.available
                //     ? AppThemes.brc_background
                //     : AppThemes.brc_not_available_bottom_bg,
                color: widget.boxcolor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Center(
                child: Text(
                  widget.available ? 'AVAILABLE' : 'BOOKED',
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
      ),
    );
  }
}
