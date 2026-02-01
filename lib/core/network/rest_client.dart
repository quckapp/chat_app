import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../exceptions/api_exception.dart';
import '../storage/secure_storage.dart';

/// Type-safe REST client with automatic serialization
class RestClient {
  final Dio _dio;
  final SecureStorage _storage;
  bool _isRefreshing = false;
  final List<Completer<String>> _refreshQueue = [];

  RestClient({
    required String baseUrl,
    SecureStorage? storage,
    Dio? dio,
  })  : _storage = storage ?? SecureStorage.instance,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: ApiConstants.connectionTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    debugPrint('RestClient: Request to ${options.uri}');
    debugPrint('RestClient: Token present: ${token != null}');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('RestClient: Added Authorization header');
    } else {
      debugPrint('RestClient: WARNING - No token available!');
    }
    handler.next(options);
  }

  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    debugPrint('RestClient: Error ${error.response?.statusCode} for ${error.requestOptions.uri}');
    debugPrint('RestClient: Error data: ${error.response?.data}');
    if (error.response?.statusCode == 401) {
      debugPrint('RestClient: Got 401, attempting token refresh...');
      try {
        final token = await _refreshTokenWithQueue();
        if (token != null) {
          debugPrint('RestClient: Token refreshed successfully, retrying request');
          error.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(error.requestOptions);
          return handler.resolve(response);
        } else {
          debugPrint('RestClient: Token refresh returned null');
        }
      } catch (e) {
        debugPrint('RestClient: Token refresh failed: $e');
      }
    }
    handler.next(error);
  }

  Future<String?> _refreshTokenWithQueue() async {
    if (_isRefreshing) {
      final completer = Completer<String>();
      _refreshQueue.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return null;

      final response = await Dio().post(
        '${ApiConstants.authServiceBaseUrl}${ApiConstants.refreshToken}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['accessToken'] as String;
        final newRefresh = response.data['refreshToken'] as String;

        await _storage.saveTokens(
          accessToken: newToken,
          refreshToken: newRefresh,
        );

        for (final completer in _refreshQueue) {
          completer.complete(newToken);
        }
        _refreshQueue.clear();

        return newToken;
      }
      return null;
    } catch (e) {
      for (final completer in _refreshQueue) {
        completer.completeError(e);
      }
      _refreshQueue.clear();
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// GET request with typed response
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParams,
        options: options,
      );
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET request returning a list
  Future<List<T>> getList<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
    String? dataKey,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParams,
        options: options,
      );

      final List<dynamic> data;
      if (dataKey != null && response.data is Map) {
        data = response.data[dataKey] as List<dynamic>;
      } else if (response.data is List) {
        data = response.data as List<dynamic>;
      } else {
        throw ApiException(message: 'Invalid response format');
      }

      return data
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request with typed response
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request without typed response (void return)
  Future<void> postVoid(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request with typed response
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH request with typed response
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<void> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      await _dio.delete(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload file with progress
  Future<T> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? extraFields,
    required T Function(Map<String, dynamic>) fromJson,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (extraFields != null) ...extraFields,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: formData,
        onSendProgress: onProgress,
      );

      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Download file with progress
  Future<void> downloadFile(
    String url,
    String savePath, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');
      default:
        return ApiException(message: error.message ?? 'Unknown error');
    }
  }

  ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'Request failed';
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message: message, errors: data);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 409:
        return ConflictException(message: message);
      case 422:
        return ValidationException(message: message, errors: data);
      case 429:
        return RateLimitException(message: 'Too many requests');
      case 500:
      case 502:
      case 503:
        return ServerException(message: 'Server error');
      default:
        return ApiException(message: message, statusCode: statusCode);
    }
  }
}
