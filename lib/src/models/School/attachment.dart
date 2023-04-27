import 'package:scolengo_api/src/models/globals.dart';

class Attachment extends BaseResponse {
  String name;
  String mimeType;
  String mimeTypeLabel;
  num size;
  String url;
  Attachment({
    required this.name,
    required this.mimeType,
    required this.mimeTypeLabel,
    required this.size,
    required this.url,
    required super.id,
    required super.type,
  });

  static Attachment fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      mimeType: json['mimeType'],
      mimeTypeLabel: json['mimeTypeLabel'],
      size: json['size'],
      url: json['url'],
    );
  }
}

class PublicAttachment extends Attachment {
  String? alternativeText;
  PublicAttachment({
    required super.name,
    required super.mimeType,
    required super.mimeTypeLabel,
    required super.size,
    required super.url,
    required super.id,
    required this.alternativeText,
    required super.type,
  });

  static PublicAttachment fromJson(Map<String, dynamic> json) {
    return PublicAttachment(
      id: json['id'],
      type: json['type'],
      alternativeText: json['alternativeText'],
      name: json['name'],
      mimeType: json['mimeType'],
      mimeTypeLabel: json['mimeTypeLabel'],
      size: json['size'],
      url: json['url'],
    );
  }
}
