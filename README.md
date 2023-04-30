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
import 'package:scolengo_api/src/models/School/school.dart';
import 'package:scolengo_api/src/skolengo.dart';

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

## Caching the API responses

This library comes with a pretty flexible interface for you to be able to implement your own cache provider.
As some requests take quite a long time to complete, it might be a good idea to cache the result, in memory, a JSON file, a db or anything else really
For more details look at the comments in [cache_provider.dart](lib/src/models/cache_provider.dart)

<details>

<summary>Example</summary>

### A cache provider storing the responses in JSON files

This is not a great idea, the example isn't complete and it was written in a rush but this should give a rough idea of how things should be structured.

```dart
class FSCacheProvider extends CacheProvider {
  Map<String, String> _index = {};

  @override
  Future<String> get(String key) async {
    return await File(filename(key)).readAsString();
  }

  @override
  bool raw() => false;

  @override
  void set(String key, String value) {
    _index[filename(key)] = DateTime.now().toIso8601String();
    File('./cache/index.json').createSync(recursive: true);
    File('./cache/index.json').writeAsString(jsonEncode(_index));
    File(filename(key))
      ..createSync(recursive: true)
      ..writeAsString(value);
  }

  @override
  Future<bool> shouldUseCache(String key) async {
    //TODO compare dates
    return _index.keys.contains(filename(key));
  }

  String filename(String url) {
    return './cache${Uri.parse(url).path}/${Uri.parse(url).query}.json';
  }

  init() {
    _index = File('./cache/index.json').existsSync()
        ? jsonDecode(File('./cache/index.json').readAsStringSync())
            .map<String, String>(
                (key, value) => MapEntry(key as String, value as String))
        : {};
    File('.cache/index.json').createSync(recursive: true);
  }
}
```

</details>
