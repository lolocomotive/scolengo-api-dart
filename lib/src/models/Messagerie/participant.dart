import 'package:scolengo_api/src/models/App/user.dart';
import 'package:scolengo_api/src/models/globals.dart';

class Participant extends BaseResponse {
  String category;
  dynamic additionalInfo;
  String? label;
  bool fromGroup;
  User? person;
  TechnicalUser? technicalUser;
  Participant({
    required this.category,
    required this.additionalInfo,
    this.label,
    required this.fromGroup,
    required super.id,
    this.person,
    required super.type,
    this.technicalUser,
  });

  static Participant fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      type: json['type'],
      category: json['category'],
      additionalInfo: json['additionalInfo'],
      label: json['label'],
      fromGroup: json['fromGroup'],
      person: json['person'] == null ? null : User.fromJson(json['person']),
      technicalUser: json['technicalUser'] == null
          ? null
          : TechnicalUser.fromJson(json['technicalUser']),
    );
  }
}

class TechnicalUser extends BaseResponse {
  String label;
  String? logoUrl;
  TechnicalUser({
    required this.label,
    this.logoUrl,
    required super.type,
    required super.id,
  });

  static TechnicalUser fromJson(Map<String, dynamic> json) {
    return TechnicalUser(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      logoUrl: json['logoUrl'],
    );
  }
}
