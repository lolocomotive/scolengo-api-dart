import 'package:scolengo_api/src/models/globals.dart';

class AbsenceReason extends BaseResponse {
  String code;
  String longLabel;
  List<String> supportedAbsenceTypes;

  AbsenceReason({
    required this.code,
    required this.longLabel,
    required this.supportedAbsenceTypes,
    required super.id,
    required super.type,
  });

  static AbsenceReason fromJson(Map<String, dynamic> json) {
    return AbsenceReason(
      id: json['id'],
      type: json['type'],
      code: json['code'],
      longLabel: json['longLabel'],
      supportedAbsenceTypes: json['supportedAbsenceTypes'] as List<String>,
    );
  }
}
