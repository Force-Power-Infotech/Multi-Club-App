import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class LocationRowingBookingAPI {
  String? processStatus;
  String? processMessage;
  List<LocationData>? locationData;

  LocationRowingBookingAPI(
      {this.processStatus, this.processMessage, this.locationData});

  LocationRowingBookingAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['location_data'] != null) {
      locationData = <LocationData>[];
      json['location_data'].forEach((v) {
        locationData?.add(LocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    if (this.locationData != null) {
      data['location_data'] =
          this.locationData?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<LocationRowingBookingAPI> booking() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.location_rowing_booking}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'theaccesscode': '${accessCode}',
      'organization_id': 'CSC',
      'page_no': '39'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('locaation from here ${responseString}');
    return LocationRowingBookingAPI.fromJson(jsonDecode(responseString));
  }

// Method to fetch location data and return LocationData objects
  static Future<List<LocationData>> getLocationData() async {
    LocationRowingBookingAPI fetchedData =
        await LocationRowingBookingAPI.booking();
    List<LocationData> locationData = fetchedData.locationData ?? [];
    return locationData;
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
