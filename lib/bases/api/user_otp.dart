import 'dart:convert';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class UserOtpAPI {
  String? processStatus;
  String? processMessage;
  String? memberid;
  String? uId;
  String? theOtp;
  String? firstname;
  String? lastname;
  String? mobile;
  String? email;
  String? theaccesscode;
  String? dob;
  String? dateOfJoining;
  String? dateOfWedding;
  String? spouse;
  String? spouseDob;
  String? resiAddress1;
  String? resiAddress2;
  String? resiAddress3;
  String? resiAddress4;
  String? resiAddressState;
  String? resiAddressPin;
  String? child1;
  String? child2;
  String? child3;
  String? child4;
  String? officeAddress;
  String? memberImageUrl;
  String? spouseImageUrl;
  String? createdDate;
  String? handicap;
  String? currHcMonthName;
  String? gender;
  String? courseHandicapBlue;
  String? courseHandicapWhite;
  String? courseHandicapYellow;
  String? courseHandicapRed;
  String? pass;
  String? login_type;

  UserOtpAPI({
    this.processStatus,
    this.processMessage,
    this.memberid,
    this.uId,
    this.theOtp,
    this.firstname,
    this.lastname,
    this.mobile,
    this.email,
    this.theaccesscode,
    this.dob,
    this.dateOfJoining,
    this.dateOfWedding,
    this.spouse,
    this.spouseDob,
    this.resiAddress1,
    this.resiAddress2,
    this.resiAddress3,
    this.resiAddress4,
    this.resiAddressState,
    this.resiAddressPin,
    this.child1,
    this.child2,
    this.child3,
    this.child4,
    this.officeAddress,
    this.memberImageUrl,
    this.spouseImageUrl,
    this.createdDate,
    this.handicap,
    this.currHcMonthName,
    this.gender,
    this.courseHandicapBlue,
    this.courseHandicapWhite,
    this.courseHandicapYellow,
    this.courseHandicapRed,
    this.login_type,
    this.pass,
  });

  // void saveUserData(UserOtpAPI userData) async {
  //   var box = await Hive.openBox('UserData');
  //   await box.put('user_data_key', userData.toJson());
  //   print(box.get('user_data_key'));
  // }

  Map<String, dynamic> toJson() {
    return {
      'process_status': processStatus,
      'process_message': processMessage,
      'memberid': memberid,
      'u_id': uId,
      'the_otp': theOtp,
      'firstname': firstname,
      'lastname': lastname,
      'mobile': mobile,
      'email': email,
      'theaccesscode': theaccesscode,
      'dob': dob,
      'date_of_joining': dateOfJoining,
      'date_of_wedding': dateOfWedding,
      'spouse': spouse,
      'spouse_dob': spouseDob,
      'resi_address_1': resiAddress1,
      'resi_address_2': resiAddress2,
      'resi_address_3': resiAddress3,
      'resi_address_4': resiAddress4,
      'resi_address_state': resiAddressState,
      'resi_address_pin': resiAddressPin,
      'child1': child1,
      'child2': child2,
      'child3': child3,
      'child4': child4,
      'office_address': officeAddress,
      'member_image_url': memberImageUrl,
      'spouse_image_url': spouseImageUrl,
      'created_date': createdDate,
      'handicap': handicap,
      'curr_hc_month_name': currHcMonthName,
      'gender': gender,
      'course_handicap_blue': courseHandicapBlue,
      'course_handicap_white': courseHandicapWhite,
      // 'course_handicap_yellow': courseHandicapYellow,
      'course_handicap_red': courseHandicapRed,
      'pass': pass,
      'login_type': login_type,
    };
  }

  static Future<UserOtpAPI> login(String username, String otp) async {
    Uri url = Uri.parse(
        "https://club.forcempower.com/MADHUBAN/ws_member_confirm_otp_v5.php");
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'user_name': username,
      'the_otp': otp,
      'device_type': 'ANDROID',
      'organization_id': Webservice.appNickname
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    UserOtpAPI userOtp = UserOtpAPI.fromJson(jsonDecode(responseString));
    await UserDataRepository.saveUserData(userOtp);
    // print(UserDataRepository.getMemberID());
    return userOtp;
  }

  factory UserOtpAPI.fromJson(Map<String, dynamic> json) {
    return UserOtpAPI(
      processStatus: json['process_status'],
      processMessage: json['process_message'],
      memberid: json['memberid'],
      uId: json['u_id'],
      theOtp: json['the_otp'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      mobile: json['mobile'],
      email: json['email'],
      theaccesscode: json['theaccesscode'],
      dob: json['dob'],
      dateOfJoining: json['date_of_joining'],
      dateOfWedding: json['date_of_wedding'],
      spouse: json['spouse'],
      spouseDob: json['spouse_dob'],
      resiAddress1: json['resi_address_1'],
      resiAddress2: json['resi_address_2'],
      resiAddress3: json['resi_address_3'],
      resiAddress4: json['resi_address_4'],
      resiAddressState: json['resi_address_state'],
      resiAddressPin: json['resi_address_pin'],
      child1: json['child1'],
      child2: json['child2'],
      child3: json['child3'],
      child4: json['child4'],
      officeAddress: json['office_address'],
      memberImageUrl: json['member_image_url'],
      spouseImageUrl: json['spouse_image_url'],
      createdDate: json['created_date'],
      handicap: json['handicap'],
      currHcMonthName: json['curr_hc_month_name'],
      gender: json['gender'],
      courseHandicapBlue: json['course_handicap_blue'],
      courseHandicapWhite: json['course_handicap_white'],
      courseHandicapYellow: json['course_handicap_yellow'],
      courseHandicapRed: json['course_handicap_red'],
      pass: json['pass'],
      login_type: json['login_type'],
    );
  }
}
