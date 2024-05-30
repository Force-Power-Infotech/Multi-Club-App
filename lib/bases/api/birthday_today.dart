import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DobAPI {
  String? processStatus;
  String? processMessage;
  List<String>? memberName;
  List<String>? memberDob;
  List<String>? memberContact;
  List<String>? memberMail;
  List<String>? memberID;

  DobAPI(
      {this.processStatus,
      this.processMessage,
      this.memberName,
      this.memberDob,
      this.memberContact,
      this.memberID,
      this.memberMail});

  DobAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    memberName = json['member_name'].cast<String>();
    memberDob = json['member_dob'].cast<String>();
    memberContact = json['member_contact'].cast<String>();
    memberMail = json['member_mail'].cast<String>();
    memberID = json['member_id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['member_name'] = memberName;
    data['member_dob'] = memberDob;
    data['member_contact'] = memberContact;
    data['member_mail'] = memberMail;
    data['member_id'] = memberID;
    return data;
  }

  static Future<DobAPI> details() async {
    // Get today's date
    DateTime now = DateTime.now();
    String formattedDate = '${now.day}-${now.month}-${now.year}';

    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.birthday}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'association_code': 'CSC',
      'theaccesscode': 'BmP1',
      'user_type': 'club_member',
      // 'birthday': formattedDate, // Set today's date
      // 'birthday': '24-01-2024', // Set today's date
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('in dobapi code ${responseString}');
    return DobAPI.fromJson(jsonDecode(responseString));
  }
}
