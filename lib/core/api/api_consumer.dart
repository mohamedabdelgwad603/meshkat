// Abstract HTTP client every data source talks to.
abstract class ApiConsumer {
  // Sends a GET request and returns the decoded body.
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  // Sends a POST request and returns the decoded body.
  Future<dynamic> post(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});

  // Sends a PUT request and returns the decoded body.
  Future<dynamic> put(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});

  // Sends a DELETE request and returns the decoded body.
  Future<dynamic> delete(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});

  // Downloads a remote file to a local path and reports progress from 0 to 1.
  Future<void> download(String url, String savePath, {void Function(double progress)? onProgress});
}
