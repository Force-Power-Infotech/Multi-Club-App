import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';

class UserDataRepository {
  static const String _boxName = 'UserData';
  static const String FCM_TOKEN_KEY = 'fcm_token';

  static Future<Box> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      try {
        return await Hive.openBox(_boxName);
      } catch (e) {
        // If Hive isn't initialized, initialize it
        if (e.toString().contains('Hive is not initialized')) {
          await Hive.initFlutter();
          return await Hive.openBox(_boxName);
        }
        rethrow;
      }
    }
    return Hive.box(_boxName);
  }

  static Future<void> saveFirebaseToken(String? token) async {
    if (token != null) {
      try {
        final box = await _openBox();
        await box.put(FCM_TOKEN_KEY, token);
        print('FCM token saved to Hive: $token');
      } catch (e) {
        print('Error saving FCM token: $e');
      }
    }
  }

  static Future<String?> getFirebaseToken() async {
    try {
      final box = await _openBox();
      return box.get(FCM_TOKEN_KEY);
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<String?> getAccessCode() async {
    try {
      final userData = await getUserData();
      return userData?.theaccesscode;
    } catch (e) {
      print('Error retrieving access code: $e');
      return null;
    }
  }

  static Future<String?> getprofileimg() async {
    try {
      var box = await _openBox();
      var userDataMap = box.get('user_data_key') as Map<String, dynamic>;
      print(userDataMap);
      return userDataMap['memberImageUrl'] as String?;
    } catch (e) {
      print('Error retrieving access code: $e');
      return null;
    }
  }

  static Future<String?> getMemberID() async {
    try {
      final userData = await getUserData();
      return userData?.memberid;
    } catch (e) {
      print('Error retrieving member ID: $e');
      return null;
    }
  }

  static Future<String?> getMembername() async {
    try {
      final userData = await getUserData();
      return userData?.firstname;
    } catch (e) {
      print('Error retrieving member name: $e');
      return null;
    }
  }

  static Future<String?> getProfileImage() async {
    try {
      final userData = await getUserData();
      return userData?.memberImageUrl;
    } catch (e) {
      print('Error retrieving profile image: $e');
      return null;
    }
  }

  static Future<void> saveUserData(UserOtpAPI userData) async {
    try {
      var box = await _openBox();
      await box.put('user_data_key', userData.toJson());
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static Future<UserOtpAPI?> getUserData() async {
    try {
      var box = await _openBox();
      var userData = box.get('user_data_key');
      if (userData != null) {
        return UserOtpAPI.fromJson(Map<String, dynamic>.from(userData));
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }
}
