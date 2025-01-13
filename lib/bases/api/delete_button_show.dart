import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class DeleteButtonShowApi {
  String? status;
  String? action;

  DeleteButtonShowApi({this.status, this.action});

  DeleteButtonShowApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['action'] = action;
    return data;
  }

  static Future<DeleteButtonShowApi> directory() async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.ws_disable_delete}");
    final request = http.MultipartRequest('POST', url);

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return DeleteButtonShowApi.fromJson(jsonDecode(responseString));
  }
}
