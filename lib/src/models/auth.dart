import 'School/school.dart' show School;

abstract class Auth {
  String access_token;
  String id_token;
  String refresh_token;
  String token_type;
  num expires_at;
  String scope;
  Auth({
    required this.access_token,
    required this.id_token,
    required this.refresh_token,
    required this.token_type,
    required this.expires_at,
    required this.scope,
  });
}

abstract class AuthConfig {
  dynamic tokenSet;
  School school;
  AuthConfig({
    required this.tokenSet,
    required this.school,
  });
}
