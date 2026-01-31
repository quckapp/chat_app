// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      success: json['success'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String?,
      error: json['error'] == null
          ? null
          : ApiError.fromJson(json['error'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : ApiMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'message': instance.message,
      'error': instance.error,
      'meta': instance.meta,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
      validationErrors: (json['validationErrors'] as List<dynamic>?)
          ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'validationErrors': instance.validationErrors,
    };

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) =>
    ValidationError(
      field: json['field'] as String,
      message: json['message'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
      'code': instance.code,
    };

ApiMeta _$ApiMetaFromJson(Map<String, dynamic> json) => ApiMeta(
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      cursor: json['cursor'] as String?,
      hasMore: json['hasMore'] as bool?,
    );

Map<String, dynamic> _$ApiMetaToJson(ApiMeta instance) => <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'cursor': instance.cursor,
      'hasMore': instance.hasMore,
    };

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedResponse<T>(
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrev: json['hasPrev'] as bool? ?? false,
    );

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'items': instance.items.map(toJsonT).toList(),
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
    };

CursorPaginatedResponse<T> _$CursorPaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    CursorPaginatedResponse<T>(
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
      nextCursor: json['nextCursor'] as String?,
      prevCursor: json['prevCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CursorPaginatedResponseToJson<T>(
  CursorPaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'items': instance.items.map(toJsonT).toList(),
      'nextCursor': instance.nextCursor,
      'prevCursor': instance.prevCursor,
      'hasMore': instance.hasMore,
      'total': instance.total,
    };
