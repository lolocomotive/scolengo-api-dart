import 'package:scolengo_api/src/models/Messagerie/participant.dart';
import 'package:scolengo_api/src/models/School/attachment.dart';
import 'package:scolengo_api/src/models/globals.dart';

class Participation extends BaseResponse {
  String dateTime;
  String content;
  bool read;
  List<Attachment>? attachments;
  Participant? sender;
  Participation({
    required this.dateTime,
    required this.content,
    required this.read,
    this.attachments,
    this.sender,
    required super.id,
    required super.type,
  });

  static Participation fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'],
      type: json['type'],
      dateTime: json['dateTime'],
      content: json['content'],
      read: json['read'],
      attachments: json['attachments']
          ?.map<Attachment>((attachment) => Attachment.fromJson(attachment))
          .toList(),
      sender:
          json['sender'] == null ? null : Participant.fromJson(json['sender']),
    );
  }
}
