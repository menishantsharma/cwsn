import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centralized API client that all repositories route through.
///
/// Currently wraps fake delays. When a real backend is ready, swap
/// [FakeApiClient] for a real implementation that uses `http` or `dio`
/// — repositories stay unchanged.
final apiClientProvider = Provider<ApiClient>((ref) => FakeApiClient());

abstract class ApiClient {
  /// Simulates a network round-trip. Real implementation would make
  /// an authenticated HTTP call and throw typed exceptions on failure.
  Future<T> request<T>({
    required Future<T> Function() action,
    Duration timeout = const Duration(seconds: 15),
  });
}

/// Mock implementation that adds a configurable delay.
class FakeApiClient implements ApiClient {
  @override
  Future<T> request<T>({
    required Future<T> Function() action,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    return action();
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
