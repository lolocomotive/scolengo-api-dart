# scolengo-api-dart

Unofficial Dart API Wrapper for the Skolengo education management system. Heavily inspired from [scolengo-api](https://github.com/maelgangloff/scolengo-api)

Since I don't have access to the entire API, some features or fields may be missing. Feel free to contribute.

## Example:

This should work in the command line.
<details>

<summary>If you get stuck after the authorization</summary>

 - Add `urlLancher: (url) => print(url)` to the Authenticator
 - Paste the given URL in a browser that already has devtools open on the networking page
 - Copy the URL of the 2nd request ( `sko-app://sign-in-callback?code=...` ) 
 - Open a new browser tab and paste the url, replacing `sko-app://` with `localhost:3000/`
 - It should work.
 - We can't provide localhost:300 as redirectUri because then we get an error from the CAS 

</details>
 
 

```dart
import 'dart:convert';
import 'dart:io';

import 'package:openid_client/openid_client_io.dart';
import 'package:scolengo_api_dart/src/models/School/school.dart';
import 'package:scolengo_api_dart/src/skolengo.dart';

void main() async {
  final Credential credentials;
  final School school;

  final client = Skolengo.unauthenticated();
  final schools = await client.searchSchool('Lycée ...');
  school = schools.data[0];
  credentials = await createCredentials(school);

  //It's a good idea to save the credentials and school as JSON here
 
  final client = Skolengo.fromCredentials(credentials, school);

  //You should be able to use the client now
}

Future<Credential> createCredentials(School school, [Skolengo? client]) async {
  client ??= Skolengo.unauthenticated();
  final oidclient = await client.getOIDClient(school);
  final f = Flow.implicit(oidclient);
  final authenticator = Authenticator(
    oidclient,
    redirectUri: Uri.parse('skoapp-prod://sign-in-callback'),
  );
  return authenticator.authorize();
}
```

If you want to use this in a flutter app, change the createCredentials function according to the [openid_client documentation](https://pub.dev/packages/openid_client)
