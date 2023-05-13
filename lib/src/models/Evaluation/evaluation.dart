import 'package:scolengo_api/scolengo_api.dart';

abstract class EvaluationResponse extends BaseResponse {
  EvaluationResponse({required super.type, required super.id});

  static EvaluationResponse fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'evaluationService':
        return EvaluationService.fromJson(json);
      case 'evaluation':
        return Evaluation.fromJson(json, Subject.fromJson(json['subject']));
      default:
        throw Exception('Unknown type ${json['type']}');
    }
  }
}

class EvaluationService extends EvaluationResponse {
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
              ?.map<Evaluation>((e) => Evaluation.fromJson(e, subject))
              ?.toList() ??
          [],
      subject: subject,
    );
  }
}

class Evaluation extends EvaluationResponse {
  num? coefficient;
  num? average;
  num? scale;
  num? studentAverage;
  num? min;
  num? max;
  Subject subject;
  String date;
  String? topic;
  String? dateTime;
  String? title;
  EvaluationResult result;
  EvaluationService? evaluationService;

  Evaluation({
    required this.coefficient,
    required this.average,
    required this.scale,
    required this.studentAverage,
    this.min,
    this.max,
    required this.result,
    required this.subject,
    required this.date,
    this.topic,
    this.dateTime,
    this.title,
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
  num? mark;
  String? nonEvaluationReason;
  String? comment;
  List<SubSkillEvaluationResult>? subSkillsEvaluationResults;
  EvaluationResult({
    this.mark,
    required super.type,
    required super.id,
    this.nonEvaluationReason,
  });
  static EvaluationResult fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      id: json['id'],
      type: json['type'],
      mark: json['mark'],
      nonEvaluationReason: json['nonEvaluationReason'],
    );
  }
}

class SubSkillEvaluationResult extends BaseResponse {
  String level;
  SubSkill subskill;

  SubSkillEvaluationResult({
    required this.level,
    required this.subskill,
    required super.type,
    required super.id,
  });
  static SubSkillEvaluationResult fromJson(Map<String, dynamic> json) {
    return SubSkillEvaluationResult(
      id: json['id'],
      type: json['type'],
      level: json['level'],
      subskill: SubSkill.fromJson(json['subSkill']),
    );
  }
}

class SubSkill extends BaseResponse {
  String shortLabel;
  SubSkill({
    required this.shortLabel,
    required super.type,
    required super.id,
  });
  static SubSkill fromJson(Map<String, dynamic> json) {
    return SubSkill(
      id: json['id'],
      type: json['type'],
      shortLabel: json['shortLabel'],
    );
  }
}
