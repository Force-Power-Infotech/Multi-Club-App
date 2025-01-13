import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class RowingBookingAPI {
  String? processStatus;
  String? processMessage;
  int? bookingId;
  String? bkDateFormat;
  String? restaurentName;
  String? dressCodeFileLink;
  String? locationName;
  String? locationOnMap;

  RowingBookingAPI(
      {this.processStatus,
      this.processMessage,
      this.bookingId,
      this.bkDateFormat,
      this.restaurentName,
      this.dressCodeFileLink,
      this.locationName,
      this.locationOnMap});

  RowingBookingAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    bookingId = json['booking_id'];
    bkDateFormat = json['bk_date_format'];
    restaurentName = json['restaurent_name'];
    dressCodeFileLink = json['dress_code_file_link'];
    locationName = json['location_name'];
    locationOnMap = json['location_on_map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['booking_id'] = bookingId;
    data['bk_date_format'] = bkDateFormat;
    data['restaurent_name'] = restaurentName;
    data['dress_code_file_link'] = dressCodeFileLink;
    data['location_name'] = locationName;
    data['location_on_map'] = locationOnMap;
    return data;
  }

  static Future<RowingBookingAPI> booking(
      String bookingdate, String rowinglocation, String bookingtime) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.rowing_booking}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'booking_location': rowinglocation,
      'booking_full_date': bookingdate,
      'time_slot_twenty_four_hour_format': bookingtime,
      'number_of_people': '3',
      'facility_type_id': '5',
      'member_id': 'test001',
      'organization_id': Webservice.appNickname,
      'theaccesscode': '$accessCode'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print('in api code $responseString');
    return RowingBookingAPI.fromJson(jsonDecode(responseString));
  }
}
