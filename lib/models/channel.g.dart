// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelAdapter extends TypeAdapter<Channel> {
  @override
  final int typeId = 14;

  @override
  Channel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Channel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      type: fields[3] as ChannelType,
      workspaceId: fields[4] as String,
      createdBy: fields[5] as String,
      topic: fields[6] as String?,
      avatar: fields[7] as String?,
      memberCount: fields[8] as int,
      isArchived: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Channel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.workspaceId)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.topic)
      ..writeByte(7)
      ..write(obj.avatar)
      ..writeByte(8)
      ..write(obj.memberCount)
      ..writeByte(9)
      ..write(obj.isArchived)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelMemberAdapter extends TypeAdapter<ChannelMember> {
  @override
  final int typeId = 16;

  @override
  ChannelMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelMember(
      userId: fields[0] as String,
      channelId: fields[1] as String,
      role: fields[2] as String,
      displayName: fields[3] as String?,
      avatar: fields[4] as String?,
      joinedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChannelMember obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.avatar)
      ..writeByte(5)
      ..write(obj.joinedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelTypeAdapter extends TypeAdapter<ChannelType> {
  @override
  final int typeId = 15;

  @override
  ChannelType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChannelType.public;
      case 1:
        return ChannelType.private;
      case 2:
        return ChannelType.dm;
      default:
        return ChannelType.public;
    }
  }

  @override
  void write(BinaryWriter writer, ChannelType obj) {
    switch (obj) {
      case ChannelType.public:
        writer.writeByte(0);
        break;
      case ChannelType.private:
        writer.writeByte(1);
        break;
      case ChannelType.dm:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
