import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/file_repository.dart';
import 'file_event.dart';
import 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileRepository _repository;

  FileBloc({FileRepository? repository})
      : _repository = repository ?? FileRepository(),
        super(const FileState()) {
    on<FileLoad>(_onLoad);
    on<FileDelete>(_onDelete);
    on<FileShare>(_onShare);
    on<FileSelectPreview>(_onSelectPreview);
    on<FileClearError>(_onClearError);
  }

  Future<void> _onLoad(FileLoad event, Emitter<FileState> emit) async {
    emit(state.copyWith(status: FileStatus.loading));
    try {
      final files = await _repository.getFiles(
        workspaceId: event.workspaceId,
        channelId: event.channelId,
        page: event.page,
      );
      emit(state.copyWith(status: FileStatus.loaded, files: files));
    } catch (e) {
      debugPrint('FileBloc: Error loading files: $e');
      emit(state.copyWith(status: FileStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDelete(FileDelete event, Emitter<FileState> emit) async {
    try {
      await _repository.deleteFile(event.fileId);
      final files = state.files.where((f) => f.id != event.fileId).toList();
      emit(state.copyWith(files: files));
    } catch (e) {
      debugPrint('FileBloc: Error deleting file: $e');
      emit(state.copyWith(status: FileStatus.error, error: e.toString()));
    }
  }

  Future<void> _onShare(FileShare event, Emitter<FileState> emit) async {
    try {
      await _repository.shareFile(event.fileId, event.data);
    } catch (e) {
      debugPrint('FileBloc: Error sharing file: $e');
      emit(state.copyWith(status: FileStatus.error, error: e.toString()));
    }
  }

  Future<void> _onSelectPreview(FileSelectPreview event, Emitter<FileState> emit) async {
    try {
      final file = await _repository.getFile(event.fileId);
      emit(state.copyWith(previewFile: file));
    } catch (e) {
      debugPrint('FileBloc: Error loading file preview: $e');
      emit(state.copyWith(status: FileStatus.error, error: e.toString()));
    }
  }

  void _onClearError(FileClearError event, Emitter<FileState> emit) {
    emit(state.copyWith(status: FileStatus.loaded, error: null));
  }
}
