import 'package:json_annotation/json_annotation.dart';

part 'ml_dto.g.dart';

@JsonSerializable()
class MLPredictionDto {
  final String type;
  final Map<String, dynamic> input;
  final Map<String, dynamic> output;
  final double confidence;

  const MLPredictionDto({
    required this.type,
    required this.input,
    required this.output,
    this.confidence = 0.0,
  });

  factory MLPredictionDto.fromJson(Map<String, dynamic> json) =>
      _$MLPredictionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MLPredictionDtoToJson(this);
}

@JsonSerializable()
class SmartReplyDto {
  final List<String> suggestions;

  const SmartReplyDto({
    this.suggestions = const [],
  });

  factory SmartReplyDto.fromJson(Map<String, dynamic> json) =>
      _$SmartReplyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SmartReplyDtoToJson(this);
}
