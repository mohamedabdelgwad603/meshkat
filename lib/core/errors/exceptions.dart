// Thrown by the API layer when a remote request fails; holds a translation key.
class ServerException implements Exception {
  final String message;

  // Creates a server exception with a translation key message.
  const ServerException(this.message);
}

// Thrown by local storage when cached data is missing or unreadable.
class CacheException implements Exception {
  final String message;

  // Creates a cache exception with a translation key message.
  const CacheException(this.message);
}
