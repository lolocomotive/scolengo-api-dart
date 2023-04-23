class EvaluationDetailAttributes {
  String? title;
  String? topic;
  String? dateTime;
  num coefficient;
  String? min;
  String? max;
  String? average;
  String? scale;
  EvaluationDetailAttributes({
    this.title,
    this.topic,
    this.dateTime,
    required this.coefficient,
    this.min,
    this.max,
    this.average,
    this.scale,
  });
}
