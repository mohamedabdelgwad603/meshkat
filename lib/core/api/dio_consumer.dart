import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/core/errors/exceptions.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Dio-backed implementation of ApiConsumer with shared timeouts and error mapping.
class DioConsumer implements ApiConsumer {
  final Dio _dio;

  // Configures the Dio client with the API base URL and timeouts.
  DioConsumer(this._dio) {
    _dio.options
      ..baseUrl = EndPoints.baseUrl
      ..connectTimeout = const Duration(seconds: 20)
      ..receiveTimeout = const Duration(seconds: 30)
      ..responseType = ResponseType.json;
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ));
    }
  }

  // Sends a GET request and returns the decoded body.
  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _guard(() => _dio.get(path, queryParameters: queryParameters));

  // Sends a POST request and returns the decoded body.
  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) =>
      _guard(() => _dio.post(path, data: body, queryParameters: queryParameters));

  // Sends a PUT request and returns the decoded body.
  @override
  Future<dynamic> put(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) =>
      _guard(() => _dio.put(path, data: body, queryParameters: queryParameters));

  // Sends a DELETE request and returns the decoded body.
  @override
  Future<dynamic> delete(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) =>
      _guard(() => _dio.delete(path, data: body, queryParameters: queryParameters));

  // Downloads a remote file to a local path and reports progress from 0 to 1.
  @override
  Future<void> download(String url, String savePath, {void Function(double progress)? onProgress}) async {
    await _guard(() => _dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total > 0) onProgress?.call(received / total);
          },
        ));
  }

  // Runs a request and converts Dio errors into a ServerException with a translation key.
  Future<dynamic> _guard(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      throw ServerException(_messageFor(e));
    }
  }

  // Maps a Dio error type to a user-facing translation key.
  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TextManager.errorTimeout;
      case DioExceptionType.connectionError:
        return TextManager.errorNoInternet;
      case DioExceptionType.badResponse:
        return TextManager.errorServer;
      default:
        return TextManager.errorUnknown;
    }
  }
}
