import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

// class CouncilAPI {
//   String? processStatus;
//   String? processMessage;
//   List<String>? contactNameArray;
//   List<String>? contactPhoneArray;
//   List<String>? contactEmailArray;
//   List<String>? contactDesignationArray;

//   CouncilAPI(
//       {this.processStatus,
//       this.processMessage,
//       this.contactNameArray,
//       this.contactPhoneArray,
//       this.contactEmailArray,
//       this.contactDesignationArray});

//   CouncilAPI.fromJson(Map<String, dynamic> json) {
//     processStatus = json['process_status'];
//     processMessage = json['process_message'];
//     contactNameArray = json['contact_name_array'].cast<String>();
//     contactPhoneArray = json['contact_phone_array'].cast<String>();
//     contactEmailArray = json['contact_email_array'].cast<String>();
//     contactDesignationArray = json['contact_designation_array'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['process_status'] = this.processStatus;
//     data['process_message'] = this.processMessage;
//     data['contact_name_array'] = this.contactNameArray;
//     data['contact_phone_array'] = this.contactPhoneArray;
//     data['contact_email_array'] = this.contactEmailArray;
//     data['contact_designation_array'] = this.contactDesignationArray;
//     return data;
//   }

// static Future<CouncilAPI> list() async {
//   Uri url = Uri.parse(
//       "${Webservice.rootURL}${Webservice.council_members_list}?nickname=${Webservice.appNickname}");
//   final request = http.MultipartRequest('POST', url);
//   String? accessCode = await UserDataRepository.getAccessCode();
//   if (accessCode != null) {
//     print('Access Code: $accessCode');
//   } else {
//     print('Access code fro council member not found');
//   }
//   request.fields.addAll({
//     'organization_id': Webservice.appNickname,
//     'theaccesscode': '$accessCode'
//   });

//   http.StreamedResponse response = await request.send();
//   String responseString = await response.stream.bytesToString();
//   // print(responseString);
//   return CouncilAPI.fromJson(jsonDecode(responseString));
// }
// }
class CouncilAPI {
  String? processStatus;
  String? processMessage;
  List<Data>? data;

  CouncilAPI({this.processStatus, this.processMessage, this.data});

  CouncilAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<CouncilAPI> list() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.council_members_list}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code fro council member not found');
    }
    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      'theaccesscode': '$accessCode'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print(responseString);
    return CouncilAPI.fromJson(jsonDecode(responseString));
  }
}

class Data {
  String? memberId;
  String? name;
  String? designation;
  String? category;
  String? year;
  String? city;
  String? phone;

  Data(
      {this.memberId,
      this.name,
      this.designation,
      this.category,
      this.year,
      this.phone,
      this.city});

  Data.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    name = json['name'];
    designation = json['designation'];
    category = json['category'];
    year = json['year'];
    city = json['city'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['member_id'] = memberId;
    data['name'] = name;
    data['designation'] = designation;
    data['category'] = category;
    data['year'] = year;
    data['city'] = city;
    data['phone'] = phone;
    return data;
  }
}
