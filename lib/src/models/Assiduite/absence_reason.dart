import 'package:scolengo_api_dart/src/models/globals.dart';

class AbsenceReason extends BaseResponse {
  String code;
  String longLabel;

  AbsenceReason({
    required this.code,
    required this.longLabel,
    required super.id,
  });

  static AbsenceReason fromJson(Map<String, dynamic> json) {
    return AbsenceReason(
      id: json['id'],
      code: json['code'],
      longLabel: json['longLabel'],
    );
  }
}
