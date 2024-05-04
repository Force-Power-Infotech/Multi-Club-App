import 'package:hive/hive.dart';
import 'package:multi_club_app/bases/api/user_otp.dart';

class UserDataRepository {
  static const String _boxName = 'UserData';

  static Future<String?> getAccessCode() async {
    try {
      var box = await Hive.openBox(_boxName);
      var userDataMap = box.get('user_data_key') as Map<String, dynamic>;
      print(userDataMap);
      if (userDataMap != null) {
        return userDataMap['theaccesscode'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving access code: $e');
      return null;
    }
  }

  static Future<String?> getMemberID() async {
    try {
      var box = await Hive.openBox(_boxName);
      var userDataMap = box.get('user_data_key') as Map<String, dynamic>;
      print(userDataMap);
      if (userDataMap != null) {
        return userDataMap['memberid'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving access code: $e');
      return null;
    }
  }

  static Future<String?> getMembername() async {
    try {
      var box = await Hive.openBox(_boxName);
      var userDataMap = box.get('user_data_key') as Map<String, dynamic>;
      print(userDataMap);
      if (userDataMap != null) {
        return userDataMap['firstname'] as String?;
      } else {
        return null;
      }
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
      if (userDataMap != null) {
        return userDataMap['memberImageUrl'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving access code: $e');
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
      var userDataMap = box.get('user_data_key') as Map<String, dynamic>;
      if (userDataMap != null) {
        return UserOtpAPI.fromJson(userDataMap);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }
}
