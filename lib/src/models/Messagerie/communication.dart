import 'package:scolengo_api_dart/src/models/Messagerie/participation.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class Communication extends BaseResponse {
  String subject;
  num? participationsNumber;
  String? recipientsSummary;
  bool? read;
  bool? replyToAllAllowed;
  bool? replyToSenderAllowed;
  bool? readTrackingEnabled;
  String? firstParticipationContent;
  Participation lastParticipation;
  Communication({
    required this.subject,
    this.participationsNumber,
    this.recipientsSummary,
    this.read,
    this.replyToAllAllowed,
    this.replyToSenderAllowed,
    this.readTrackingEnabled,
    this.firstParticipationContent,
    required this.lastParticipation,
    required super.id,
  });
  static Communication fromJson(Map<String, dynamic> json) {
    return Communication(
      id: json['id'],
      subject: json['subject'],
      participationsNumber: json['participationsNumber'],
      recipientsSummary: json['recipientsSummary'],
      read: json['read'],
      replyToAllAllowed: json['replyToAllAllowed'],
      replyToSenderAllowed: json['replyToSenderAllowed'],
      readTrackingEnabled: json['readTrackingEnabled'],
      firstParticipationContent: json['firstParticipationContent'],
      lastParticipation: Participation.fromJson(json['lastParticipation']),
    );
  }
}
