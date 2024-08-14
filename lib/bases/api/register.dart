import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class RegisterAPI {
  String? processStatus;
  String? processMessage;

  RegisterAPI({this.processStatus, this.processMessage});

  RegisterAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    return data;
  }

  static Future<RegisterAPI> directory(String email, String firstname,
      String middlename, String lastname, String phonenumber) async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.ws_user_register}");
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      'nickname': Webservice.appNickname,
      'first_name': firstname,
      'middle_name': middlename,
      'last_name': lastname,
      'phone': phonenumber,
      'email': email
    });
    print(request.fields);
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return RegisterAPI.fromJson(jsonDecode(responseString));
  }
}
