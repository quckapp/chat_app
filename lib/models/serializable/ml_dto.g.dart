// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MLPredictionDto _$MLPredictionDtoFromJson(Map<String, dynamic> json) =>
    MLPredictionDto(
      type: json['type'] as String,
      input: json['input'] as Map<String, dynamic>,
      output: json['output'] as Map<String, dynamic>,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$MLPredictionDtoToJson(MLPredictionDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'input': instance.input,
      'output': instance.output,
      'confidence': instance.confidence,
    };

SmartReplyDto _$SmartReplyDtoFromJson(Map<String, dynamic> json) =>
    SmartReplyDto(
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SmartReplyDtoToJson(SmartReplyDto instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
    };
