import 'package:json_annotation/json_annotation.dart';

part 'realtime_rest_dto.g.dart';

@JsonSerializable()
class RealtimeDeviceDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'device_type')
  final String deviceType;
  @JsonKey(name: 'connected_at')
  final DateTime? connectedAt;

  const RealtimeDeviceDto({
    required this.id,
    required this.userId,
    required this.deviceType,
    this.connectedAt,
  });

  factory RealtimeDeviceDto.fromJson(Map<String, dynamic> json) =>
      _$RealtimeDeviceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RealtimeDeviceDtoToJson(this);
}

@JsonSerializable()
class SignalingDto {
  final String type;
  final Map<String, dynamic> payload;
  @JsonKey(name: 'target_user_id')
  final String targetUserId;

  const SignalingDto({
    required this.type,
    required this.payload,
    required this.targetUserId,
  });

  factory SignalingDto.fromJson(Map<String, dynamic> json) => _$SignalingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SignalingDtoToJson(this);
}
