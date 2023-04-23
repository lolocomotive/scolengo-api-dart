import 'package:scolengo_api_dart/src/models/App/user.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class Participant extends BaseResponse {
  String category;
  dynamic additionalInfo;
  String? label;
  bool fromGroup;
  User? person;
  Participant(
      {required this.category,
      required this.additionalInfo,
      this.label,
      required this.fromGroup,
      required super.id,
      this.person});

  static Participant fromJson(Map<String, dynamic> json) {
    //TODO add relationships
    return Participant(
      id: json['id'],
      category: json['category'],
      additionalInfo: json['additionalInfo'],
      label: json['label'],
      fromGroup: json['fromGroup'],
      person: json['person'] == null ? null : User.fromJson(json['person']),
    );
  }
}
