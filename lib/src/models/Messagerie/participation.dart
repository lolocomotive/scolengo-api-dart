import 'package:scolengo_api_dart/src/models/Messagerie/participant.dart';
import 'package:scolengo_api_dart/src/models/School/attachment.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

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
  });

  static Participation fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'],
      dateTime: json['dateTime'],
      content: json['content'],
      read: json['read'],
      attachments: json['attachments']
          ?.map<Attachment>((attachment) => Attachment.fromJson(attachment))
          .toList(),
      sender: Participant.fromJson(json['sender']),
    );
  }
}
