// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferenceAdapter
    extends TypeAdapter<NotificationPreference> {
  @override
  final int typeId = 30;

  @override
  NotificationPreference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreference(
      id: fields[0] as String,
      userId: fields[1] as String,
      channelId: fields[2] as String?,
      muteUntil: fields[3] as DateTime?,
      pushEnabled: fields[4] as bool,
      emailEnabled: fields[5] as bool,
      soundEnabled: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreference obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.channelId)
      ..writeByte(3)
      ..write(obj.muteUntil)
      ..writeByte(4)
      ..write(obj.pushEnabled)
      ..writeByte(5)
      ..write(obj.emailEnabled)
      ..writeByte(6)
      ..write(obj.soundEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
