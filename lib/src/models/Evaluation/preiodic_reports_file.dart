import 'package:scolengo_api_dart/src/models/globals.dart';

class PeriodicReportsFileRelationships {
  dynamic period;
  PeriodicReportsFileRelationships({
    required this.period,
  });
}

class PeriodicReportsFile extends BaseResponse {
  String? alternativeText;
  String name;
  String mimeType;
  String mimeTypeLabel;
  num size;
  String url;
  PeriodicReportsFile({
    this.alternativeText,
    required this.name,
    required this.mimeType,
    required this.mimeTypeLabel,
    required this.size,
    required this.url,
    required super.id,
  });

  static PeriodicReportsFile fromJson(Map<String, dynamic> json) {
    //TODO add relationships
    return PeriodicReportsFile(
      id: json['id'],
      alternativeText: json['alternativeText'],
      name: json['name'],
      mimeType: json['mimeType'],
      mimeTypeLabel: json['mimeTypeLabel'],
      size: json['size'],
      url: json['url'],
    );
  }
}
