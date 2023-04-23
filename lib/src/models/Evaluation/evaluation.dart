import 'package:scolengo_api_dart/src/models/globals.dart';

class Evaluation extends BaseResponse {
  num coefficient;
  num? average;
  num scale;
  num? studentAverage;
  Evaluation({
    required this.coefficient,
    required this.average,
    required this.scale,
    required this.studentAverage,
    required super.id,
  });
  static Evaluation fromJson(Map<String, dynamic> json) {
    //TODO add relationships
    return Evaluation(
      id: json['id'],
      coefficient: json['coefficient'],
      average: json['average'],
      scale: json['scale'],
      studentAverage: json['studentAverage'],
    );
  }
}

class EvaluationRelationships {
  dynamic evaluations;
  dynamic subject;
  dynamic teachers;
  EvaluationRelationships({
    required this.evaluations,
    required this.subject,
    required this.teachers,
  });
}

class EvaluationIncludedRelationships {
  dynamic subSkills;
  dynamic evaluationResult;
  dynamic subSkillsEvaluationResults;
  dynamic subSkill;
  EvaluationIncludedRelationships({
    required this.subSkills,
    required this.evaluationResult,
    required this.subSkillsEvaluationResults,
    required this.subSkill,
  });
}
