/// Optionnal interface to implement if you want to cache the API responses.
/// The structure may be a bit unusual since I don't have much experience with this.
abstract class CacheProvider {
  Future<String> get(String key);

  /// This is not a Future since the _invokeApi function ignores the return value of this function.
  void set(String key, String value);

  /// shouldUseCache should be quick to execute, since it is called before the API call.
  /// It would be better not to use a database request within this function since it might
  /// slow things down significantly, deying the purpose of caching.
  /// This should be determined depending on the current date and the date of the last cached response.
  /// Or just any criteria you like really.
  Future<bool> shouldUseCache(String key);

  /// Indicates if the raw response from the API or a JSON:API decoded response should be cached.
  /// The decoded response is sometimes smaller and thus quicker to cache/retrieve/parse afterwards.
  /// This should not change.
  bool raw();
}
