import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class ShowNotifications {
  String? processStatus;
  String? processMessage;
  List<NotificationData>? notificationData;

  ShowNotifications(
      {this.processStatus, this.processMessage, this.notificationData});

  ShowNotifications.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['notification_data'] != null) {
      notificationData = <NotificationData>[];
      json['notification_data'].forEach((v) {
        notificationData?.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    if (notificationData != null) {
      data['notification_data'] =
          notificationData?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<ShowNotifications> getnotification() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.show_notification}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'organization_id': 'CSC',
      'theaccesscode': '${accessCode}',
      'member_id': 'test001'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    return ShowNotifications.fromJson(jsonDecode(responseString));
  }
}

class NotificationData {
  String? id;
  String? category;
  String? title;
  String? description;
  String? dateTime;
  String? notyType;
  String? notyTypeCheck;

  NotificationData(
      {this.id,
      this.category,
      this.title,
      this.description,
      this.dateTime,
      this.notyType,
      this.notyTypeCheck});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    description = json['description'];
    dateTime = json['date_time'];
    notyType = json['noty_type'];
    notyTypeCheck = json['noty_type_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['title'] = title;
    data['description'] = description;
    data['date_time'] = dateTime;
    data['noty_type'] = notyType;
    data['noty_type_check'] = notyTypeCheck;
    return data;
  }
}
