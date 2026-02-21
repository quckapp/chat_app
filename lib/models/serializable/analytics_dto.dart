import 'package:json_annotation/json_annotation.dart';

part 'analytics_dto.g.dart';

@JsonSerializable()
class AnalyticsEventDto {
  final String event;
  final Map<String, dynamic> properties;
  final DateTime? timestamp;

  const AnalyticsEventDto({
    required this.event,
    this.properties = const {},
    this.timestamp,
  });

  factory AnalyticsEventDto.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsEventDtoToJson(this);
}

@JsonSerializable()
class AnalyticsResultDto {
  final String metric;
  final double value;
  final String period;

  const AnalyticsResultDto({
    required this.metric,
    required this.value,
    required this.period,
  });

  factory AnalyticsResultDto.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsResultDtoToJson(this);
}
