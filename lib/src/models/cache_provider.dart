/// Optionnal interface to implement if you want to cache the API responses.
/// The structure may be a bit unusual since I don't have much experience with this.
abstract class CacheProvider {
  Future<String> get(String key);

  /// This is not a Future since the _invokeApi function ignores the return value of this function.
  void set(String key, String value);

  ///Both can be true
  Future<bool> useNetwork(String key);
  Future<bool> useCache(String key);

  /// Indicates if the raw response from the API or a JSON:API decoded response should be cached.
  /// The decoded response is sometimes smaller and thus quicker to cache/retrieve/parse afterwards.
  /// This should not change.
  bool raw();
}
