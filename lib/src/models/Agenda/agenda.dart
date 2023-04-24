import 'package:scolengo_api_dart/src/models/Agenda/lesson.dart';
import 'package:scolengo_api_dart/src/models/Homework/homework_assignments.dart';
import 'package:scolengo_api_dart/src/models/globals.dart';

class Agenda extends BaseResponse {
  String date;
  List<Lesson>? lessons;
  List<HomeworkAssignment>? homeworkAssignments;
  Agenda({
    required this.date,
    this.lessons,
    this.homeworkAssignments,
    required super.id,
    required super.type,
  });
  static Agenda fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      type: json['type'],
      date: json['date'],
      lessons: json['lessons']?.map<Lesson>((e) => Lesson.fromJson(e)).toList(),
      homeworkAssignments: json['homeworkAssignments']
          ?.map<HomeworkAssignment>((e) => HomeworkAssignment.fromJson(e))
          .toList(),
    );
  }
}
