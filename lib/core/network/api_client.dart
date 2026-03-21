import 'package:cwsn/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the singleton [Dio] instance used across the app.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true),
  );
  return dio;
});

/// Centralized API client that all repositories route through.
final apiClientProvider = Provider<ApiClient>((ref) {
  return DioApiClient(ref.watch(dioProvider));
});

abstract class ApiClient {
  /// Makes a GET request to [path] and returns the decoded response body.
  ///
  /// Throws [UnauthorizedException], [ServerException], or
  /// [ConnectionException] on failure.
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  /// Makes a POST request to [path] with [data] as the request body.
  Future<dynamic> post(String path, {Map<String, dynamic>? data});
}

/// Real implementation backed by Dio.
class DioApiClient implements ApiClient {
  final Dio _dio;
  const DioApiClient(this._dio);

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Exception _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ConnectionException('Request timed out');
      case DioExceptionType.connectionError:
        return const ConnectionException('No internet connection');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) {
          return const UnauthorizedException();
        }
        return ServerException(
          e.response?.statusMessage ?? 'Server error',
          statusCode: status,
        );
      default:
        return ServerException(e.message ?? 'Unknown error');
    }
  }
}

/// Thrown when the server returns 401 / token expired.
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Session expired']);
  @override
  String toString() => message;
}

/// Thrown on 5xx or unknown server errors.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when the device has no network connectivity.
class ConnectionException implements Exception {
  final String message;
  const ConnectionException([this.message = 'No internet connection']);
  @override
  String toString() => message;
}
