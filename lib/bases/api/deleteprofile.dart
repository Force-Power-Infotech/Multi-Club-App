import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:multi_club_app/bases/webservice.dart';
import 'package:multi_club_app/bases/userdata_hive.dart';

class DeleteProfileAPI {
  String? processStatus;
  String? processMessage;

  DeleteProfileAPI({this.processStatus, this.processMessage});

  DeleteProfileAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    return data;
  }

  static Future<DeleteProfileAPI> directory() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.delete_the_member_details}");
    final request = http.MultipartRequest('POST', url);

    // Get phone number from UserDataRepository
    final userData = await UserDataRepository.getUserData();
    String? mobile = userData?.mobile;

    request.fields.addAll({
      'nickname': Webservice.appNickname,
      'username': mobile ?? '',
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print(responseString);
    return DeleteProfileAPI.fromJson(jsonDecode(responseString));
  }
}
