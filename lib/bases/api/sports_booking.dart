import 'dart:convert';

import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class SportsBookingAPI {
  String? processStatus;
  String? processMessage;
  int? bookingId;
  String? bkDateFormat;
  String? bookingShowText;
  String? releaseOptionStatus;
  String? isShowAutoDeleteOption;
  String? waitlistInfoText;

  SportsBookingAPI(
      {this.processStatus,
      this.processMessage,
      this.bookingId,
      this.bkDateFormat,
      this.bookingShowText,
      this.releaseOptionStatus,
      this.isShowAutoDeleteOption,
      this.waitlistInfoText});

  SportsBookingAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    bookingId = json['booking_id'];
    bkDateFormat = json['bk_date_format'];
    bookingShowText = json['booking_show_text'];
    releaseOptionStatus = json['release_option_status'];
    isShowAutoDeleteOption = json['is_show_auto_delete_option'];
    waitlistInfoText = json['waitlist_info_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    data['booking_id'] = this.bookingId;
    data['bk_date_format'] = this.bkDateFormat;
    data['booking_show_text'] = this.bookingShowText;
    data['release_option_status'] = this.releaseOptionStatus;
    data['is_show_auto_delete_option'] = this.isShowAutoDeleteOption;
    data['waitlist_info_text'] = this.waitlistInfoText;
    return data;
  }

  static Future<SportsBookingAPI> booking() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.sport_booking}?nickname=${Webservice.appNickname}");
    // final request = http.Request('POST', url);
    // request.body = json.encode({
    //   "organization_id": "CSC",
    //   "theaccesscode": "BmP1",
    //   "booking_full_date": "2024-04-23",
    //   "time_slot_twenty_four_hour_format": "19:30",
    //   "primary_member_id": "test001",
    //   "selected_member_id2": "gerh",
    //   "selected_member_id3": "erhe",
    //   "selected_member_id4": "frhe",
    //   "selected_member_id5": "erb",
    //   "release_choice": "ber",
    //   "member_id": "test001",
    //   "sport_option_id": "ber4"
    // });
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://club.forcempower.com/make_sports_booking_v1.php?nickname=forcempower'));
    request.body = json.encode({
      "organization_id": "CSC",
      "theaccesscode": "BmP1",
      "booking_full_date": "2024-04-29",
      "time_slot_twenty_four_hour_format": "19:30",
      "primary_member_id": "test001",
      "selected_member_id2": "gerh",
      "selected_member_id3": "erhe",
      "selected_member_id4": "frhe",
      "selected_member_id5": "erb",
      "release_choice": "ber",
      "member_id": "test001",
      "sport_option_id": "ber4"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request}');
    print(request.body);

    // http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return SportsBookingAPI.fromJson(jsonDecode(responseString));
  }
}
