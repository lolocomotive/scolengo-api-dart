import '../globals.dart' show BaseResponse;

class School extends BaseResponse {
  String name;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? zipCode;
  String? city;
  String? country;
  String? homePageUrl;
  String? emsCode;
  String? emsOIDCWellKnownUrl;
  num? distance;

  School({
    required this.name,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.zipCode,
    this.city,
    this.country,
    this.homePageUrl,
    this.emsCode,
    this.emsOIDCWellKnownUrl,
    this.distance,
    required super.id,
  });

  static School fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      zipCode: json['zipCode'],
      city: json['city'],
      country: json['country'],
      homePageUrl: json['homePageUrl'],
      emsCode: json['emsCode'],
      emsOIDCWellKnownUrl: json['emsOIDCWellKnownUrl'],
      distance: json['distance'],
    );
  }
}
