import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/location_for_table_booking.dart';
import 'package:multi_club_app/bases/api/sports_booking.dart';
import 'package:multi_club_app/bases/api/table_booking.dart';
import 'package:multi_club_app/bases/api/time_slot_table_booking.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/screens/widgets/CalendarSection.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class TableBooking extends StatefulWidget {
  const TableBooking({Key? key}) : super(key: key);

  @override
  _TableBookingState createState() => _TableBookingState();
}

class _TableBookingState extends State<TableBooking> {
  bool isLoading = false;
  String selectedMealType = ''; // Variable to track selected meal type
  String selectedTime = '';
  String selectedLocation = ''; // Change the type to String
  List<String> locations = [];
  String? Booking;
  List<Map<String, String>> locationsList =
      []; // Define locationsList as a list of maps
  String? selectedBooking;
  bool isFetchingLocations = false;

  @override
  void initState() {
    super.initState();
    fetchLocations(); // Fetch locations when the widget initializes
    accessMemberIdFromHive();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      if (meberID != null) {
        print('tablebooking -- ${meberID}');
      } else {
        print('tablebooking -- null');
      }
    });
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
      TimeSlotTableBooking? timeSlotData =
          await TimeSlotTableBooking.booking(formattedDate);
      if (timeSlotData != null) {
        List<Widget> rows = [];

        if (selectedMealType == 'DINNER') {
          List<TimingListDinnerArr>? timingList =
              timeSlotData.timingListDinnerArr;

          if (timingList != null && timingList.isNotEmpty) {
            for (int i = 0; i < timingList.length; i += 3) {
              List<Widget> timeSlots = [];
              for (int j = i; j < i + 3 && j < timingList.length; j++) {
                TimingListDinnerArr slot = timingList[j];
                timeSlots.add(
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardWidget(
                        time: slot.timeSlot ?? '',
                        available: slot.status == 'AVAILABLE',
                        isSelected: selectedTime == (slot.timeSlot ?? ''),
                        onTap: () {
                          handleCardTap(slot.timeSlot ?? '');
                        },
                      ),
                    ),
                  ),
                );
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
          } else {
            return Text('No time slots available for $selectedMealType');
          }
        } else {
          List<TimingListArr>? timingList = timeSlotData.timingListArr;

          if (timingList != null && timingList.isNotEmpty) {
            for (int i = 0; i < timingList.length; i += 3) {
              List<Widget> timeSlots = [];
              for (int j = i; j < i + 3 && j < timingList.length; j++) {
                TimingListArr slot = timingList[j];
                timeSlots.add(
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardWidget(
                        time: slot.timeSlot ?? '',
                        available: slot.status == 'AVAILABLE',
                        isSelected: selectedTime == (slot.timeSlot ?? ''),
                        onTap: () {
                          handleCardTap(slot.timeSlot ?? '');
                        },
                      ),
                    ),
                  ),
                );
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
          } else {
            return Text('No time slots available for $selectedMealType');
          }
        }

        return Column(children: List.from(rows));
      } else {
        return Text('No time slots available');
      }
    } catch (error) {
      print('Error building time slots: $error');
      return Text('Error building time slots');
    }
  }

  Future<void> fetchLocations() async {
    try {
      setState(() {
        isFetchingLocations = true;
      });
      LocationTableBooking locationData = await LocationTableBooking.booking();
      setState(() {
        locationsList = (locationData.locationData ?? []).map((location) {
          return {
            'loc_key': location.locKey.toString(),
            'loc_val': location.locVal ?? '',
          };
        }).toList();
        isFetchingLocations = false;
      });
    } catch (error) {
      print('Error fetching locations: $error');
      setState(() {
        isFetchingLocations = false;
      });
    }
  }

  String? meberID;
  final _userData = Hive.box('UserData');

  Future<void> accessMemberIdFromHive() async {
    // Open the Hive box
    var box = await Hive.openBox('UserData');

    // Retrieve the user data from Hive
    var userData = box.get('user_data_key');
    var memberId;
    // Access the memberid from the user data
    if (userData != null) {
      memberId = userData['firstname'];
    }
    // Check if memberId is not null before using it
    if (memberId != null) {
      meberID = memberId.toString();
      print('Member ID in slsh Screen: $meberID');
    } else {
      print('Member ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.brc_background,
        title: const Text(
          'New Booking',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15, // Set text color to white
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CalendarSection(
            onDateSelected: (DateTime selectedDate) {
              // Do something with the selected date
              Booking = selectedDate.toString();
              print('Selected Date: $Booking');
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AutoCompleteTextField<String>(
                  key: GlobalKey(),
                  clearOnSubmit: false,
                  suggestions: locationsList
                      .map((location) => location['loc_val']!)
                      .toList(),
                  decoration: InputDecoration(
                    hintText: 'Select your space',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 6.0,
                    ),
                  ),
                  itemFilter: (item, query) {
                    return item.toLowerCase().contains(query.toLowerCase());
                  },
                  itemSorter: (a, b) {
                    return a.compareTo(b);
                  },
                  itemSubmitted: (item) {
                    setState(() {
                      // Find the corresponding location with loc_val
                      final selectedLoc = locationsList.firstWhere(
                        (location) => location['loc_val'] == item,
                        orElse: () => {
                          'loc_key': '',
                          'loc_val': ''
                        }, // Provide a default value
                      );
                      // Update selectedLocation with loc_key
                      selectedLocation = selectedLoc['loc_key'] ??
                          ''; // Provide a default value
                      setState(() {
                        selectedLocation = selectedLoc['loc_key'] ??
                            ''; // Provide a default value
                        ;
                        print(selectedLocation);
                      });
                    });
                  },
                  itemBuilder: (context, item) {
                    return ListTile(
                      title: Text(item),
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (isFetchingLocations)
                  Center(child: CircularProgressIndicator())
                else
                  Container(
                    decoration: BoxDecoration(
                      color: AppThemes.brc_textcolor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: locationsList.map((location) {
                          final locKey = location['loc_key'];
                          final locVal = location['loc_val'];
                          if (locKey != null && locVal != null) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedLocation = locKey;
                                    print(selectedLocation);
                                  });
                                },
                                child: Container(
                                  color: selectedLocation == locKey
                                      ? AppThemes.brc_background
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      locVal,
                                      style: TextStyle(
                                        color: selectedLocation == locKey
                                            ? AppThemes.brc_textcolor
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
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
                              // Update selected meal type and perform action
                              setState(() {
                                selectedMealType = 'LUNCH';
                              });
                              // Call a function or pass data related to lunch
                              sendData(selectedMealType);
                            },
                            child: Text(
                              'LUNCH',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: selectedMealType == 'LUNCH'
                                    ? AppThemes.brc_textcolor
                                    : AppThemes.brc_tablebooking_dark_text,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedMealType == 'LUNCH'
                                  ? AppThemes.brc_background
                                  : AppThemes.brc_textcolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Update selected meal type and perform action
                              setState(() {
                                selectedMealType = 'DINNER';
                              });
                              // Call a function or pass data related to dinner
                              sendData(selectedMealType);
                            },
                            child: Text(
                              'DINNER',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: selectedMealType == 'DINNER'
                                    ? AppThemes.brc_textcolor
                                    : AppThemes.brc_tablebooking_dark_text,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedMealType == 'DINNER'
                                  ? AppThemes.brc_background
                                  : AppThemes.brc_textcolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: CardWidget(
          //           time: '01:00 PM',
          //           available: true,
          //         ),
          //       ),
          //       SizedBox(width: 8),
          //       Expanded(
          //         child: CardWidget(
          //           time: '01:30 PM',
          //           available: true,
          //         ),
          //       ),
          //       SizedBox(width: 8),
          //       Expanded(
          //         child: CardWidget(
          //           time: '02:00 PM',
          //           available: true,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder(
                  future: buildTimeSlots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
          SeperationBar(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Special Request"
              // Padding(
              //   padding: const EdgeInsets.only(left: 140, top: 16),
              //   child: Text(
              //     'Special Request',
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //       color: AppThemes.brc_bottom_icon,
              //     ),
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: SizedBox(
              //     height: 150, // Adjust height as needed
              //     child: Card(
              //       elevation: 5,
              //       surfaceTintColor: AppThemes.brc_textcolor,
              //       shadowColor: Colors.black,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: TextField(
              //           maxLines: null, // Allow multiple lines of text
              //           decoration: InputDecoration(
              //             hintText: 'Fill in Here',
              //             hintStyle: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w400,
              //                 color: AppThemes.brc_tablebooking_dark_text
              //                     .withOpacity(0.3)),
              //             border: InputBorder.none, // Remove border
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Confirm booking button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: ElevatedButton(
                  onPressed: () async {
                    // Call the booking method to make a booking
                    try {
                      String? bookingDate = Booking
                          .toString(); // Replace 'Booking' with the actual booking date variable
                      if (bookingDate != null && bookingDate.isNotEmpty) {
                        setState(() {
                          isLoading =
                              true; // Set isLoading to true when button is pressed
                        });
                        // Make the booking request
                        TableBookingAPI booking = await TableBookingAPI.booking(
                          selectedLocation!,
                          bookingDate,
                          selectedMealType,
                          selectedTime,
                          // Pass the selected meal type to the booking method
                        );
                        // SportsBookingAPI sbooking =
                        //     await SportsBookingAPI.booking();
                        print('after api the location ${selectedLocation}');

                        setState(() {
                          isLoading =
                              false; // Set isLoading to false after data is fetched
                        });
                        // // Check the booking response
                        // if (sbooking.processStatus == 'YES') {
                        //   // Booking successful
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //         'sport booking${sbooking.processMessage}  on ${sbooking.bkDateFormat}',
                        //         style: const TextStyle(
                        //           color: AppThemes.brc_textcolor,
                        //         ),
                        //       ),
                        //       backgroundColor: AppThemes.brc_otp_success,
                        //       behavior: SnackBarBehavior.floating,
                        //     ),
                        //   );
                        //   print(
                        //       'Booking successful. Booking ID: ${sbooking.bookingId}');
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //         'sport booking${sbooking.processMessage}',
                        //         style: const TextStyle(
                        //           color: AppThemes.brc_textcolor,
                        //         ),
                        //       ),
                        //       backgroundColor: AppThemes.brc_otp_error,
                        //       behavior: SnackBarBehavior.floating,
                        //     ),
                        //   );
                        //   // Booking failed
                        //   print(
                        //       'sport booking Booking failed: ${sbooking.processMessage}');
                        // }
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
                              backgroundColor: AppThemes.brc_otp_success,
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
                          print('Booking failed: ${booking.processMessage}');
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
        ],
      ),
    );
  }
}

void sendData(String mealType) {
  // Print or pass data based on selected meal type
  print('Selected meal type: $mealType');
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

class CardWidget extends StatefulWidget {
  final String time;
  final bool available;
  final bool isSelected; // New parameter

  final VoidCallback onTap; // Callback function to handle tap

  const CardWidget({
    Key? key,
    required this.time,
    required this.available,
    required this.isSelected, // Add this line

    required this.onTap, // Receive the callback function
  }) : super(key: key);

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
          boxShadow: [
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
              padding: EdgeInsets.only(top: 8),
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
                color: widget.available
                    ? AppThemes.brc_background
                    : AppThemes.brc_not_available_bottom_bg,
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
