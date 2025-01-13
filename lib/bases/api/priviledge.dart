import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriviledgeAPI {
  String? processStatus;
  String? processMessage;
  List<String>? nameArray;
  List<String>? imageUrlArray;
  List<String>? discountArray;
  List<String>? locationUrlArray;
  List<String>? descriptionArray;

  PriviledgeAPI(
      {this.processStatus,
      this.processMessage,
      this.nameArray,
      this.imageUrlArray,
      this.discountArray,
      this.locationUrlArray,
      this.descriptionArray});

  PriviledgeAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    nameArray = json['name_array'].cast<String>();
    imageUrlArray = json['image_url_array'].cast<String>();
    discountArray = json['discount_array'].cast<String>();
    locationUrlArray = json['location_url_array'].cast<String>();
    descriptionArray = json['description_array'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['name_array'] = nameArray;
    data['image_url_array'] = imageUrlArray;
    data['discount_array'] = discountArray;
    data['location_url_array'] = locationUrlArray;
    data['description_array'] = descriptionArray;
    return data;
  }

  static Future<PriviledgeAPI> details() async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.privilege}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code in priviledge not found');
    }
    request.fields.addAll({
      'organization_id': Webservice.appNickname,
      'theaccesscode': '$accessCode'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('in dobapi code ${responseString}');
    return PriviledgeAPI.fromJson(jsonDecode(responseString));
  }
}
