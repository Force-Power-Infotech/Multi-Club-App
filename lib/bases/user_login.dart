import 'dart:convert';

import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class UserLoginAPI {
  String? processStatus;
  String? processMessage;
  String? mlSts;

  UserLoginAPI({this.processStatus, this.processMessage, this.mlSts});

  UserLoginAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    mlSts = json['ml_sts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['ml_sts'] = mlSts;
    return data;
  }

  static Future<UserLoginAPI> login(String emailid) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.userLoginAPI}?nickname=${Webservice.appNickname}");
    final request = http.Request('POST', url);
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return UserLoginAPI.fromJson(jsonDecode(responseString));
  }
}
