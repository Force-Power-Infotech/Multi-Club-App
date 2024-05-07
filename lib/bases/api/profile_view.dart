import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class ProfieviewAPI {
  String? processStatus;
  String? processMessage;
  String? memberId;
  String? memberName;
  String? memberPhone;
  String? memberEmail;
  String? address;
  String? memberDoj;
  String? memberDob;
  String? memberImageUrl;

  ProfieviewAPI(
      {this.processStatus,
      this.processMessage,
      this.memberId,
      this.memberName,
      this.memberPhone,
      this.memberEmail,
      this.address,
      this.memberDoj,
      this.memberDob,
      this.memberImageUrl});

  ProfieviewAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    memberId = json['member_id'];
    memberName = json['member_name'];
    memberPhone = json['member_phone'];
    memberEmail = json['member_email'];
    address = json['address'];
    memberDoj = json['member_doj'];
    memberDob = json['member_dob'];
    memberImageUrl = json['member_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    data['member_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['member_phone'] = this.memberPhone;
    data['member_email'] = this.memberEmail;
    data['address'] = this.address;
    data['member_doj'] = this.memberDoj;
    data['member_dob'] = this.memberDob;
    data['member_image_url'] = this.memberImageUrl;
    return data;
  }

  static Future<ProfieviewAPI> list({String? memberId}) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.profileView}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);

    if (memberId != null) {
      request.fields
          .addAll({'erp_member_id': memberId, 'organization_id': 'CSC'});
    } else {
      String? localMemberID = await UserDataRepository.getMemberID();
      if (localMemberID != null) {
        request.fields
            .addAll({'erp_member_id': localMemberID, 'organization_id': 'CSC'});
      } else {
        print('Access code not found');
        // Handle the case where local member ID is not available
      }
    }
    print(request.fields);
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return ProfieviewAPI.fromJson(jsonDecode(responseString));
  }
}
