import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class SponsorAPI {
  String? processStatus;
  String? processMessage;
  List<String>? hyperlinks;
  List<String>? images;

  SponsorAPI(
      {this.processStatus, this.processMessage, this.hyperlinks, this.images});

  SponsorAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    hyperlinks = json['hyperlinks'].cast<String>();
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    data['hyperlinks'] = this.hyperlinks;
    data['images'] = this.images;
    return data;
  }

  static Future<SponsorAPI> details() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.sponsor}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      'theaccesscode': '${accessCode}',
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // log('SponsorAPI Response: $responseString');
    return SponsorAPI.fromJson(jsonDecode(responseString));
  }
}
