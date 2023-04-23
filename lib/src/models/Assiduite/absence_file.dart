import 'package:scolengo_api_dart/src/models/Assiduite/absence_reason.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class AbsenceFile extends BaseResponse {
  AbsenceFileState currentState;
  AbsenceFile({required super.id, required this.currentState});

  static AbsenceFile fromJson(Map<String, dynamic> json) {
    return AbsenceFile(
      id: json['id'],
      currentState: AbsenceFileState.fromJson(json['currentState']),
    );
  }
}

class AbsenceFileState extends BaseResponse {
  String creationDateTime;
  String absenceStartDateTime;
  String absenceEndDateTime;
  String absenceType;
  String absenceFileStatus;
  AbsenceReason absenceReason;

  AbsenceFileState({
    required this.creationDateTime,
    required this.absenceStartDateTime,
    required this.absenceEndDateTime,
    required this.absenceType,
    required this.absenceFileStatus,
    required this.absenceReason,
    required super.id,
  });

  static AbsenceFileState fromJson(Map<String, dynamic> json) {
    return AbsenceFileState(
      id: json['id'],
      creationDateTime: json['creationDateTime'],
      absenceStartDateTime: json['absenceStartDateTime'],
      absenceEndDateTime: json['absenceEndDateTime'],
      absenceType: json['absenceType'],
      absenceFileStatus: json['absenceFileStatus'],
      absenceReason: AbsenceReason.fromJson(json['absenceReason']),
    );
  }
}
