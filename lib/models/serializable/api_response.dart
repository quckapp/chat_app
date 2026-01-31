import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API response wrapper
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;
  final ApiMeta? meta;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  bool get hasError => error != null || !success;
  bool get hasData => data != null;
}

@JsonSerializable()
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;
  final List<ValidationError>? validationErrors;

  const ApiError({
    required this.code,
    required this.message,
    this.details,
    this.validationErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

@JsonSerializable()
class ValidationError {
  final String field;
  final String message;
  final String? code;

  const ValidationError({
    required this.field,
    required this.message,
    this.code,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);
}

@JsonSerializable()
class ApiMeta {
  final int? page;
  final int? pageSize;
  final int? total;
  final int? totalPages;
  final String? cursor;
  final bool? hasMore;

  const ApiMeta({
    this.page,
    this.pageSize,
    this.total,
    this.totalPages,
    this.cursor,
    this.hasMore,
  });

  factory ApiMeta.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaFromJson(json);
  Map<String, dynamic> toJson() => _$ApiMetaToJson(this);
}

/// Paginated list response
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    this.hasNext = false,
    this.hasPrev = false,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}

/// Cursor-based pagination response
@JsonSerializable(genericArgumentFactories: true)
class CursorPaginatedResponse<T> {
  final List<T> items;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMore;
  final int? total;

  const CursorPaginatedResponse({
    required this.items,
    this.nextCursor,
    this.prevCursor,
    this.hasMore = false,
    this.total,
  });

  factory CursorPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$CursorPaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$CursorPaginatedResponseToJson(this, toJsonT);
}
