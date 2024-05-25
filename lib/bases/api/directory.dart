import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class DirectoryAPI {
  String? processStatus;
  String? processMessage;
  List<String>? memberNameArray;
  List<String>? memberPhoneArray;
  List<String>? memberIdArray;
  List<String>? memberImageUrlArray;

  DirectoryAPI(
      {this.processStatus,
      this.processMessage,
      this.memberNameArray,
      this.memberPhoneArray,
      this.memberIdArray,
      this.memberImageUrlArray});

  DirectoryAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    memberNameArray = json['member_name_array'].cast<String>();
    memberPhoneArray = json['member_phone_array'].cast<String>();
    memberIdArray = json['member_id_array'].cast<String>();
    memberImageUrlArray = json['member_image_url_array'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    data['member_name_array'] = this.memberNameArray;
    data['member_phone_array'] = this.memberPhoneArray;
    data['member_id_array'] = this.memberIdArray;
    data['member_image_url_array'] = this.memberImageUrlArray;
    return data;
  }

  static Future<DirectoryAPI> directory(
      String eventid, String attainding_status) async {
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

  static fetchContacts(String s, String t) {}
}
