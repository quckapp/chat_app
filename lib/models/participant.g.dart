// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParticipantAdapter extends TypeAdapter<Participant> {
  @override
  final int typeId = 2;

  @override
  Participant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Participant(
      id: fields[0] as String,
      username: fields[1] as String?,
      displayName: fields[2] as String?,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      avatar: fields[5] as String?,
      role: fields[6] as ParticipantRole,
      joinedAt: fields[7] as DateTime,
      phoneNumber: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Participant obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.avatar)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.joinedAt)
      ..writeByte(8)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ParticipantRoleAdapter extends TypeAdapter<ParticipantRole> {
  @override
  final int typeId = 6;

  @override
  ParticipantRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ParticipantRole.owner;
      case 1:
        return ParticipantRole.admin;
      case 2:
        return ParticipantRole.member;
      default:
        return ParticipantRole.owner;
    }
  }

  @override
  void write(BinaryWriter writer, ParticipantRole obj) {
    switch (obj) {
      case ParticipantRole.owner:
        writer.writeByte(0);
        break;
      case ParticipantRole.admin:
        writer.writeByte(1);
        break;
      case ParticipantRole.member:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
