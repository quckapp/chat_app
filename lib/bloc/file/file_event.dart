import 'package:equatable/equatable.dart';
import '../../models/serializable/file_dto.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();
  @override
  List<Object?> get props => [];
}

class FileLoad extends FileEvent {
  final String? workspaceId;
  final String? channelId;
  final int page;

  const FileLoad({this.workspaceId, this.channelId, this.page = 1});

  @override
  List<Object?> get props => [workspaceId, channelId, page];
}

class FileDelete extends FileEvent {
  final String fileId;
  const FileDelete({required this.fileId});
  @override
  List<Object?> get props => [fileId];
}

class FileShare extends FileEvent {
  final String fileId;
  final FileShareDto data;
  const FileShare({required this.fileId, required this.data});
  @override
  List<Object?> get props => [fileId, data];
}

class FileSelectPreview extends FileEvent {
  final String fileId;
  const FileSelectPreview({required this.fileId});
  @override
  List<Object?> get props => [fileId];
}

class FileClearError extends FileEvent {
  const FileClearError();
}
