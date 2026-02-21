// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PollOptionAdapter extends TypeAdapter<PollOption> {
  @override
  final int typeId = 35;

  @override
  PollOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollOption(
      id: fields[0] as String,
      text: fields[1] as String,
      voteCount: fields[2] as int,
      voterIds: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PollOption obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.voteCount)
      ..writeByte(3)
      ..write(obj.voterIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PollAdapter extends TypeAdapter<Poll> {
  @override
  final int typeId = 34;

  @override
  Poll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Poll(
      id: fields[0] as String,
      channelId: fields[1] as String,
      createdBy: fields[2] as String,
      question: fields[3] as String,
      options: (fields[4] as List).cast<PollOption>(),
      isAnonymous: fields[5] as bool,
      allowMultiple: fields[6] as bool,
      expiresAt: fields[7] as DateTime?,
      totalVotes: fields[8] as int,
      createdAt: fields[9] as DateTime,
      isClosed: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Poll obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.channelId)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.question)
      ..writeByte(4)
      ..write(obj.options)
      ..writeByte(5)
      ..write(obj.isAnonymous)
      ..writeByte(6)
      ..write(obj.allowMultiple)
      ..writeByte(7)
      ..write(obj.expiresAt)
      ..writeByte(8)
      ..write(obj.totalVotes)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.isClosed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
