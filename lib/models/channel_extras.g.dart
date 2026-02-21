// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_extras.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelLinkAdapter extends TypeAdapter<ChannelLink> {
  @override
  final int typeId = 37;

  @override
  ChannelLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelLink(
      id: fields[0] as String,
      channelId: fields[1] as String,
      url: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String?,
      createdBy: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChannelLink obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelTabAdapter extends TypeAdapter<ChannelTab> {
  @override
  final int typeId = 38;

  @override
  ChannelTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelTab(
      id: fields[0] as String,
      channelId: fields[1] as String,
      name: fields[2] as String,
      type: fields[3] as String,
      url: fields[4] as String,
      createdBy: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChannelTab obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelTemplateAdapter extends TypeAdapter<ChannelTemplate> {
  @override
  final int typeId = 39;

  @override
  ChannelTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelTemplate(
      id: fields[0] as String,
      channelId: fields[1] as String,
      name: fields[2] as String,
      content: fields[3] as String,
      createdBy: fields[4] as String,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChannelTemplate obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
