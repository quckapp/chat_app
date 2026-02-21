// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThreadAdapter extends TypeAdapter<Thread> {
  @override
  final int typeId = 17;

  @override
  Thread read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Thread(
      id: fields[0] as String,
      channelId: fields[1] as String,
      parentMessageId: fields[2] as String,
      createdBy: fields[3] as String,
      replyCount: fields[4] as int,
      participantCount: fields[5] as int,
      lastReplyAt: fields[6] as DateTime?,
      isFollowing: fields[7] as bool,
      isResolved: fields[8] as bool,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Thread obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.parentMessageId)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.replyCount)
      ..writeByte(5)
      ..write(obj.participantCount)
      ..writeByte(6)
      ..write(obj.lastReplyAt)
      ..writeByte(7)
      ..write(obj.isFollowing)
      ..writeByte(8)
      ..write(obj.isResolved)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThreadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThreadReplyAdapter extends TypeAdapter<ThreadReply> {
  @override
  final int typeId = 18;

  @override
  ThreadReply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThreadReply(
      id: fields[0] as String,
      threadId: fields[1] as String,
      userId: fields[2] as String,
      content: fields[3] as String,
      displayName: fields[4] as String?,
      avatar: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ThreadReply obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.threadId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.displayName)
      ..writeByte(5)
      ..write(obj.avatar)
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
      other is ThreadReplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
