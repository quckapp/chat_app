// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 24;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      id: fields[0] as String,
      userId: fields[1] as String,
      messageId: fields[2] as String,
      channelId: fields[3] as String,
      note: fields[4] as String?,
      remindAt: fields[5] as DateTime,
      status: fields[6] as ReminderStatus,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.messageId)
      ..writeByte(3)
      ..write(obj.channelId)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.remindAt)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderStatusAdapter extends TypeAdapter<ReminderStatus> {
  @override
  final int typeId = 25;

  @override
  ReminderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderStatus.pending;
      case 1:
        return ReminderStatus.snoozed;
      case 2:
        return ReminderStatus.completed;
      case 3:
        return ReminderStatus.dismissed;
      default:
        return ReminderStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderStatus obj) {
    switch (obj) {
      case ReminderStatus.pending:
        writer.writeByte(0);
        break;
      case ReminderStatus.snoozed:
        writer.writeByte(1);
        break;
      case ReminderStatus.completed:
        writer.writeByte(2);
        break;
      case ReminderStatus.dismissed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
