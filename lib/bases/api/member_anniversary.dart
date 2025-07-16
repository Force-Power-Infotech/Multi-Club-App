import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_club_app/bases/webservice.dart';

class MemberAnniversary {
  String? memberId;
  String? memberName;
  String? membeAnniversaryDate;
  String? memberContact;
  String? memberNameFemale;
  String? memberFemalePhone;
  String? imageUrl;

  MemberAnniversary(
      {this.memberId,
      this.memberName,
      this.membeAnniversaryDate,
      this.memberContact,
      this.memberNameFemale,
      this.memberFemalePhone,
      this.imageUrl});

  MemberAnniversary.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    memberName = json['member_name'];
    membeAnniversaryDate = json['membe_anniversary_date'];
    memberContact = json['member_contact'];
    memberNameFemale = json['member_name_female'];
    memberFemalePhone = json['member_female_phone'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['member_name'] = this.memberName;
    data['membe_anniversary_date'] = this.membeAnniversaryDate;
    data['member_contact'] = this.memberContact;
    data['member_name_female'] = this.memberNameFemale;
    data['member_female_phone'] = this.memberFemalePhone;
    data['image_url'] = this.imageUrl;
    return data;
  }

  static Future<List<MemberAnniversary>> fetchAnniversaryData() async {
  try {
    Uri url = Uri.parse(
        "http://club.forcempower.com/member_anniversary_list.php?nickname=madhuban");
    final request = http.MultipartRequest('POST', url);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now()); // current date

    request.fields.addAll({
      'anniversary': today,
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    log('Anniversary response received: $responseString');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(responseString);

      if (decoded is List) {
        return decoded
            .map((json) => MemberAnniversary.fromJson(json))
            .toList();
      } else if (decoded is Map<String, dynamic>) {
        return [MemberAnniversary.fromJson(decoded)];
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load');
    }
  } catch (e) {
    log('Error fetching anniversary data: $e');
    throw Exception('Failed to load anniversary data');
  }
}
}
