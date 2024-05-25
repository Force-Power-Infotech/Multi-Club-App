import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventAPI {
  String? processStatus;
  String? processMessage;
  List<EventDetails>? eventDetails;

  EventAPI({this.processStatus, this.processMessage, this.eventDetails});

  EventAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['event_details'] != null) {
      eventDetails = <EventDetails>[];
      json['event_details'].forEach((v) {
        eventDetails?.add(EventDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    if (this.eventDetails != null) {
      data['event_details'] =
          this.eventDetails?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<EventAPI> details() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.event_details}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      // 'theaccesscode': "${accessCode}",
      'theaccesscode': "BmP1",
      'the_event_type': 'SPORTS',
      'filter_type': 'All\tBody'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('in api code ${responseString}');
    return EventAPI.fromJson(jsonDecode(responseString));
  }
}

class EventDetails {
  String? eventid;
  String? eventname;
  String? description;
  String? eventmobile;
  String? eventemail;
  String? eventstartdate;
  String? eventstarttime;
  String? eventimage;
  String? venue;
  String? date;
  String? time;
  String? dateForHeading;
  String? guest;
  String? entryFee;
  String? locationId;
  String? locationName;
  String? locationOnMap;
  String? link;
  String? eventType;

  EventDetails(
      {this.eventid,
      this.eventname,
      this.description,
      this.eventmobile,
      this.eventemail,
      this.eventstartdate,
      this.eventstarttime,
      this.eventimage,
      this.venue,
      this.date,
      this.time,
      this.dateForHeading,
      this.guest,
      this.entryFee,
      this.locationId,
      this.locationName,
      this.locationOnMap,
      this.link,
      this.eventType});

  EventDetails.fromJson(Map<String, dynamic> json) {
    eventid = json['eventid'];
    eventname = json['eventname'];
    description = json['description'];
    eventmobile = json['eventmobile'];
    eventemail = json['eventemail'];
    eventstartdate = json['eventstartdate'];
    eventstarttime = json['eventstarttime'];
    eventimage = json['eventimage'];
    venue = json['venue'];
    date = json['date'];
    time = json['time'];
    dateForHeading = json['date_for_heading'];
    guest = json['guest'];
    entryFee = json['entry_fee'];
    locationId = json['location_id'];
    locationName = json['location_name'];
    locationOnMap = json['location_on_map'];
    link = json['link'];
    eventType = json['event_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventid'] = this.eventid;
    data['eventname'] = this.eventname;
    data['description'] = this.description;
    data['eventmobile'] = this.eventmobile;
    data['eventemail'] = this.eventemail;
    data['eventstartdate'] = this.eventstartdate;
    data['eventstarttime'] = this.eventstarttime;
    data['eventimage'] = this.eventimage;
    data['venue'] = this.venue;
    data['date'] = this.date;
    data['time'] = this.time;
    data['date_for_heading'] = this.dateForHeading;
    data['guest'] = this.guest;
    data['entry_fee'] = this.entryFee;
    data['location_id'] = this.locationId;
    data['location_name'] = this.locationName;
    data['location_on_map'] = this.locationOnMap;
    data['link'] = this.link;
    data['event_type'] = this.eventType;
    return data;
  }
}
