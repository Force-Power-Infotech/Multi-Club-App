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

  static Future<RegisterAPI> directory(
      String email, String memberName, String phone,
      {required String panNumber,
      required String pincode,
      required String chapter,
      required String area,
      required String city,
      required String address}) async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.ws_user_register}");
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      'nickname': Webservice.appNickname,
      'member_name': memberName,
      'phone': phone,
      'email': email,
      'city': city,
      'pincode': pincode,
      'area': area,
      'chapter': chapter,
      'address': address,
      'pan_number': panNumber
    });
    print(request.fields);
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return RegisterAPI.fromJson(jsonDecode(responseString));
  }
}
