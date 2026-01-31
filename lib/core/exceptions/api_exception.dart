class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.data,
  });

  factory ApiException.fromResponse(dynamic response, int? statusCode) {
    if (response is Map<String, dynamic>) {
      return ApiException(
        message: response['message'] ?? response['error'] ?? 'An error occurred',
        statusCode: statusCode,
        code: response['code'],
        data: response,
      );
    }
    return ApiException(
      message: 'An error occurred',
      statusCode: statusCode,
    );
  }

  @override
  String toString() => 'ApiException: $message (status: $statusCode, code: $code)';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Unauthorized. Please login again.',
          statusCode: 401,
        );
}

class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'You do not have permission to perform this action.',
          statusCode: 403,
        );
}

class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Resource not found.',
          statusCode: 404,
        );
}

class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Network error. Please check your connection.',
          statusCode: 0,
        );
}

class ValidationException extends ApiException {
  final dynamic errors;

  ValidationException({String? message, this.errors})
      : super(
          message: message ?? 'Validation failed.',
          statusCode: 422,
        );
}

class ConflictException extends ApiException {
  ConflictException({String? message})
      : super(
          message: message ?? 'Resource conflict.',
          statusCode: 409,
        );
}

class RateLimitException extends ApiException {
  final Duration? retryAfter;

  RateLimitException({String? message, this.retryAfter})
      : super(
          message: message ?? 'Too many requests. Please try again later.',
          statusCode: 429,
        );
}

class ServerException extends ApiException {
  ServerException({String? message})
      : super(
          message: message ?? 'Server error. Please try again later.',
          statusCode: 500,
        );
}

class TimeoutException extends ApiException {
  TimeoutException({String? message})
      : super(
          message: message ?? 'Request timed out. Please try again.',
          statusCode: 408,
        );
}
