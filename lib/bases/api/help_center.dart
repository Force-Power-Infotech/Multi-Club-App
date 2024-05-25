import 'dart:convert';

import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class HelpCenterAPI {
  String? processStatus;
  String? processMessage;
  List<HelpList>? helpList;
  String? clubName;
  String? clubAddress;
  String? dresscodeType;
  String? dresscodeData;
  String? locationData;

  HelpCenterAPI(
      {this.processStatus,
      this.processMessage,
      this.helpList,
      this.clubName,
      this.clubAddress,
      this.dresscodeType,
      this.dresscodeData,
      this.locationData});

  HelpCenterAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['help_list'] != null) {
      helpList = <HelpList>[];
      json['help_list'].forEach((v) {
        helpList?.add(HelpList.fromJson(v));
      });
    }
    clubName = json['club_name'];
    clubAddress = json['club_address'];
    dresscodeType = json['dresscode_type'];
    dresscodeData = json['dresscode_data'];
    locationData = json['location_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    if (helpList != null) {
      data['help_list'] = helpList?.map((v) => v.toJson()).toList();
    }
    data['club_name'] = clubName;
    data['club_address'] = clubAddress;
    data['dresscode_type'] = dresscodeType;
    data['dresscode_data'] = dresscodeData;
    data['location_data'] = locationData;
    return data;
  }

  static Future<HelpCenterAPI> details(
      String bookingdate, String rowinglocation, String bookingtime) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.helpcenter}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({'organization_id': Webservice.appNickname});

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('in api code ${responseString}');
    return HelpCenterAPI.fromJson(jsonDecode(responseString));
  }
}

class HelpList {
  String? id;
  String? name;
  String? description;
  String? email;
  String? phone;

  HelpList({this.id, this.name, this.description, this.email, this.phone});

  HelpList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
