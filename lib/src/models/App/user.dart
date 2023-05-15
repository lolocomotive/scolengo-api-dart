import 'package:scolengo_api/src/models/School/school.dart';
import 'package:scolengo_api/src/models/globals.dart';

class UserPermission {
  String schoolId;
  String service;
  List<String> permittedOperations;
  UserPermission({
    required this.schoolId,
    required this.service,
    required this.permittedOperations,
  });

  static UserPermission fromJson(Map<String, dynamic> json) {
    return UserPermission(
      schoolId: json['schoolId'],
      service: json['service'],
      permittedOperations: json['permittedOperations'].cast<String>(),
    );
  }
}

class User extends BaseResponse {
  String? title;
  String? className;
  String? dateOfBirth;
  String? regime;
  String lastName;
  String firstName;
  String? photoUrl;
  dynamic mef;
  String? externalMail;
  String? importedMail;
  String? internalMail;
  String? profile;
  String? source;
  String? mobilePhone;
  List<UserPermission>? permissions;
  List<String>? addressLines;
  String? postalCode;
  String? city;
  String? country;
  List<User>? students;
  School? school;

  User({
    required super.id,
    required super.type,
    this.title,
    this.className,
    this.dateOfBirth,
    this.regime,
    required this.lastName,
    required this.firstName,
    this.photoUrl,
    required this.mef,
    this.externalMail,
    this.importedMail,
    this.internalMail,
    this.profile,
    this.source,
    this.mobilePhone,
    this.permissions,
    this.addressLines,
    this.postalCode,
    this.city,
    this.country,
    this.students,
    this.school,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      className: json['className'],
      dateOfBirth: json['dateOfBirth'],
      regime: json['regime'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      photoUrl: json['photoUrl'],
      mef: json['mef'],
      externalMail: json['externalMail'],
      importedMail: json['importedMail'],
      internalMail: json['internalMail'],
      profile: json['profile'],
      source: json['source'],
      mobilePhone: json['mobilePhone'],
      permissions: json['permissions']
          ?.map<UserPermission>(
              (permission) => UserPermission.fromJson(permission))
          .toList(),
      addressLines:
          json['addressLines']?.map<String>((e) => e as String).toList(),
      postalCode: json['postalCode'],
      city: json['city'],
      country: json['country'],
      students: json['students']?.map<User>((e) => User.fromJson(e)).toList(),
      school: json['school'] != null ? School.fromJson(json['school']) : null,
    );
  }
}
