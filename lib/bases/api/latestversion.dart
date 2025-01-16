import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestVersionAPI {
  String? processStatus;
  String? processMessage;
  List<AppVersionData>? appVersionData;

  LatestVersionAPI(
      {this.processStatus, this.processMessage, this.appVersionData});

  LatestVersionAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['app_version_data'] != null) {
      appVersionData = <AppVersionData>[];
      json['app_version_data'].forEach((v) {
        appVersionData!.add(AppVersionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    if (this.appVersionData != null) {
      data['app_version_data'] = this.appVersionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<LatestVersionAPI> details() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.mms_app_latest_version}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);


    request.fields.addAll({
      'organization_id': Webservice.appNickname,
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print('in event api code $responseString');
    return LatestVersionAPI.fromJson(jsonDecode(responseString));
  }
}

class AppVersionData {
  String? deviceType;
  String? appVersion;
  String? playStoreLink;

  AppVersionData({this.deviceType, this.appVersion, this.playStoreLink});

  AppVersionData.fromJson(Map<String, dynamic> json) {
    deviceType = json['device_type'];
    appVersion = json['app_version'];
    playStoreLink = json['play_store_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_type'] = this.deviceType;
    data['app_version'] = this.appVersion;
    data['play_store_link'] = this.playStoreLink;
    return data;
  }
}
