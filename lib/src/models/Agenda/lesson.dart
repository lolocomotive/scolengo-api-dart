import 'package:scolengo_api_dart/src/models/App/user.dart';
import 'package:scolengo_api_dart/src/models/Homework/homework_assignments.dart';
import 'package:scolengo_api_dart/src/models/School/attachment.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class Subject extends BaseResponse {
  String label;
  String color;
  Subject({
    required this.label,
    required this.color,
    required super.id,
  });
  static Subject fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      label: json['label'],
      color: json['color'],
    );
  }
}

class LessonContent extends BaseResponse {
  String html;
  String title;
  String? url;
  List<Attachment>? attachments;
  LessonContent({
    required this.html,
    required this.title,
    this.url,
    this.attachments,
    required super.id,
  });
  static LessonContent fromJson(Map<String, dynamic> json) {
    return LessonContent(
      id: json['id'],
      html: json['html'],
      title: json['title'],
      url: json['url'],
      attachments: json['attachments']
          ?.map<Attachment>((e) => Attachment.fromJson(e))
          .toList(),
    );
  }
}

class Lesson extends BaseResponse {
  String startDateTime;
  String endDateTime;
  String title;
  String location;
  dynamic locationComplement;
  bool canceled;
  List<LessonContent>? contents;
  List<User>? teachers;
  Subject subject;
  List<HomeworkAssignment>? toDoForTheLesson;
  List<HomeworkAssignment>? toDoAfterTheLesson;
  Lesson({
    required this.startDateTime,
    required this.endDateTime,
    required this.title,
    required this.location,
    required this.locationComplement,
    required this.canceled,
    this.contents,
    this.teachers,
    required this.subject,
    this.toDoForTheLesson,
    this.toDoAfterTheLesson,
    required super.id,
  });
  static Lesson fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      startDateTime: json['startDateTime'],
      endDateTime: json['endDateTime'],
      title: json['title'],
      location: json['location'],
      locationComplement: json['locationComplement'],
      canceled: json['canceled'],
      contents: json['contents']
          ?.map<LessonContent>((e) => LessonContent.fromJson(e))
          .toList(),
      teachers: json['teachers']?.map<User>((e) => User.fromJson(e)).toList(),
      subject: Subject.fromJson(json['subject']),
      toDoForTheLesson: json['toDoForTheLesson']
          ?.map<HomeworkAssignment>((e) => HomeworkAssignment.fromJson(e))
          .toList(),
      toDoAfterTheLesson: json['toDoAfterTheLesson']
          ?.map<HomeworkAssignment>((e) => HomeworkAssignment.fromJson(e))
          .toList(),
    );
  }
}
