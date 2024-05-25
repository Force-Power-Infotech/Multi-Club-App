import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class TableBookingAPI {
  String? processStatus;
  String? processMessage;
  int? bookingId;
  String? bkDateFormat;
  String? restaurentName;
  String? dressCodeFileLink;
  String? locationName;
  String? locationOnMap;

  TableBookingAPI(
      {this.processStatus,
      this.processMessage,
      this.bookingId,
      this.bkDateFormat,
      this.restaurentName,
      this.dressCodeFileLink,
      this.locationName,
      this.locationOnMap});

  TableBookingAPI.fromJson(Map<String, dynamic> json) {
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

  static Future<TableBookingAPI> booking(String bookinglocation,
      String bookingdate, String mealtype, String timeslot) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.table_booking}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'booking_location': bookinglocation,
      'booking_full_date': bookingdate,
      'time_slot_twenty_four_hour_format': timeslot,
      'tsd_id': '19',
      'meal_type': mealtype,
      'facility_type_id': '3',
      'member_id': 'test001',
      'organization_id': Webservice.appNickname,
      'theaccesscode': '${accessCode}'
    });
    print('in the api setting the getting location${bookinglocation}');

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return TableBookingAPI.fromJson(jsonDecode(responseString));
  }
}
