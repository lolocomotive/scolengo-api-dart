import 'package:scolengo_api/src/models/Messagerie/participation.dart';
import 'package:scolengo_api/src/models/globals.dart';

class Communication extends BaseResponse {
  String subject;
  num? participationsNumber;
  String? recipientsSummary;
  bool? read;
  bool? replyToAllAllowed;
  bool? replyToSenderAllowed;
  bool? readTrackingEnabled;
  String? firstParticipationContent;
  Participation? lastParticipation;
  Communication({
    required this.subject,
    this.participationsNumber,
    this.recipientsSummary,
    this.read,
    this.replyToAllAllowed,
    this.replyToSenderAllowed,
    this.readTrackingEnabled,
    this.firstParticipationContent,
    this.lastParticipation,
    required super.id,
    required super.type,
  });
  static Communication fromJson(Map<String, dynamic> json) {
    return Communication(
      id: json['id'],
      type: json['type'],
      subject: json['subject'],
      participationsNumber: json['participationsNumber'],
      recipientsSummary: json['recipientsSummary'],
      read: json['read'],
      replyToAllAllowed: json['replyToAllAllowed'],
      replyToSenderAllowed: json['replyToSenderAllowed'],
      readTrackingEnabled: json['readTrackingEnabled'],
      firstParticipationContent: json['firstParticipationContent'],
      lastParticipation: json['lastParticipation'] == null
          ? null
          : Participation.fromJson(json['lastParticipation']),
    );
  }
}
