import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';

class UserDataRepository {
  static const String _boxName = 'UserData';

  static Future<void> saveFirebaseToken(String? token) async {
    try {
      var box = await Hive.openBox(_boxName);
      await box.put('firebase_token', token);
      print('Firebase token saved: $token');
    } catch (e) {
      print('Error saving Firebase token: $e');
    }
  }

  static Future<String?> getFirebaseToken() async {
    try {
      var box = await Hive.openBox(_boxName);
      return box.get('firebase_token') as String?;
    } catch (e) {
      print('Error retrieving Firebase token: $e');
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
      var box = await Hive.openBox(_boxName);
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
      var box = await Hive.openBox(_boxName);
      await box.put('user_data_key', userData.toJson());
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  static Future<UserOtpAPI?> getUserData() async {
    try {
      var box = await Hive.openBox(_boxName);
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
