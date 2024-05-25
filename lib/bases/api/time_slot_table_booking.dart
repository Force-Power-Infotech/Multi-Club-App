import 'dart:convert';

import 'package:multi_club_app/bases/userdata_hive.dart';
import 'package:multi_club_app/bases/webservice.dart';
import 'package:http/http.dart' as http;

class TimeSlotTableBooking {
  String? processStatus;
  String? processMessage;
  List<BookingDateListArr>? bookingDateListArr;
  List<TimingListArr>? timingListArr;
  List<TimingListDinnerArr>? timingListDinnerArr; // Define TimingListDinnerArr
  String? allowBooking;
  String? displayText;

  TimeSlotTableBooking({
    this.processStatus,
    this.processMessage,
    this.bookingDateListArr,
    this.timingListArr,
    this.timingListDinnerArr,
    this.allowBooking,
    this.displayText,
  });

  factory TimeSlotTableBooking.fromJson(Map<String, dynamic> json) {
    return TimeSlotTableBooking(
      processStatus: json['process_status'],
      processMessage: json['process_message'],
      bookingDateListArr: (json['booking_date_list_arr'] as List<dynamic>?)
          ?.map((e) => BookingDateListArr.fromJson(e))
          .toList(),
      timingListArr: (json['timing_list_arr'] as List<dynamic>?)
          ?.map((e) => TimingListArr.fromJson(e))
          .toList(),
      timingListDinnerArr: (json['timing_list_dinner_arr'] as List<dynamic>?)
          ?.map((e) => TimingListDinnerArr.fromJson(e))
          .toList(),
      allowBooking: json['allow_booking'],
      displayText: json['display_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_status'] = processStatus;
    data['process_message'] = processMessage;
    data['booking_date_list_arr'] =
        bookingDateListArr?.map((e) => e.toJson()).toList();
    data['timing_list_arr'] = timingListArr?.map((e) => e.toJson()).toList();
    data['timing_list_dinner_arr'] =
        timingListDinnerArr?.map((e) => e.toJson()).toList();
    data['allow_booking'] = allowBooking;
    data['display_text'] = displayText;
    return data;
  }

  static Future<TimeSlotTableBooking> booking(String bookingtime) async {
    Uri url = Uri.parse(
        "${Webservice.rootURL}${Webservice.time_slot_for_TB}?nickname=${Webservice.appNickname}");
    final request = http.MultipartRequest('POST', url);
    String? accessCode = await UserDataRepository.getAccessCode();
    if (accessCode != null) {
      print('Access Code: $accessCode');
    } else {
      print('Access code not found');
    }
    request.fields.addAll({
      'booking_location': '13',
      'member_id': 'test001',
      'selected_date': bookingtime,
      'organization_id': Webservice.appNickname,
      'theaccesscode': '${accessCode}'
    });

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    // print(responseString);
    return TimeSlotTableBooking.fromJson(jsonDecode(responseString));
  }
}

class TimingListDinnerArr {
  String? timeSlot;
  String? timeSlotTwentyFourHourFormat;
  String? amPmVal;
  String? status;
  String? facilityTypeId;
  String? hexCode;
  String? text;
  String? action;
  String? actionText;
  String? actionData;
  String? topBgHexCode;
  String? mealType;

  TimingListDinnerArr({
    this.timeSlot,
    this.timeSlotTwentyFourHourFormat,
    this.amPmVal,
    this.status,
    this.facilityTypeId,
    this.hexCode,
    this.text,
    this.action,
    this.actionText,
    this.actionData,
    this.topBgHexCode,
    this.mealType,
  });

  factory TimingListDinnerArr.fromJson(Map<String, dynamic> json) {
    return TimingListDinnerArr(
      timeSlot: json['time_slot'],
      timeSlotTwentyFourHourFormat: json['time_slot_twenty_four_hour_format'],
      amPmVal: json['am_pm_val'],
      status: json['status'],
      facilityTypeId: json['facility_type_id'],
      hexCode: json['hex_code'],
      text: json['text'],
      action: json['action'],
      actionText: json['action_text'],
      actionData: json['action_data'],
      topBgHexCode: json['top_bg_hex_code'],
      mealType: json['meal_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_slot'] = timeSlot;
    data['time_slot_twenty_four_hour_format'] = timeSlotTwentyFourHourFormat;
    data['am_pm_val'] = amPmVal;
    data['status'] = status;
    data['facility_type_id'] = facilityTypeId;
    data['hex_code'] = hexCode;
    data['text'] = text;
    data['action'] = action;
    data['action_text'] = actionText;
    data['action_data'] = actionData;
    data['top_bg_hex_code'] = topBgHexCode;
    data['meal_type'] = mealType;
    return data;
  }
}

class BookingDateListArr {
  String? fullDate;
  String? dateValue;
  String? dayName;
  String? status;
  String? hexCode;
  String? text;

  BookingDateListArr({
    this.fullDate,
    this.dateValue,
    this.dayName,
    this.status,
    this.hexCode,
    this.text,
  });

  factory BookingDateListArr.fromJson(Map<String, dynamic> json) {
    return BookingDateListArr(
      fullDate: json['full_date'],
      dateValue: json['date_value'],
      dayName: json['day_name'],
      status: json['status'],
      hexCode: json['hex_code'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_date'] = fullDate;
    data['date_value'] = dateValue;
    data['day_name'] = dayName;
    data['status'] = status;
    data['hex_code'] = hexCode;
    data['text'] = text;
    return data;
  }
}

class TimingListArr {
  String? timeSlot;
  String? timeSlotTwentyFourHourFormat;
  String? amPmVal;
  String? status;
  String? facilityTypeId;
  String? hexCode;
  String? text;
  String? action;
  String? actionText;
  String? actionData;
  String? topBgHexCode;
  String? mealType;

  TimingListArr({
    this.timeSlot,
    this.timeSlotTwentyFourHourFormat,
    this.amPmVal,
    this.status,
    this.facilityTypeId,
    this.hexCode,
    this.text,
    this.action,
    this.actionText,
    this.actionData,
    this.topBgHexCode,
    this.mealType,
  });

  factory TimingListArr.fromJson(Map<String, dynamic> json) {
    return TimingListArr(
      timeSlot: json['time_slot'],
      timeSlotTwentyFourHourFormat: json['time_slot_twenty_four_hour_format'],
      amPmVal: json['am_pm_val'],
      status: json['status'],
      facilityTypeId: json['facility_type_id'],
      hexCode: json['hex_code'],
      text: json['text'],
      action: json['action'],
      actionText: json['action_text'],
      actionData: json['action_data'],
      topBgHexCode: json['top_bg_hex_code'],
      mealType: json['meal_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_slot'] = timeSlot;
    data['time_slot_twenty_four_hour_format'] = timeSlotTwentyFourHourFormat;
    data['am_pm_val'] = amPmVal;
    data['status'] = status;
    data['facility_type_id'] = facilityTypeId;
    data['hex_code'] = hexCode;
    data['text'] = text;
    data['action'] = action;
    data['action_text'] = actionText;
    data['action_data'] = actionData;
    data['top_bg_hex_code'] = topBgHexCode;
    data['meal_type'] = mealType;
    return data;
  }
}
