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
  String? timeZone;
  List<String>? subscribedServices;

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
    this.timeZone,
    this.subscribedServices,
    required super.id,
    required super.type,
  });

  static School fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      type: json['type'],
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
      timeZone: json['timeZone'],
      subscribedServices: json['subscribedServices']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'zipCode': zipCode,
      'city': city,
      'country': country,
      'homePageUrl': homePageUrl,
      'emsCode': emsCode,
      'emsOIDCWellKnownUrl': emsOIDCWellKnownUrl,
      'distance': distance,
    };
  }
}
