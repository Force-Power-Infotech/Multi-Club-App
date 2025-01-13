import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_club_app/bases/api/firebase_messaging_service.dart';
import 'package:multi_club_app/bases/themes.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/screens/splash_screen_brc.dart';
import 'package:multi_club_app/screens/splash_screen_madhuban.dart';
import 'package:multi_club_app/screens/splash_screen_millenniumMams.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("Handling a background message: ${message.messageId}");
  } catch (e) {
    log("Error in background handler: $e");
  }
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase first
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    
    // Initialize Hive
    await Hive.initFlutter();
    await Hive.openBox('UserData');
    
    // Initialize notifications
    // await _initializeFlutterLocalNotifications();
    
    // Initialize Firebase Messaging
    // await FirebaseMessagingService.initialize();
    
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    runApp(const MyApp());
  } catch (e) {
    log("Error during initialization: $e");
    // You might want to show an error screen here
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Error initializing app: $e"),
        ),
      ),
    ));
  }
}

Future<void> _initializeFlutterLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestProvisionalPermission: false,
    requestCriticalPermission: false,
    defaultPresentAlert: true,
    defaultPresentSound: true,
    defaultPresentBadge: true,
    defaultPresentBanner: true,
    defaultPresentList: true,
    notificationCategories: <DarwinNotificationCategory>[],
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState(); // Move super.initState() to the top
    
    // _initializeMessaging();
  }

  Future<void> _initializeMessaging() async {
    try {
      final token = await UserDataRepository.getFirebaseToken();
      log('Firebase token retrieved: $token');

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleAppOpenedMessage);
    } catch (e) {
      log("Error setting up messaging: $e");
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    } catch (e) {
      log("Error handling foreground message: $e");
    }
  }

  void _handleAppOpenedMessage(RemoteMessage message) {
    log('App opened from notification: ${message.messageId}');
  }

  @override
  Widget build(BuildContext context) {
    String appNickname = Webservice.appNickname;

    // Ensure the app nickname exists in our maps
    if (!splashMap.containsKey(appNickname)) {
      log("Warning: Unknown app nickname: $appNickname");
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName[appNickname] ?? appNickname, // Use nickname as fallback
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: AppThemes.brc_helpdesk_text_color,
        ),
        useMaterial3: true,
      ),
      home: splashMap[appNickname] ?? const SplashScreenBRC(), // Provide default splash screen
    );
  }

  final Map<String, Widget> splashMap = {
    'forcempower': const SplashScreenBRC(),
    'BRC': const SplashScreenBRC(),
    'stardb': const SplashScreenMadhuban(),
    'madhuban': const SplashScreenMadhuban(),
    'millmams': const SplashScreenmillenniumMams(),
  };

  final Map<String, String> appName = {
    'madhuban': 'Madhuwan',
    'millmams': 'MM',
    'forcempower': 'BRC',
    'BRC': 'BRC',
    'stardb': 'Madhuban',
  };
}
