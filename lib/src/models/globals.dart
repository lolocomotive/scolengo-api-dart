import 'dart:convert';

abstract class BaseResponse<Attributes, Relationships> {
  String type;
  String id;
  BaseResponse({
    required this.type,
    required this.id,
  });

  Map<String, String> toMap() {
    return {
      'type': type,
      'id': id,
    };
  }
}

class SkolengoResponse<Data> {
  Data data;
  late Map<String, dynamic>? links;
  late Map<String, dynamic>? meta;
  late String json;
  Map<String, dynamic> raw;

  SkolengoResponse({
    required this.data,
    required this.raw,
  }) {
    meta = raw['meta'];
    links = raw['links'];
    json = jsonEncode(raw);
  }
}
