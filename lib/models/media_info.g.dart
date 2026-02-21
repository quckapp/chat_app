// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaInfoAdapter extends TypeAdapter<MediaInfo> {
  @override
  final int typeId = 21;

  @override
  MediaInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaInfo(
      id: fields[0] as String,
      fileId: fields[1] as String,
      mediaType: fields[2] as String,
      width: fields[3] as int?,
      height: fields[4] as int?,
      duration: fields[5] as int?,
      thumbnailUrl: fields[6] as String?,
      url: fields[7] as String,
      uploadedBy: fields[8] as String?,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MediaInfo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileId)
      ..writeByte(2)
      ..write(obj.mediaType)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.thumbnailUrl)
      ..writeByte(7)
      ..write(obj.url)
      ..writeByte(8)
      ..write(obj.uploadedBy)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
