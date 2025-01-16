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

const String APP_VERSION = "1.0.0"; // Change this to match your current app version

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

Future<void> _initializeFlutterLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        log('Notification payload: ${response.payload}');
      }
    },
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive first
  await Hive.initFlutter();
  await Hive.openBox('UserData');

  // Then initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Now get FCM token
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await UserDataRepository.saveFirebaseToken(fcmToken);
      print('FCM Token: $fcmToken');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      UserDataRepository.saveFirebaseToken(newToken);
      print('FCM Token Refreshed: $newToken');
    });
  } catch (e) {
    print('Error initializing FCM: $e');
  }

  await _initializeFlutterLocalNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeMessaging();
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
              icon: 'notification_icon',
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
