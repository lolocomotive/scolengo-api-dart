import 'package:scolengo_api/scolengo_api.dart';

class EvaluationService extends BaseResponse {
  List<Evaluation> evaluations;
  Subject subject;
  EvaluationService({
    required this.evaluations,
    required this.subject,
    required super.type,
    required super.id,
  });

  static EvaluationService fromJson(Map<String, dynamic> json) {
    Subject subject = Subject.fromJson(json['subject']);
    return EvaluationService(
      id: json['id'],
      type: json['type'],
      evaluations: json['evaluations']
          .map<Evaluation>((e) => Evaluation.fromJson(e, subject))
          .toList(),
      subject: subject,
    );
  }
}

class Evaluation extends BaseResponse {
  num? coefficient;
  num? average;
  num? scale;
  num? studentAverage;
  EvaluationResult result;
  Subject subject;
  String date;
  /* 
  I can't test those:
    dynamic subSkills;
    dynamic subSkillsEvaluationResults;
    dynamic subSkill;
  */
  Evaluation({
    required this.coefficient,
    required this.average,
    required this.scale,
    required this.studentAverage,
    required this.subject,
    required this.result,
    required this.date,
    required super.type,
    required super.id,
  });
  static Evaluation fromJson(Map<String, dynamic> json, Subject subject) {
    return Evaluation(
      id: json['id'],
      type: json['type'],
      coefficient: json['coefficient'],
      average: json['average'],
      scale: json['scale'],
      subject: subject,
      date: json['dateTime'],
      result: EvaluationResult.fromJson(json['evaluationResult']),
      studentAverage: json['studentAverage'],
    );
  }
}

class EvaluationResult extends BaseResponse {
  num mark;
  EvaluationResult({
    required this.mark,
    required super.type,
    required super.id,
  });
  static EvaluationResult fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      id: json['id'],
      type: json['type'],
      mark: json['mark'],
    );
  }
}
