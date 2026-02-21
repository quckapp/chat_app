// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledMessageAdapter extends TypeAdapter<ScheduledMessage> {
  @override
  final int typeId = 36;

  @override
  ScheduledMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledMessage(
      id: fields[0] as String,
      channelId: fields[1] as String,
      content: fields[2] as String,
      scheduledAt: fields[3] as DateTime,
      createdBy: fields[4] as String,
      status: fields[5] as String,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledMessage obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.scheduledAt)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
