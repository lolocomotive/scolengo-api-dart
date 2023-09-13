import 'package:scolengo_api/src/models/Agenda/lesson.dart';
import 'package:scolengo_api/src/models/App/user.dart';
import 'package:scolengo_api/src/models/School/attachment.dart';
import 'package:scolengo_api/src/models/globals.dart';

class HomeworkAssignment extends BaseResponse {
  String? title;
  String html;
  String? dueDateTime;
  String? dueDate;
  bool done;
  bool deliverWorkOnline;
  String? onlineDeliveryUrl;
  User? teacher;
  List<Attachment>? attachments;
  Subject? subject;
  //TODO test the 4 following fields
  dynamic audio;
  dynamic pedagogicContent;
  CorrectionWork? individualCorrectedWork;
  CorrectionWork? commonCorrectedWork;

  HomeworkAssignment({
    required this.title,
    required this.html,
    required this.dueDateTime,
    required this.dueDate,
    required this.done,
    required this.deliverWorkOnline,
    required this.onlineDeliveryUrl,
    this.teacher,
    this.attachments,
    this.subject,
    required this.audio,
    required this.pedagogicContent,
    this.individualCorrectedWork,
    this.commonCorrectedWork,
    required super.id,
    required super.type,
  });

  static HomeworkAssignment fromJson(Map<String, dynamic> json) {
    return HomeworkAssignment(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      html: json['html'] ?? '',
      dueDateTime: json['dueDateTime'],
      dueDate: json['dueDate'],
      done: json['done'],
      deliverWorkOnline: json['deliverWorkOnline'],
      onlineDeliveryUrl: json['onlineDeliveryUrl'],
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
      attachments: json['attachments']
          ?.map<Attachment>((e) => Attachment.fromJson(e))
          .toList(),
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      audio: json['audio'],
      pedagogicContent: json['pedagogicContent'],
      individualCorrectedWork: json['individualCorrectedWork'] != null
          ? CorrectionWork.fromJson(json['individualCorrectedWork'])
          : null,
      commonCorrectedWork: json['commonCorrectedWork'] != null
          ? CorrectionWork.fromJson(json['commonCorrectedWork'])
          : null,
    );
  }
}

class CorrectionWork extends BaseResponse {
  String html;
  String correctionDate;
  CorrectionWork({
    required this.html,
    required this.correctionDate,
    required super.id,
    required super.type,
  });

  static CorrectionWork fromJson(Map<String, dynamic> json) {
    return CorrectionWork(
      id: json['id'],
      type: json['type'],
      html: json['html'],
      correctionDate: json['correctionDate'],
    );
  }
}
