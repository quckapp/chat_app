import 'package:json_annotation/json_annotation.dart';

part 'call_dto.g.dart';

@JsonSerializable()
class CallDto {
  final String id;
  @JsonKey(name: 'caller_id')
  final String callerId;
  @JsonKey(name: 'callee_id')
  final String calleeId;
  final String type;
  final String status;
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  final int? duration;

  const CallDto({
    required this.id,
    required this.callerId,
    required this.calleeId,
    required this.type,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.duration,
  });

  factory CallDto.fromJson(Map<String, dynamic> json) => _$CallDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CallDtoToJson(this);
}

@JsonSerializable()
class InitiateCallDto {
  @JsonKey(name: 'callee_id')
  final String calleeId;
  final String type;

  const InitiateCallDto({
    required this.calleeId,
    required this.type,
  });

  factory InitiateCallDto.fromJson(Map<String, dynamic> json) => _$InitiateCallDtoFromJson(json);
  Map<String, dynamic> toJson() => _$InitiateCallDtoToJson(this);
}

/// LiveKit token response from POST /api/v1/calls/:id/token
class CallTokenDto {
  final String token;
  final String url;
  final String? roomName;

  const CallTokenDto({
    required this.token,
    required this.url,
    this.roomName,
  });

  factory CallTokenDto.fromJson(Map<String, dynamic> json) {
    return CallTokenDto(
      token: json['token'] as String,
      url: json['url'] as String,
      roomName: json['room_name'] as String?,
    );
  }
}

/// Paginated call history response
class CallHistoryDto {
  final List<CallDto> calls;
  final int total;
  final int page;
  final int perPage;

  const CallHistoryDto({
    required this.calls,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory CallHistoryDto.fromJson(Map<String, dynamic> json) {
    final items = json['calls'] ?? json['data'] ?? json['items'] ?? [];
    return CallHistoryDto(
      calls: (items as List<dynamic>)
          .map((e) => CallDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
