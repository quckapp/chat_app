import 'package:equatable/equatable.dart';
import '../../models/file_info.dart';

enum FileStatus { initial, loading, loaded, error }

class FileState extends Equatable {
  final FileStatus status;
  final List<FileInfo> files;
  final FileInfo? previewFile;
  final String? error;

  const FileState({
    this.status = FileStatus.initial,
    this.files = const [],
    this.previewFile,
    this.error,
  });

  bool get isLoading => status == FileStatus.loading;
  bool get hasError => status == FileStatus.error && error != null;

  FileState copyWith({
    FileStatus? status,
    List<FileInfo>? files,
    FileInfo? previewFile,
    String? error,
  }) {
    return FileState(
      status: status ?? this.status,
      files: files ?? this.files,
      previewFile: previewFile ?? this.previewFile,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, files, previewFile, error];
}
