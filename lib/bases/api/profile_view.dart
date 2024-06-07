import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

// class ProfieviewAPI {
//   String? processStatus;
//   String? processMessage;
//   String? memberId;
//   String? memberName;
//   String? memberPhone;
//   String? memberEmail;
//   String? address;
//   String? memberDoj;
//   String? memberDob;
//   String? memberImageUrl;

//   ProfieviewAPI(
//       {this.processStatus,
//       this.processMessage,
//       this.memberId,
//       this.memberName,
//       this.memberPhone,
//       this.memberEmail,
//       this.address,
//       this.memberDoj,
//       this.memberDob,
//       this.memberImageUrl});

//   ProfieviewAPI.fromJson(Map<String, dynamic> json) {
//     processStatus = json['process_status'];
//     processMessage = json['process_message'];
//     memberId = json['member_id'];
//     memberName = json['member_name'];
//     memberPhone = json['member_phone'];
//     memberEmail = json['member_email'];
//     address = json['address'];
//     memberDoj = json['member_doj'];
//     memberDob = json['member_dob'];
//     memberImageUrl = json['member_image_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['process_status'] = this.processStatus;
//     data['process_message'] = this.processMessage;
//     data['member_id'] = this.memberId;
//     data['member_name'] = this.memberName;
//     data['member_phone'] = this.memberPhone;
//     data['member_email'] = this.memberEmail;
//     data['address'] = this.address;
//     data['member_doj'] = this.memberDoj;
//     data['member_dob'] = this.memberDob;
//     data['member_image_url'] = this.memberImageUrl;
//     return data;
//   }

//   static Future<ProfieviewAPI> list({String? memberId}) async {
//     Uri url = Uri.parse(
//         "${Webservice.rootURL}${Webservice.profileView}?nickname=${Webservice.appNickname}");
//     final request = http.MultipartRequest('POST', url);

//     if (memberId != null) {
//       request.fields.addAll({
//         'erp_member_id': memberId,
//         'organization_id': Webservice.appNickname
//       });
//     } else {
//       String? localMemberID = await UserDataRepository.getMemberID();
//       if (localMemberID != null) {
//         request.fields.addAll({
//           'erp_member_id': localMemberID,
//           'organization_id': Webservice.appNickname
//         });
//       } else {
//         print('Access code not found');
//         // Handle the case where local member ID is not available
//       }
//     }
//     print(request.fields);
//     http.StreamedResponse response = await request.send();
//     String responseString = await response.stream.bytesToString();
//     print(responseString);
//     return ProfieviewAPI.fromJson(jsonDecode(responseString));
//   }
// }
class ProfieviewAPI {
  String? processStatus;
  String? processMessage;
  List<Data>? data;

  ProfieviewAPI({this.processStatus, this.processMessage, this.data});

  ProfieviewAPI.fromJson(Map<String, dynamic> json) {
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

  static Future<ProfieviewAPI> list({String? memberId}) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.profileView}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);

    if (memberId != null) {
      request.fields.addAll({
        'code_no': memberId,
        'id': memberId,
        'organization_id': Webservice.appNickname
      });
      print('mmmmmm${memberId}');
    } else {
      String? localMemberID = await UserDataRepository.getMemberID();
      if (localMemberID != null) {
        request.fields.addAll({
          'code_no': localMemberID,
          'id': localMemberID,
          'organization_id': Webservice.appNickname
        });
      } else {
        print('localMemberID not found');
        // Handle the case where local member ID is not available
      }
    }
    // print(request.fields);
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return ProfieviewAPI.fromJson(jsonDecode(responseString));
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
  String? officeAddress;
  String? maleImageURL;
  String? femaleImageURL;
  String? email;

  Data(
      {this.membershipCode,
      this.memberNameMale,
      this.memberMalePhone,
      this.memberMaleDob,
      this.memberMaleAge,
      this.memberNameFemale,
      this.memberFemalePhone,
      this.memberFemaleDob,
      this.officeAddress,
      this.maleImageURL,
      this.femaleImageURL,
      this.email,
      this.memberFemaleAge});

  Data.fromJson(Map<String, dynamic> json) {
    membershipCode = json['membership_code'];
    memberNameMale = json['member_name_male'].toString();
    memberMalePhone = json['member_male_phone'];
    memberMaleDob = json['member_male_dob'];
    memberMaleAge = json['member_male_age'];
    memberNameFemale = json['member_name_female'].toString();
    memberFemalePhone = json['member_female_phone'];
    memberFemaleDob = json['member_female_dob'];
    memberFemaleAge = json['member_female_age'];
    maleImageURL = json['member_image_url'];
    femaleImageURL = json['spouse_image_url'];
    officeAddress = json['office_address'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_code'] = membershipCode;
    data['member_name_male'] = memberNameMale;
    data['member_male_phone'] = memberMalePhone;
    data['member_male_dob'] = memberMaleDob;
    data['member_male_age'] = memberMaleAge;
    data['member_name_female'] = memberNameFemale;
    data['member_female_phone'] = memberFemalePhone;
    data['member_female_dob'] = memberFemaleDob;
    data['member_female_age'] = memberFemaleAge;
    data['member_image_url'] = maleImageURL;
    data['spouse_image_url'] = femaleImageURL;
    data['office_address'] = officeAddress;
    data['email'] = email;
    return data;
  }
}
