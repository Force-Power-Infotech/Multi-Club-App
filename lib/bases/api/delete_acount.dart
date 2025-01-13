import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class DeleteAccountApi {
  String? status;
  String? message;

  DeleteAccountApi({this.status, this.message});

  DeleteAccountApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }

  static Future<DeleteAccountApi> deleteaccount(
      String userid, String phonenumber) async {
    Uri url =
        Uri.parse("${Webservice.rootURL}${Webservice.ws_active_inactive}");
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'id': userid,
      'nickname': Webservice.appNickname,
      'phone': phonenumber
    });
    print(request.fields);
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return DeleteAccountApi.fromJson(jsonDecode(responseString));
  }
}
