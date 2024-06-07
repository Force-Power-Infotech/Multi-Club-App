import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class DobAPI {
//   String? processStatus;
//   String? processMessage;
//   List<String>? memberName;
//   List<String>? memberDob;
//   List<String>? memberContact;
//   List<String>? memberMail;
//   List<String>? memberID;

//   DobAPI(
//       {this.processStatus,
//       this.processMessage,
//       this.memberName,
//       this.memberDob,
//       this.memberContact,
//       this.memberID,
//       this.memberMail});

//   DobAPI.fromJson(Map<String, dynamic> json) {
//     processStatus = json['process_status'];
//     processMessage = json['process_message'];
//     memberName = json['member_name'].cast<String>();
//     memberDob = json['member_dob'].cast<String>();
//     memberContact = json['member_contact'].cast<String>();
//     memberMail = json['member_mail'].cast<String>();
//     memberID = json['member_id'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['process_status'] = processStatus;
//     data['process_message'] = processMessage;
//     data['member_name'] = memberName;
//     data['member_dob'] = memberDob;
//     data['member_contact'] = memberContact;
//     data['member_mail'] = memberMail;
//     data['member_id'] = memberID;
//     return data;
//   }

// static Future<DobAPI> details() async {
//   // Get today's date
//   // DateTime now = DateTime.now();
//   // String formattedDate = '${now.day}-${now.month}-${now.year}';

//   Uri url = Uri.parse(
//       "${Webservice.rootURL}${Webservice.birthday}?nickname=${Webservice.appNickname}");
//   final request = http.MultipartRequest('POST', url);
//   request.fields.addAll({
//     'association_code': 'ALL',
//     'theaccesscode': 'GUEST',
//     'user_type': 'kraken'
//   });

//   http.StreamedResponse response = await request.send();
//   String responseString = await response.stream.bytesToString();
//   // print('in dobapi code ${responseString}');
//   return DobAPI.fromJson(jsonDecode(responseString));
// }
// }
class DobAPI {
  String? processStatus;
  String? processMessage;
  List<Data>? data;

  DobAPI({this.processStatus, this.processMessage, this.data});

  DobAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<DobAPI> details() async {
    // Get today's date
    // DateTime now = DateTime.now();
    // String formattedDate = '${now.day}-${now.month}-${now.year}';

    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.birthday}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'association_code': 'ALL',
      'theaccesscode': 'GUEST',
      'user_type': 'kraken'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('in dobapi code ${responseString}');
    return DobAPI.fromJson(jsonDecode(responseString));
  }
}

class Data {
  String? memberId;
  String? memberName;
  String? memberDob;
  String? memberContact;
  String? memberMail;
  String? imageUrl;

  Data(
      {this.memberId,
      this.memberName,
      this.memberDob,
      this.memberContact,
      this.memberMail,
      this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    memberName = json['member_name'];
    memberDob = json['member_dob'];
    memberContact = json['member_contact'];
    memberMail = json['member_mail'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['member_dob'] = this.memberDob;
    data['member_contact'] = this.memberContact;
    data['member_mail'] = this.memberMail;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
