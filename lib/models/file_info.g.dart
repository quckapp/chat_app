// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileInfoAdapter extends TypeAdapter<FileInfo> {
  @override
  final int typeId = 19;

  @override
  FileInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileInfo(
      id: fields[0] as String,
      name: fields[1] as String,
      mimeType: fields[2] as String?,
      size: fields[3] as int,
      type: fields[4] as FileType,
      url: fields[5] as String,
      thumbnailUrl: fields[6] as String?,
      uploadedBy: fields[7] as String,
      workspaceId: fields[8] as String?,
      channelId: fields[9] as String?,
      createdAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FileInfo obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mimeType)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.thumbnailUrl)
      ..writeByte(7)
      ..write(obj.uploadedBy)
      ..writeByte(8)
      ..write(obj.workspaceId)
      ..writeByte(9)
      ..write(obj.channelId)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FileTypeAdapter extends TypeAdapter<FileType> {
  @override
  final int typeId = 20;

  @override
  FileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FileType.image;
      case 1:
        return FileType.video;
      case 2:
        return FileType.audio;
      case 3:
        return FileType.document;
      case 4:
        return FileType.archive;
      case 5:
        return FileType.other;
      default:
        return FileType.image;
    }
  }

  @override
  void write(BinaryWriter writer, FileType obj) {
    switch (obj) {
      case FileType.image:
        writer.writeByte(0);
        break;
      case FileType.video:
        writer.writeByte(1);
        break;
      case FileType.audio:
        writer.writeByte(2);
        break;
      case FileType.document:
        writer.writeByte(3);
        break;
      case FileType.archive:
        writer.writeByte(4);
        break;
      case FileType.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
