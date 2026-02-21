import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/poll_repository.dart';
import '../../repositories/scheduled_message_repository.dart';
import '../../repositories/channel_extras_repository.dart';
import 'channel_extras_event.dart';
import 'channel_extras_state.dart';

/// BLoC for managing channel extras (polls, scheduled messages, links, tabs, templates)
class ChannelExtrasBloc extends Bloc<ChannelExtrasEvent, ChannelExtrasState> {
  final PollRepository _pollRepository;
  final ScheduledMessageRepository _scheduledMessageRepository;
  final ChannelExtrasRepository _channelExtrasRepository;

  ChannelExtrasBloc({
    PollRepository? pollRepository,
    ScheduledMessageRepository? scheduledMessageRepository,
    ChannelExtrasRepository? channelExtrasRepository,
  })  : _pollRepository = pollRepository ?? PollRepository(),
        _scheduledMessageRepository =
            scheduledMessageRepository ?? ScheduledMessageRepository(),
        _channelExtrasRepository =
            channelExtrasRepository ?? ChannelExtrasRepository(),
        super(const ChannelExtrasState()) {
    on<LoadPolls>(_onLoadPolls);
    on<CreatePoll>(_onCreatePoll);
    on<VotePoll>(_onVotePoll);
    on<ClosePoll>(_onClosePoll);
    on<LoadScheduledMessages>(_onLoadScheduledMessages);
    on<CreateScheduledMessage>(_onCreateScheduledMessage);
    on<CancelScheduledMessage>(_onCancelScheduledMessage);
    on<LoadLinks>(_onLoadLinks);
    on<CreateLink>(_onCreateLink);
    on<DeleteLink>(_onDeleteLink);
    on<LoadTabs>(_onLoadTabs);
    on<CreateTab>(_onCreateTab);
    on<DeleteTab>(_onDeleteTab);
    on<LoadTemplates>(_onLoadTemplates);
    on<CreateTemplate>(_onCreateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
    on<ClearChannelExtrasError>(_onClearError);
  }

  // --- Poll Handlers ---

  Future<void> _onLoadPolls(LoadPolls event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final polls = await _pollRepository.getPolls(event.channelId);
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, polls: polls));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error loading polls: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreatePoll(CreatePoll event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final poll = await _pollRepository.createPoll(event.channelId, event.data);
      final updated = [...state.polls, poll];
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, polls: updated));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error creating poll: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onVotePoll(VotePoll event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final updatedPoll =
          await _pollRepository.votePoll(event.channelId, event.pollId, event.data);
      final polls =
          state.polls.map((p) => p.id == event.pollId ? updatedPoll : p).toList();
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, polls: polls));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error voting on poll: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onClosePoll(ClosePoll event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final closedPoll =
          await _pollRepository.closePoll(event.channelId, event.pollId);
      final polls =
          state.polls.map((p) => p.id == event.pollId ? closedPoll : p).toList();
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, polls: polls));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error closing poll: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  // --- Scheduled Message Handlers ---

  Future<void> _onLoadScheduledMessages(
      LoadScheduledMessages event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final messages =
          await _scheduledMessageRepository.getScheduledMessages(event.channelId);
      emit(state.copyWith(
          status: ChannelExtrasStatus.loaded, scheduledMessages: messages));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error loading scheduled messages: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateScheduledMessage(
      CreateScheduledMessage event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final message = await _scheduledMessageRepository.createScheduledMessage(
          event.channelId, event.data);
      final updated = [...state.scheduledMessages, message];
      emit(state.copyWith(
          status: ChannelExtrasStatus.loaded, scheduledMessages: updated));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error creating scheduled message: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCancelScheduledMessage(
      CancelScheduledMessage event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      await _scheduledMessageRepository.cancelScheduledMessage(
          event.channelId, event.messageId);
      final messages = state.scheduledMessages
          .where((m) => m.id != event.messageId)
          .toList();
      emit(state.copyWith(
          status: ChannelExtrasStatus.loaded, scheduledMessages: messages));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error cancelling scheduled message: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  // --- Link Handlers ---

  Future<void> _onLoadLinks(LoadLinks event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final links = await _channelExtrasRepository.getLinks(event.channelId);
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, links: links));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error loading links: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateLink(CreateLink event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final link =
          await _channelExtrasRepository.createLink(event.channelId, event.data);
      final updated = [...state.links, link];
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, links: updated));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error creating link: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteLink(DeleteLink event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      await _channelExtrasRepository.deleteLink(event.channelId, event.linkId);
      final links = state.links.where((l) => l.id != event.linkId).toList();
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, links: links));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error deleting link: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  // --- Tab Handlers ---

  Future<void> _onLoadTabs(LoadTabs event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final tabs = await _channelExtrasRepository.getTabs(event.channelId);
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, tabs: tabs));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error loading tabs: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateTab(CreateTab event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final tab =
          await _channelExtrasRepository.createTab(event.channelId, event.data);
      final updated = [...state.tabs, tab];
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, tabs: updated));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error creating tab: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteTab(DeleteTab event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      await _channelExtrasRepository.deleteTab(event.channelId, event.tabId);
      final tabs = state.tabs.where((t) => t.id != event.tabId).toList();
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, tabs: tabs));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error deleting tab: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  // --- Template Handlers ---

  Future<void> _onLoadTemplates(
      LoadTemplates event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final templates =
          await _channelExtrasRepository.getTemplates(event.channelId);
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, templates: templates));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error loading templates: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateTemplate(
      CreateTemplate event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      final template =
          await _channelExtrasRepository.createTemplate(event.channelId, event.data);
      final updated = [...state.templates, template];
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, templates: updated));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error creating template: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteTemplate(
      DeleteTemplate event, Emitter<ChannelExtrasState> emit) async {
    emit(state.copyWith(status: ChannelExtrasStatus.loading));
    try {
      await _channelExtrasRepository.deleteTemplate(
          event.channelId, event.templateId);
      final templates =
          state.templates.where((t) => t.id != event.templateId).toList();
      emit(state.copyWith(status: ChannelExtrasStatus.loaded, templates: templates));
    } catch (e) {
      debugPrint('ChannelExtrasBloc: Error deleting template: $e');
      emit(state.copyWith(status: ChannelExtrasStatus.error, error: e.toString()));
    }
  }

  void _onClearError(
      ClearChannelExtrasError event, Emitter<ChannelExtrasState> emit) {
    emit(state.copyWith(status: ChannelExtrasStatus.loaded, error: null));
  }
}
