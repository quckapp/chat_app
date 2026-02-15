// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallRecordAdapter extends TypeAdapter<CallRecord> {
  @override
  final int typeId = 10;

  @override
  CallRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallRecord(
      id: fields[0] as String,
      recipientId: fields[1] as String,
      recipientName: fields[2] as String,
      recipientAvatar: fields[3] as String?,
      type: fields[4] as CallType,
      status: fields[5] as CallStatus,
      timestamp: fields[6] as DateTime,
      durationSeconds: fields[7] as int?,
      isOutgoing: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CallRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recipientId)
      ..writeByte(2)
      ..write(obj.recipientName)
      ..writeByte(3)
      ..write(obj.recipientAvatar)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.durationSeconds)
      ..writeByte(8)
      ..write(obj.isOutgoing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CallTypeAdapter extends TypeAdapter<CallType> {
  @override
  final int typeId = 8;

  @override
  CallType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CallType.voice;
      case 1:
        return CallType.video;
      default:
        return CallType.voice;
    }
  }

  @override
  void write(BinaryWriter writer, CallType obj) {
    switch (obj) {
      case CallType.voice:
        writer.writeByte(0);
        break;
      case CallType.video:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CallStatusAdapter extends TypeAdapter<CallStatus> {
  @override
  final int typeId = 9;

  @override
  CallStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CallStatus.completed;
      case 1:
        return CallStatus.missed;
      case 2:
        return CallStatus.declined;
      case 3:
        return CallStatus.ongoing;
      default:
        return CallStatus.completed;
    }
  }

  @override
  void write(BinaryWriter writer, CallStatus obj) {
    switch (obj) {
      case CallStatus.completed:
        writer.writeByte(0);
        break;
      case CallStatus.missed:
        writer.writeByte(1);
        break;
      case CallStatus.declined:
        writer.writeByte(2);
        break;
      case CallStatus.ongoing:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
