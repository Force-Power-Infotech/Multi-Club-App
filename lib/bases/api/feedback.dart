import 'dart:convert';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class FeedbackApi {
  String? processStatus;
  String? processMessage;

  FeedbackApi({this.processStatus, this.processMessage});

  FeedbackApi.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['process_status'] = this.processStatus;
    data['process_message'] = this.processMessage;
    return data;
  }

  static Future<FeedbackApi> directory(
      String rating, String feedbacktext) async {
    Uri url = Uri.parse("${Webservice.rootURL}${Webservice.feedback}");
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'nickname': Webservice.appNickname,
      'rating': rating,
      'feedback_text': feedbacktext
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return FeedbackApi.fromJson(jsonDecode(responseString));
  }
}
