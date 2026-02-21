// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppNotificationAdapter extends TypeAdapter<AppNotification> {
  @override
  final int typeId = 28;

  @override
  AppNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppNotification(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as NotificationType,
      title: fields[3] as String,
      body: fields[4] as String,
      data: (fields[5] as Map).cast<String, dynamic>(),
      isRead: fields[6] as bool,
      channelId: fields[7] as String?,
      messageId: fields[8] as String?,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AppNotification obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.body)
      ..writeByte(5)
      ..write(obj.data)
      ..writeByte(6)
      ..write(obj.isRead)
      ..writeByte(7)
      ..write(obj.channelId)
      ..writeByte(8)
      ..write(obj.messageId)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 29;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.message;
      case 1:
        return NotificationType.mention;
      case 2:
        return NotificationType.reaction;
      case 3:
        return NotificationType.threadReply;
      case 4:
        return NotificationType.channelInvite;
      case 5:
        return NotificationType.system;
      default:
        return NotificationType.message;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.message:
        writer.writeByte(0);
        break;
      case NotificationType.mention:
        writer.writeByte(1);
        break;
      case NotificationType.reaction:
        writer.writeByte(2);
        break;
      case NotificationType.threadReply:
        writer.writeByte(3);
        break;
      case NotificationType.channelInvite:
        writer.writeByte(4);
        break;
      case NotificationType.system:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
