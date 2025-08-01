import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class EventUpdateAPI {
  String? processStatus;
  String? processMessage;
  String? eventId;
  String? eventname;
  String? eventDatetime;

  EventUpdateAPI(
      {this.processStatus,
      this.processMessage,
      this.eventId,
      this.eventname,
      this.eventDatetime});

  EventUpdateAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    eventId = json['event_id'];
    eventname = json['eventname'];
    eventDatetime = json['event_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    data['event_id'] = this.eventId;
    data['eventname'] = this.eventname;
    data['event_datetime'] = this.eventDatetime;
    return data;
  }

  static Future<EventUpdateAPI> updation(
      String eventid, String attainding_status) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.update_event_attaing_status_v3}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    String? memberId = await UserDataRepository.getMemberID();
    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      // 'theaccesscode': "${accessCode}",
      'member_id': memberId ?? '',
      'event_id': eventid,
      'attainding_status': attainding_status
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    if (responseString.isNotEmpty) {
      return EventUpdateAPI.fromJson(jsonDecode(responseString));
    } else {
      // Return an empty/default EventUpdateAPI or handle as needed
      return EventUpdateAPI(
        processStatus: 'error',
        processMessage: 'Empty response from server',
      );
    }
  }
}
