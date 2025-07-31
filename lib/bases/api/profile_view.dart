import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

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
  String? email;
  String? officeAddress;
  String? memberImageUrl;
  Null? spouseImageUrl;
  Null? spouseEmail;
  String? facebook;
  String? twitter;
  String? linkedin;
  String? instagram;
  String? spouseFacebook;
  String? spouseTwitter;
  String? spouseInstagram;
  String? spouseLinkedin;

  Data(
      {this.membershipCode,
      this.memberNameMale,
      this.memberMalePhone,
      this.memberMaleDob,
      this.memberMaleAge,
      this.memberNameFemale,
      this.memberFemalePhone,
      this.memberFemaleDob,
      this.memberFemaleAge,
      this.email,
      this.officeAddress,
      this.memberImageUrl,
      this.spouseImageUrl,
      this.spouseEmail,
      this.facebook,
      this.twitter,
      this.linkedin,
      this.instagram,
      this.spouseFacebook,
      this.spouseTwitter,
      this.spouseInstagram,
      this.spouseLinkedin});

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
    email = json['email'];
    officeAddress = json['office_address'];
    memberImageUrl = json['member_image_url'];
    spouseImageUrl = json['spouse_image_url'];
    spouseEmail = json['spouse_email'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    spouseFacebook = json['spouse_facebook'];
    spouseTwitter = json['spouse_twitter'];
    spouseInstagram = json['spouse_instagram'];
    spouseLinkedin = json['spouse_linkedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['membership_code'] = this.membershipCode;
    data['member_name_male'] = this.memberNameMale;
    data['member_male_phone'] = this.memberMalePhone;
    data['member_male_dob'] = this.memberMaleDob;
    data['member_male_age'] = this.memberMaleAge;
    data['member_name_female'] = this.memberNameFemale;
    data['member_female_phone'] = this.memberFemalePhone;
    data['member_female_dob'] = this.memberFemaleDob;
    data['member_female_age'] = this.memberFemaleAge;
    data['email'] = this.email;
    data['office_address'] = this.officeAddress;
    data['member_image_url'] = this.memberImageUrl;
    data['spouse_image_url'] = this.spouseImageUrl;
    data['spouse_email'] = this.spouseEmail;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['linkedin'] = this.linkedin;
    data['instagram'] = this.instagram;
    data['spouse_facebook'] = this.spouseFacebook;
    data['spouse_twitter'] = this.spouseTwitter;
    data['spouse_instagram'] = this.spouseInstagram;
    data['spouse_linkedin'] = this.spouseLinkedin;
    return data;
  }
}
