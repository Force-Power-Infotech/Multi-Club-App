import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

// class DirectoryAPI {
//   String? processStatus;
//   String? processMessage;
//   List<String>? memberNameArray;
//   List<String>? memberPhoneArray;
//   List<String>? memberIdArray;
//   List<String>? memberImageUrlArray;

//   DirectoryAPI(
//       {this.processStatus,
//       this.processMessage,
//       this.memberNameArray,
//       this.memberPhoneArray,
//       this.memberIdArray,
//       this.memberImageUrlArray});

//   DirectoryAPI.fromJson(Map<String, dynamic> json) {
//     processStatus = json['process_status'];
//     processMessage = json['process_message'];
//     memberNameArray = json['member_name_array'].cast<String>();
//     memberPhoneArray = json['member_phone_array'].cast<String>();
//     memberIdArray = json['member_id_array'].cast<String>();
//     memberImageUrlArray = json['member_image_url_array'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['process_status'] = this.processStatus;
//     data['process_message'] = this.processMessage;
//     data['member_name_array'] = this.memberNameArray;
//     data['member_phone_array'] = this.memberPhoneArray;
//     data['member_id_array'] = this.memberIdArray;
//     data['member_image_url_array'] = this.memberImageUrlArray;
//     return data;
//   }

//   static Future<DirectoryAPI> directory(
//       String eventid, String attainding_status) async {
//     Uri url = Uri.parse(
//         "${Webservice.rootURL}${Webservice.directory}?nickname=${Webservice.appNickname}");
//     final request = http.MultipartRequest('POST', url);

//     request.fields.addAll({
//       'organization_id': Webservice.appNickname,
//     });
//     http.StreamedResponse response = await request.send();
//     String responseString = await response.stream.bytesToString();
//     // print(responseString);
//     return DirectoryAPI.fromJson(jsonDecode(responseString));
//   }

//   static fetchContacts(String s, String t) {}
// }
class DirectoryAPI {
  String? processStatus;
  String? processMessage;
  List<Data>? data;

  DirectoryAPI({this.processStatus, this.processMessage, this.data});

  DirectoryAPI.fromJson(Map<String, dynamic> json) {
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

  static Future<DirectoryAPI> directory() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.directory}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'organization_id': Webservice.appNickname,
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print(responseString);
    return DirectoryAPI.fromJson(jsonDecode(responseString));
  }
}

class Data {
  String? membershipCode;
  String? memberNameMale;
  String? memberMalePhone;
  String? memberMaleDob;
  String? memberMaleAge;
  String? memberNameFemale;
  String? memberFemalePhone;
  String? memberFemaleDob;
  String? memberFemaleAge;
  String? imageURLmale;
  String? imageURLfemale;
  String? city;
  String? global;
  String? classs;

  Data(
      {this.membershipCode,
      this.memberNameMale,
      this.memberMalePhone,
      this.memberMaleDob,
      this.memberMaleAge,
      this.memberNameFemale,
      this.memberFemalePhone,
      this.memberFemaleDob,
      this.imageURLmale,
      this.imageURLfemale,
      this.city,
      this.memberFemaleAge,
      this.global,
      this.classs});

  Data.fromJson(Map<String, dynamic> json) {
    membershipCode = json['membership_code'];
    memberNameMale = json['member_name_male'];
    memberMalePhone = json['member_male_phone'];
    memberMaleDob = json['member_male_dob'];
    memberMaleAge = json['member_male_age'];
    memberNameFemale = json['member_name_female'];
    memberFemalePhone = json['member_female_phone'];
    memberFemaleDob = json['member_female_dob'];
    memberFemaleAge = json['member_female_age'];
    imageURLmale = json['member_image_url'];
    imageURLfemale = json['spouse_image_url'];
    city = json['city'];
    global = json['global'];
    classs = json['class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membership_code'] = membershipCode;
    data['member_name_male'] = memberNameMale;
    data['member_male_phone'] = memberMalePhone;
    data['member_male_dob'] = memberMaleDob;
    data['member_male_age'] = memberMaleAge;
    data['member_name_female'] = memberNameFemale;
    data['member_female_phone'] = memberFemalePhone;
    data['member_female_dob'] = memberFemaleDob;
    data['member_female_age'] = memberFemaleAge;
    data['member_image_url'] = imageURLmale;
    data['spouse_image_url'] = imageURLfemale;
    data['city'] = city;
    data['global'] = global;
    data['class'] = classs;
    return data;
  }
}
