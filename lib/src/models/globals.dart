import 'dart:convert';

class Reference<Type> {
  String id;
  Reference({
    required this.id,
  });
}

class BaseResponse<Attributes, Relationships> {
  String id;
  BaseResponse({
    required this.id,
  });
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
