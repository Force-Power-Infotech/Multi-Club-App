import 'dart:convert';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class CityChapterNameAPI {
  String? processStatus;
  String? processMessage;
  List<City>? city;
  List<Chapter>? chapter;
  List<Country>? country;

  CityChapterNameAPI(
      {this.processStatus, this.processMessage, this.city, this.chapter});

  CityChapterNameAPI.fromJson(Map<String, dynamic> json) {
    processStatus = json['process_status'];
    processMessage = json['process_message'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city!.add(City.fromJson(v));
      });
    }
    if (json['chapter'] != null) {
      chapter = <Chapter>[];
      json['chapter'].forEach((v) {
        chapter!.add(Chapter.fromJson(v));
      });
    }
    if (json['country'] != null) {
      country = <Country>[];
      json['country'].forEach((v) {
        country!.add(Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    if (city != null) {
      data['city'] = city!.map((v) => v.toJson()).toList();
    }
    if (chapter != null) {
      data['chapter'] = chapter!.map((v) => v.toJson()).toList();
    }
    if (country != null) {
      data['country'] = country!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<CityChapterNameAPI> citychapter() async {
    Uri url =
        Uri.parse("${Webservice.rootURL}${Webservice.user_regd_city_api}");
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'nickname': Webservice.appNickname,
    });
    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    print(responseString);
    return CityChapterNameAPI.fromJson(jsonDecode(responseString));
  }
}

class City {
  String? city;

  City({this.city});

  City.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    return data;
  }
}

class Chapter {
  String? chapter;

  Chapter({this.chapter});

  Chapter.fromJson(Map<String, dynamic> json) {
    chapter = json['chapter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chapter'] = chapter;
    return data;
  }
}

class Country {
  String? country;

  Country({this.country});

  Country.fromJson(Map<String, dynamic> json) {
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    return data;
  }
}
