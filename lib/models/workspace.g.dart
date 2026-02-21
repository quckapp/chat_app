// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkspaceAdapter extends TypeAdapter<Workspace> {
  @override
  final int typeId = 11;

  @override
  Workspace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workspace(
      id: fields[0] as String,
      name: fields[1] as String,
      slug: fields[2] as String,
      description: fields[3] as String?,
      iconUrl: fields[4] as String?,
      ownerId: fields[5] as String,
      plan: fields[6] as String,
      isActive: fields[7] as bool,
      memberCount: fields[8] as int,
      channelCount: fields[9] as int,
      myRole: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Workspace obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.iconUrl)
      ..writeByte(5)
      ..write(obj.ownerId)
      ..writeByte(6)
      ..write(obj.plan)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.memberCount)
      ..writeByte(9)
      ..write(obj.channelCount)
      ..writeByte(10)
      ..write(obj.myRole)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkspaceMemberAdapter extends TypeAdapter<WorkspaceMember> {
  @override
  final int typeId = 12;

  @override
  WorkspaceMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkspaceMember(
      id: fields[0] as String,
      workspaceId: fields[1] as String,
      userId: fields[2] as String,
      role: fields[3] as WorkspaceRole,
      displayName: fields[4] as String?,
      avatar: fields[5] as String?,
      title: fields[6] as String?,
      isActive: fields[7] as bool,
      joinedAt: fields[8] as DateTime,
      invitedBy: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkspaceMember obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workspaceId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.displayName)
      ..writeByte(5)
      ..write(obj.avatar)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.joinedAt)
      ..writeByte(9)
      ..write(obj.invitedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkspaceRoleAdapter extends TypeAdapter<WorkspaceRole> {
  @override
  final int typeId = 13;

  @override
  WorkspaceRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WorkspaceRole.owner;
      case 1:
        return WorkspaceRole.admin;
      case 2:
        return WorkspaceRole.member;
      case 3:
        return WorkspaceRole.guest;
      default:
        return WorkspaceRole.owner;
    }
  }

  @override
  void write(BinaryWriter writer, WorkspaceRole obj) {
    switch (obj) {
      case WorkspaceRole.owner:
        writer.writeByte(0);
        break;
      case WorkspaceRole.admin:
        writer.writeByte(1);
        break;
      case WorkspaceRole.member:
        writer.writeByte(2);
        break;
      case WorkspaceRole.guest:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
