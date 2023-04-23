import 'package:scolengo_api_dart/src/models/globals.dart';

class CurrentConfig extends BaseResponse {
  String latestDeployedSkoAppVersion;
  String latestSupportedSkoAppVersion;
  num apiCallRetryDelay;
  num apiCallMaxRetries;
  String skoAppDeploymentInfoUrl;
  CurrentConfig({
    required this.latestDeployedSkoAppVersion,
    required this.latestSupportedSkoAppVersion,
    required this.apiCallRetryDelay,
    required this.apiCallMaxRetries,
    required this.skoAppDeploymentInfoUrl,
    required super.id,
  });
  static CurrentConfig fromJson(Map<String, dynamic> json) {
    return CurrentConfig(
      id: json['id'],
      latestDeployedSkoAppVersion: json['latestDeployedSkoAppVersion'],
      latestSupportedSkoAppVersion: json['latestSupportedSkoAppVersion'],
      apiCallRetryDelay: json['apiCallRetryDelay'],
      apiCallMaxRetries: json['apiCallMaxRetries'],
      skoAppDeploymentInfoUrl: json['skoAppDeploymentInfoUrl'],
    );
  }
}
