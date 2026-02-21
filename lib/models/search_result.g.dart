// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchResultAdapter extends TypeAdapter<SearchResult> {
  @override
  final int typeId = 26;

  @override
  SearchResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchResult(
      id: fields[0] as String,
      type: fields[1] as SearchResultType,
      title: fields[2] as String,
      snippet: fields[3] as String?,
      channelId: fields[4] as String?,
      channelName: fields[5] as String?,
      userId: fields[6] as String?,
      userName: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
      score: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SearchResult obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.snippet)
      ..writeByte(4)
      ..write(obj.channelId)
      ..writeByte(5)
      ..write(obj.channelName)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.userName)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SearchResultTypeAdapter extends TypeAdapter<SearchResultType> {
  @override
  final int typeId = 27;

  @override
  SearchResultType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SearchResultType.message;
      case 1:
        return SearchResultType.user;
      case 2:
        return SearchResultType.channel;
      case 3:
        return SearchResultType.file;
      default:
        return SearchResultType.message;
    }
  }

  @override
  void write(BinaryWriter writer, SearchResultType obj) {
    switch (obj) {
      case SearchResultType.message:
        writer.writeByte(0);
        break;
      case SearchResultType.user:
        writer.writeByte(1);
        break;
      case SearchResultType.channel:
        writer.writeByte(2);
        break;
      case SearchResultType.file:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
