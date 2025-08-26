import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:multi_club_app/bases/webservice.dart';

class UpdateCheckResult {
  final bool updateRequired;
  final bool mandatory;
  final String? latestVersion;
  final String? message;

  const UpdateCheckResult({
    required this.updateRequired,
    required this.mandatory,
    this.latestVersion,
    this.message,
  });
}

bool _asBool(dynamic v) {
  if (v is bool) return v;
  final s = v?.toString().trim().toLowerCase();
  return s == '1' || s == 'true' || s == 'yes';
}

/// Compare "1.2.10" style versions component-wise.
/// >0 if a>b, 0 if equal, <0 if a<b
int _compareVersions(String a, String b) {
  final pa = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final pb = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final len = (pa.length > pb.length) ? pa.length : pb.length;
  while (pa.length < len) pa.add(0);
  while (pb.length < len) pb.add(0);
  for (var i = 0; i < len; i++) {
    if (pa[i] != pb[i]) return pa[i].compareTo(pb[i]);
  }
  return 0;
}

class AppVersionService {
  static Future<UpdateCheckResult> checkUpdate({
    required String deviceType, // "ANDROID" | "IOS"
    required String currentVersion, // e.g. "12.0.0"
    String memberId = 'guest',
  }) async {
    try {
      final resp = await http.post(
        Uri.parse('${Webservice.api_url}/show_app_version.php'),
        headers: {'Accept': 'application/json'},
        body: {
          'device_type': deviceType,
          'nickname': Webservice.appNickname,
          'member_id': memberId,
          'current_version':
              currentVersion, // optional on backend, helps logging
        },
      ).timeout(const Duration(seconds: 12));

      if (resp.statusCode != 200) {
        if (kDebugMode) debugPrint('Version check HTTP ${resp.statusCode}');
        return const UpdateCheckResult(updateRequired: false, mandatory: false);
      }

      final decoded = jsonDecode(resp.body);
      if (decoded is! Map<String, dynamic>) {
        if (kDebugMode) debugPrint('Unexpected JSON: ${resp.body}');
        return const UpdateCheckResult(updateRequired: false, mandatory: false);
      }

      // Your server sample:
      // {process_status: YES, process_message: Success., current_app_version: 11.0.0, mandatory: YES}
      final latest = decoded['current_app_version']?.toString();
      final message = decoded['process_message']?.toString();
      final mandatoryRaw = decoded['mandatory'];

      // Only require update if latest > current
      bool updateRequired = false;
      if (latest != null && latest.isNotEmpty) {
        updateRequired = _compareVersions(latest, currentVersion) > 0;
      }

      // Only respect mandatory when an update is actually required
      final mandatory = updateRequired ? _asBool(mandatoryRaw) : false;

      log('App Version Response: $decoded');
      return UpdateCheckResult(
        updateRequired: updateRequired,
        mandatory: mandatory,
        latestVersion: latest,
        message: message,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Version check error: $e');
        debugPrint(st.toString());
      }
      return const UpdateCheckResult(updateRequired: false, mandatory: false);
    }
  }
}
