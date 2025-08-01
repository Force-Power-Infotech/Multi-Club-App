// ignore_for_file: prefer_collection_literals

import 'dart:io';
import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEditAPI {
  String? processStatus;
  String? processMessage;

  ProfileEditAPI({this.processStatus, this.processMessage});

  ProfileEditAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    return data;
  }

  static Future<ProfileEditAPI> details(
    String email,
    String address,
    File? imageFile, {
    String? facebook,
    String? twitter,
    String? linkedin,
    String? instagram,
    String? spouseEmail,
    String? spouseFacebook,
    String? spouseTwitter,
    String? spouseLinkedin,
    String? spouseInstagram,
    bool showMale = true,
  }) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.profileEdit}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? memberID = await UserDataRepository.getMemberID();
    if (memberID != null) {
      print('Member ID: $memberID');
    } else {
      print('Member ID not found');
    }
    // Add base fields
    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      'member_id': '$memberID',
      'email': email,
      'address': address,
    });
    // Add social fields
    if (showMale) {
      if (facebook != null) request.fields['facebook'] = facebook;
      if (twitter != null) request.fields['twitter'] = twitter;
      if (linkedin != null) request.fields['linkedin'] = linkedin;
      if (instagram != null) request.fields['instagram'] = instagram;
    } else {
      if (spouseEmail != null) request.fields['spouse_email'] = spouseEmail;
      if (spouseFacebook != null)
        request.fields['spouse_facebook'] = spouseFacebook;
      if (spouseTwitter != null)
        request.fields['spouse_twitter'] = spouseTwitter;
      if (spouseLinkedin != null)
        request.fields['spouse_linkedin'] = spouseLinkedin;
      if (spouseInstagram != null)
        request.fields['spouse_instagram'] = spouseInstagram;
    }
    print('Request fields:');
    request.fields.forEach((k, v) => print('$k: $v'));
    print('Image path: ${imageFile?.path}');

    // Add the image file to the request if it exists
    if (imageFile != null && imageFile.existsSync()) {
      print('Image File: ${imageFile.path}');
      request.files.add(await http.MultipartFile.fromBytes(
        'member_image',
        await imageFile.readAsBytes(),
        filename: imageFile.path.split('/').last,
      ));
    } else {
      print('Image File: ${imageFile}');
    }

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print('API Raw Response: $responseString');
    return ProfileEditAPI.fromJson(jsonDecode(responseString));
  }
}
