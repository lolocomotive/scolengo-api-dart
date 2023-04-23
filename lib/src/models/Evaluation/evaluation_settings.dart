import 'package:scolengo_api_dart/src/models/globals.dart';

class EvaluationSettings extends BaseResponse {
  bool periodicReportsEnabled;
  bool skillsEnabled;
  bool evaluationsDetailsAvailable;
  List<Period> periods;
  EvaluationSettings({
    required this.periodicReportsEnabled,
    required this.skillsEnabled,
    required this.evaluationsDetailsAvailable,
    required super.id,
    required this.periods,
  });

  static EvaluationSettings fromJson(Map<String, dynamic> json) {
    return EvaluationSettings(
      id: json['id'],
      periodicReportsEnabled: json['periodicReportsEnabled'],
      skillsEnabled: json['skillsEnabled'],
      evaluationsDetailsAvailable: json['evaluationsDetailsAvailable'],
      periods: json['periods'].map<Period>((e) => Period.fromJson(e)).toList(),
    );
  }
}

class Period extends BaseResponse {
  String label;
  String startDate;
  String endDate;
  Period({
    required this.label,
    required this.startDate,
    required this.endDate,
    required super.id,
  });
  static Period fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'],
      label: json['label'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
