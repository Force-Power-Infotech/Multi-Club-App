import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class LocationTableBooking {
  String? processStatus;
  String? processMessage;
  List<LocationData>? locationData;

  LocationTableBooking({
    this.processStatus,
    this.processMessage,
    this.locationData,
  });

  LocationTableBooking.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['location_data'] != null) {
      locationData = <LocationData>[];
      json['location_data'].forEach((v) {
        locationData!.add(LocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    if (locationData != null) {
      data['location_data'] = locationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<LocationTableBooking> booking() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.locatioForTableBooking}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);

    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'page_no': '1',
      'organization_id': 'CSC',
      'theaccesscode': '${accessCode}'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return LocationTableBooking.fromJson(jsonDecode(responseString));
  }
}

class LocationData {
  String? locKey;
  String? locVal;

  LocationData({this.locKey, this.locVal});

  LocationData.fromJson(Map<String, dynamic> json) {
    locKey = json['loc_key'];
    locVal = json['loc_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loc_key'] = locKey;
    data['loc_val'] = locVal;
    return data;
  }
}
