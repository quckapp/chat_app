import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/channel.dart';
import '../../models/pin.dart';
import '../../repositories/channel_repository.dart';
import 'channel_event.dart';
import 'channel_state.dart';

/// BLoC for managing channel operations
class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository _repository;

  ChannelBloc({ChannelRepository? repository})
      : _repository = repository ?? ChannelRepository(),
        super(const ChannelState()) {
    on<ChannelLoad>(_onLoad);
    on<ChannelCreate>(_onCreate);
    on<ChannelUpdate>(_onUpdate);
    on<ChannelDelete>(_onDelete);
    on<ChannelSelectActive>(_onSelectActive);
    on<ChannelJoin>(_onJoin);
    on<ChannelLeave>(_onLeave);
    on<ChannelLoadMembers>(_onLoadMembers);
    on<ChannelAddMember>(_onAddMember);
    on<ChannelRemoveMember>(_onRemoveMember);
    on<ChannelLoadPins>(_onLoadPins);
    on<ChannelPinMessage>(_onPinMessage);
    on<ChannelUnpinMessage>(_onUnpinMessage);
    on<ChannelClearError>(_onClearError);
  }

  Future<void> _onLoad(ChannelLoad event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final channels = await _repository.getChannels(
        event.workspaceId,
        page: event.page,
        perPage: event.perPage,
      );
      emit(state.copyWith(status: ChannelStatus.loaded, channels: channels));
    } catch (e) {
      debugPrint('ChannelBloc: Error loading channels: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(ChannelCreate event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final channel = await _repository.createChannel(event.data);
      final updated = [...state.channels, channel];
      emit(state.copyWith(status: ChannelStatus.loaded, channels: updated));
    } catch (e) {
      debugPrint('ChannelBloc: Error creating channel: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUpdate(ChannelUpdate event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final updated = await _repository.updateChannel(event.channelId, event.data);
      final channels = state.channels
          .map((c) => c.id == event.channelId ? updated : c)
          .toList();
      final activeChannel =
          state.activeChannel?.id == event.channelId ? updated : state.activeChannel;
      emit(state.copyWith(
        status: ChannelStatus.loaded,
        channels: channels,
        activeChannel: activeChannel,
      ));
    } catch (e) {
      debugPrint('ChannelBloc: Error updating channel: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDelete(ChannelDelete event, Emitter<ChannelState> emit) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      await _repository.deleteChannel(event.channelId);
      final channels = state.channels.where((c) => c.id != event.channelId).toList();
      final activeChannel =
          state.activeChannel?.id == event.channelId ? null : state.activeChannel;
      emit(state.copyWith(
        status: ChannelStatus.loaded,
        channels: channels,
        activeChannel: activeChannel,
      ));
    } catch (e) {
      debugPrint('ChannelBloc: Error deleting channel: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onSelectActive(ChannelSelectActive event, Emitter<ChannelState> emit) async {
    try {
      final channel = await _repository.getChannel(event.channelId);
      emit(state.copyWith(activeChannel: channel));
    } catch (e) {
      debugPrint('ChannelBloc: Error selecting channel: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onJoin(ChannelJoin event, Emitter<ChannelState> emit) async {
    try {
      await _repository.joinChannel(event.channelId);
      // Refresh channels list
      if (state.channels.isNotEmpty) {
        final workspaceId = state.channels.first.workspaceId;
        final channels = await _repository.getChannels(workspaceId);
        emit(state.copyWith(channels: channels));
      }
    } catch (e) {
      debugPrint('ChannelBloc: Error joining channel: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLeave(ChannelLeave event, Emitter<ChannelState> emit) async {
    try {
      await _repository.leaveChannel(event.channelId);
      final channels = state.channels.where((c) => c.id != event.channelId).toList();
      final activeChannel =
          state.activeChannel?.id == event.channelId ? null : state.activeChannel;
      emit(state.copyWith(channels: channels, activeChannel: activeChannel));
    } catch (e) {
      debugPrint('ChannelBloc: Error leaving channel: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadMembers(ChannelLoadMembers event, Emitter<ChannelState> emit) async {
    try {
      final membersList = await _repository.getMembers(event.channelId);
      final updatedMembers = Map<String, List<ChannelMember>>.from(state.members);
      updatedMembers[event.channelId] = membersList;
      emit(state.copyWith(members: updatedMembers));
    } catch (e) {
      debugPrint('ChannelBloc: Error loading members: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onAddMember(ChannelAddMember event, Emitter<ChannelState> emit) async {
    try {
      await _repository.addMember(event.channelId, event.userId);
      // Refresh members
      add(ChannelLoadMembers(channelId: event.channelId));
    } catch (e) {
      debugPrint('ChannelBloc: Error adding member: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onRemoveMember(ChannelRemoveMember event, Emitter<ChannelState> emit) async {
    try {
      await _repository.removeMember(event.channelId, event.userId);
      final updatedMembers = Map<String, List<ChannelMember>>.from(state.members);
      updatedMembers[event.channelId] =
          (updatedMembers[event.channelId] ?? []).where((m) => m.userId != event.userId).toList();
      emit(state.copyWith(members: updatedMembers));
    } catch (e) {
      debugPrint('ChannelBloc: Error removing member: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadPins(ChannelLoadPins event, Emitter<ChannelState> emit) async {
    try {
      final pinsList = await _repository.getPins(event.channelId);
      final updatedPins = Map<String, List<PinnedMessage>>.from(state.pins);
      updatedPins[event.channelId] = pinsList;
      emit(state.copyWith(pins: updatedPins));
    } catch (e) {
      debugPrint('ChannelBloc: Error loading pins: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onPinMessage(ChannelPinMessage event, Emitter<ChannelState> emit) async {
    try {
      await _repository.pinMessage(event.channelId, event.messageId);
      // Refresh pins
      add(ChannelLoadPins(channelId: event.channelId));
    } catch (e) {
      debugPrint('ChannelBloc: Error pinning message: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUnpinMessage(ChannelUnpinMessage event, Emitter<ChannelState> emit) async {
    try {
      await _repository.unpinMessage(event.channelId, event.pinId);
      final updatedPins = Map<String, List<PinnedMessage>>.from(state.pins);
      updatedPins[event.channelId] =
          (updatedPins[event.channelId] ?? []).where((p) => p.id != event.pinId).toList();
      emit(state.copyWith(pins: updatedPins));
    } catch (e) {
      debugPrint('ChannelBloc: Error unpinning message: $e');
      emit(state.copyWith(status: ChannelStatus.error, error: e.toString()));
    }
  }

  void _onClearError(ChannelClearError event, Emitter<ChannelState> emit) {
    emit(state.copyWith(status: ChannelStatus.loaded, error: null));
  }
}
