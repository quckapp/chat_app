// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'huddle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HuddleAdapter extends TypeAdapter<Huddle> {
  @override
  final int typeId = 32;

  @override
  Huddle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Huddle(
      id: fields[0] as String,
      channelId: fields[1] as String,
      createdBy: fields[2] as String,
      status: fields[3] as HuddleStatus,
      participantIds: (fields[4] as List).cast<String>(),
      maxParticipants: fields[5] as int,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Huddle obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.participantIds)
      ..writeByte(5)
      ..write(obj.maxParticipants)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HuddleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HuddleStatusAdapter extends TypeAdapter<HuddleStatus> {
  @override
  final int typeId = 33;

  @override
  HuddleStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HuddleStatus.active;
      case 1:
        return HuddleStatus.ended;
      default:
        return HuddleStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, HuddleStatus obj) {
    switch (obj) {
      case HuddleStatus.active:
        writer.writeByte(0);
        break;
      case HuddleStatus.ended:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HuddleStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
