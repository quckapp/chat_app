// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuditLogEntryAdapter extends TypeAdapter<AuditLogEntry> {
  @override
  final int typeId = 40;

  @override
  AuditLogEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditLogEntry(
      id: fields[0] as String,
      action: fields[1] as String,
      userId: fields[2] as String,
      targetType: fields[3] as String,
      targetId: fields[4] as String,
      details: fields[5] as String?,
      ipAddress: fields[6] as String?,
      userAgent: fields[7] as String?,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AuditLogEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.action)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.targetType)
      ..writeByte(4)
      ..write(obj.targetId)
      ..writeByte(5)
      ..write(obj.details)
      ..writeByte(6)
      ..write(obj.ipAddress)
      ..writeByte(7)
      ..write(obj.userAgent)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditLogEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
