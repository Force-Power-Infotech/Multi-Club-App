import 'dart:convert';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class GalleryAPI {
  String? processStatus;
  String? processMessage;
  List<GalleryData>? galleryData;

  GalleryAPI({this.processStatus, this.processMessage, this.galleryData});

  GalleryAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['gallery_data'] != null) {
      galleryData = <GalleryData>[];
      json['gallery_data'].forEach((v) {
        galleryData?.add(GalleryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    if (galleryData != null) {
      data['gallery_data'] = galleryData?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GalleryData {
  String? date;
  String? imageUrl;
  String? event_name;

  GalleryData({this.date, this.imageUrl, this.event_name});

  GalleryData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    imageUrl = json['image_url'];
    event_name = json['event_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['image_url'] = imageUrl;
    data['event_name'] = event_name;
    return data;
  }

  static Future<GalleryAPI> updation(String date) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.gallery}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      // 'date': date,
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print(responseString);
    return GalleryAPI.fromJson(jsonDecode(responseString));
  }
}
