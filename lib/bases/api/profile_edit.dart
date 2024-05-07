import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEditAPI {
  String? processStatus;
  String? processMessage;

  ProfileEditAPI({this.processStatus, this.processMessage});

  ProfileEditAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    return data;
  }

  static Future<ProfileEditAPI> details(String? email, String? address) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.profileEdit}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? memberID = await UserDataRepository.getMemberID();
    if (memberID != null) {
      print('Member ID: $memberID');
    } else {
      print('Member ID not found');
    }
    request.fields.addAll({
      'organization_id': 'CSC',
      'member_id': '${memberID}',
      'email': "${email}",
      'address': '${address}'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print('in dobapi code ${responseString}');
    return ProfileEditAPI.fromJson(jsonDecode(responseString));
  }
}
