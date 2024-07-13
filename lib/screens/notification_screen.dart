import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/api/show_notification.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/webservice.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedOption = 'DEFAULT'; // Default selected option
  List<NotificationData> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedOption = 'DEFAULT'; // Set selectedOption as DEFAULT
    // Fetch notifications when the screen initializes
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // Fetch notifications from the API
      ShowNotifications? showNotifications =
          await ShowNotifications.getnotification();
      if (showNotifications != null) {
        // Filter notifications based on category
        List<NotificationData> bookingAlerts = [];
        List<NotificationData> clubAlerts = [];

        showNotifications.notificationData?.forEach((notification) {
          if (notification.category == 'DEFAULT') {
            bookingAlerts.add(notification);
          } else if (notification.category == 'Club Alerts') {
            clubAlerts.add(notification);
          }
        });

        setState(() {
          notifications =
              selectedOption == 'DEFAULT' ? bookingAlerts : clubAlerts;
          isLoading = false; // Set loading to false when data is fetched
        });
        print('SUCCES fetching notifications: $notifications');
      }
    } catch (error) {
      // Handle error if fetching notifications fails
      print('Error fetching notifications: $error');
      // Set loading to false even if there's an error
      setState(() {
        isLoading = false;
      });
    }
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
          'Notifications',
          style: TextStyle(
            color: AppThemes.brc_textcolor,
            fontWeight: FontWeight.w700,
            fontSize: 15, // Set text color to white
          ),
        ),
        // centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              if (Webservice.appNickname != 'madhuban' &&
                  Webservice.appNickname != 'milleniumMams')
                Container(
                  color: AppThemes.brc_textcolor,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  selectedOption = 'DEFAULT';
                                  isLoading = true;
                                });

                                // Call the function to fetch notifications
                                await fetchNotifications();

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Text(
                                'DEFAULT',
                                style: TextStyle(
                                  color: AppThemes.brc_spotsbooking_hint_text,
                                  fontSize: 15,
                                  fontWeight: selectedOption == 'DEFAULT'
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              height: selectedOption == 'DEFAULT'
                                  ? 3
                                  : 0.5, // Adjust the height of the divider based on the selected option
                              color: AppThemes
                                  .brc_notification_divider, // Color of the divider
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  selectedOption = 'Club Alerts';
                                  isLoading = true;
                                });

                                // Call the function to fetch notifications
                                await fetchNotifications();

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Text(
                                'Club Alerts',
                                style: TextStyle(
                                  color: AppThemes.brc_spotsbooking_hint_text,
                                  fontSize: 15,
                                  fontWeight: selectedOption == 'DEFAULT'
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              height: selectedOption == 'Club Alerts'
                                  ? 3
                                  : 0.5, // Adjust the height of the divider based on the selected option
                              color: AppThemes
                                  .brc_notification_divider, // Color of the divider
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              selectedOption == 'DEFAULT'
                  ? BookingAlertsBody(notifications: notifications)
                  : ClubAlertsBody(notifications: notifications),
            ],
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class BookingAlertsBody extends StatelessWidget {
  final List<NotificationData> notifications;

  const BookingAlertsBody({required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Filter notifications with category 'DEFAULT'
    List<NotificationData> bookingAlerts = notifications
        .where((notification) => notification.category == 'DEFAULT')
        .toList();

    return Column(
      children: bookingAlerts.map((notification) {
        return NotificationItem(notification: notification);
      }).toList(),
    );
  }
}

class ClubAlertsBody extends StatelessWidget {
  final List<NotificationData> notifications;

  const ClubAlertsBody({required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Filter notifications with category 'Club Alerts'
    List<NotificationData> clubAlerts = notifications
        .where((notification) => notification.category == 'Club Alerts')
        .toList();

    return Column(
      children: clubAlerts.map((notification) {
        return NotificationItem(notification: notification);
      }).toList(),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationData notification;

  const NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          color: AppThemes.brc_textcolor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppThemes.brc_spotsbooking_hint_text
                            .withOpacity(0.09),
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/golf-ball 1.png',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {
                        // Add onPressed action for the helpdesk icon
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppThemes.brc_spotsbooking_hint_text,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            notification.description ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppThemes.brc_spotsbooking_hint_text,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            notification.dateTime ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppThemes.brc_spotsbooking_hint_text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SeperationBar()
      ],
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
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Container(
        width: double.infinity,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppThemes.brc_separation_bar,
        ),
      ),
    );
  }
}

// class ClubAlertsBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: notifications.map((notification) {
//         return NotificationItem(notification: notification);
//       }).toList(),
//     );
//   }
// }
