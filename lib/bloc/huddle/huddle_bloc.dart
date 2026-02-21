import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/serializable/huddle_dto.dart';
import '../../repositories/huddle_repository.dart';
import 'huddle_event.dart';
import 'huddle_state.dart';

/// BLoC for managing huddle operations
class HuddleBloc extends Bloc<HuddleEvent, HuddleState> {
  final HuddleRepository _repository;

  HuddleBloc({HuddleRepository? repository})
      : _repository = repository ?? HuddleRepository(),
        super(const HuddleState()) {
    on<HuddleLoad>(_onLoad);
    on<HuddleCreate>(_onCreate);
    on<HuddleJoin>(_onJoin);
    on<HuddleLeave>(_onLeave);
    on<HuddleClearError>(_onClearError);
  }

  Future<void> _onLoad(HuddleLoad event, Emitter<HuddleState> emit) async {
    emit(state.copyWith(status: HuddleStatus.loading));
    try {
      final huddles = await _repository.getActiveHuddles(channelId: event.channelId);
      emit(state.copyWith(status: HuddleStatus.loaded, huddles: huddles));
    } catch (e) {
      debugPrint('HuddleBloc: Error loading huddles: $e');
      emit(state.copyWith(status: HuddleStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(HuddleCreate event, Emitter<HuddleState> emit) async {
    emit(state.copyWith(status: HuddleStatus.loading));
    try {
      final huddle = await _repository.createHuddle(
        CreateHuddleDto(channelId: event.channelId),
      );
      final updated = [...state.huddles, huddle];
      emit(state.copyWith(
        status: HuddleStatus.loaded,
        huddles: updated,
        activeHuddle: huddle,
      ));
    } catch (e) {
      debugPrint('HuddleBloc: Error creating huddle: $e');
      emit(state.copyWith(status: HuddleStatus.error, error: e.toString()));
    }
  }

  Future<void> _onJoin(HuddleJoin event, Emitter<HuddleState> emit) async {
    emit(state.copyWith(status: HuddleStatus.loading));
    try {
      final huddle = await _repository.joinHuddle(event.huddleId);
      final huddles = state.huddles
          .map((h) => h.id == event.huddleId ? huddle : h)
          .toList();
      emit(state.copyWith(
        status: HuddleStatus.loaded,
        huddles: huddles,
        activeHuddle: huddle,
      ));
    } catch (e) {
      debugPrint('HuddleBloc: Error joining huddle: $e');
      emit(state.copyWith(status: HuddleStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLeave(HuddleLeave event, Emitter<HuddleState> emit) async {
    try {
      await _repository.leaveHuddle(event.huddleId);
      emit(state.copyWith(clearActiveHuddle: true));
      // Refresh huddles list
      add(HuddleLoad());
    } catch (e) {
      debugPrint('HuddleBloc: Error leaving huddle: $e');
      emit(state.copyWith(status: HuddleStatus.error, error: e.toString()));
    }
  }

  void _onClearError(HuddleClearError event, Emitter<HuddleState> emit) {
    emit(state.copyWith(status: HuddleStatus.loaded, error: null));
  }
}
