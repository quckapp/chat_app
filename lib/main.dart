import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'bloc/bloc.dart';
import 'core/storage/local_storage_service.dart';
import 'models/models.dart';
import 'services/auth_service.dart';
import 'services/realtime_service.dart';
import 'services/chat_service.dart';
import 'services/presence_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  _registerHiveAdapters();

  // Initialize local storage service
  final localStorageService = LocalStorageService();
  await localStorageService.init();

  // Create services
  final authService = AuthService();
  final realtimeService = RealtimeService();
  final chatService = ChatService(realtimeService);
  final presenceService = PresenceService(realtimeService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authService: authService,
            realtimeService: realtimeService,
            localStorageService: localStorageService,
          ),
        ),
        BlocProvider<RealtimeBloc>(
          create: (_) => RealtimeBloc(realtimeService: realtimeService),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(
            chatService: chatService,
            localStorageService: localStorageService,
          ),
        ),
        BlocProvider<PresenceBloc>(
          create: (_) => PresenceBloc(presenceService: presenceService),
        ),
        BlocProvider<TypingBloc>(
          create: (_) => TypingBloc(chatService: chatService),
        ),
        BlocProvider<CallBloc>(
          create: (_) => CallBloc(localStorageService: localStorageService),
        ),
        BlocProvider<WorkspaceBloc>(
          create: (_) => WorkspaceBloc(),
        ),
        BlocProvider<ChannelBloc>(
          create: (_) => ChannelBloc(),
        ),
        BlocProvider<ThreadBloc>(
          create: (_) => ThreadBloc(),
        ),
        BlocProvider<FileBloc>(
          create: (_) => FileBloc(),
        ),
        BlocProvider<BookmarkBloc>(
          create: (_) => BookmarkBloc(),
        ),
        BlocProvider<ReminderBloc>(
          create: (_) => ReminderBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc(),
        ),
        BlocProvider<HuddleBloc>(
          create: (_) => HuddleBloc(),
        ),
        BlocProvider<ChannelExtrasBloc>(
          create: (_) => ChannelExtrasBloc(),
        ),
        BlocProvider<AdminBloc>(
          create: (_) => AdminBloc(),
        ),
      ],
      child: const ChatApp(),
    ),
  );
}

/// Register all Hive type adapters
void _registerHiveAdapters() {
  // Type ID 0: Conversation
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ConversationAdapter());
  }

  // Type ID 1: Message
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MessageAdapter());
  }

  // Type ID 2: Participant
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ParticipantAdapter());
  }

  // Type ID 3: Attachment
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(AttachmentAdapter());
  }

  // Type ID 4: Reaction
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(ReactionAdapter());
  }

  // Type ID 5: User
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(UserAdapter());
  }

  // Type ID 6: ParticipantRole enum
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(ParticipantRoleAdapter());
  }

  // Type ID 7: UserStatus enum
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(UserStatusAdapter());
  }

  // Type ID 8: CallType enum
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(CallTypeAdapter());
  }

  // Type ID 9: CallStatus enum
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(CallStatusAdapter());
  }

  // Type ID 10: CallRecord
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(CallRecordAdapter());
  }

  // Type ID 11: Workspace
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(WorkspaceAdapter());
  }

  // Type ID 12: WorkspaceMember
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(WorkspaceMemberAdapter());
  }

  // Type ID 13: WorkspaceRole enum
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(WorkspaceRoleAdapter());
  }

  // Type ID 14: Channel
  if (!Hive.isAdapterRegistered(14)) {
    Hive.registerAdapter(ChannelAdapter());
  }

  // Type ID 15: ChannelType enum
  if (!Hive.isAdapterRegistered(15)) {
    Hive.registerAdapter(ChannelTypeAdapter());
  }

  // Type ID 16: ChannelMember
  if (!Hive.isAdapterRegistered(16)) {
    Hive.registerAdapter(ChannelMemberAdapter());
  }

  // Type ID 17: Thread
  if (!Hive.isAdapterRegistered(17)) {
    Hive.registerAdapter(ThreadAdapter());
  }

  // Type ID 18: ThreadReply
  if (!Hive.isAdapterRegistered(18)) {
    Hive.registerAdapter(ThreadReplyAdapter());
  }

  // Type ID 19: FileInfo
  if (!Hive.isAdapterRegistered(19)) {
    Hive.registerAdapter(FileInfoAdapter());
  }

  // Type ID 20: FileType enum
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(FileTypeAdapter());
  }

  // Type ID 21: MediaInfo
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(MediaInfoAdapter());
  }

  // Type ID 22: Bookmark
  if (!Hive.isAdapterRegistered(22)) {
    Hive.registerAdapter(BookmarkAdapter());
  }

  // Type ID 23: BookmarkFolder
  if (!Hive.isAdapterRegistered(23)) {
    Hive.registerAdapter(BookmarkFolderAdapter());
  }

  // Type ID 24: Reminder
  if (!Hive.isAdapterRegistered(24)) {
    Hive.registerAdapter(ReminderAdapter());
  }

  // Type ID 25: ReminderStatus enum
  if (!Hive.isAdapterRegistered(25)) {
    Hive.registerAdapter(ReminderStatusAdapter());
  }

  // Type ID 26: SearchResult
  if (!Hive.isAdapterRegistered(26)) {
    Hive.registerAdapter(SearchResultAdapter());
  }

  // Type ID 27: SearchResultType enum
  if (!Hive.isAdapterRegistered(27)) {
    Hive.registerAdapter(SearchResultTypeAdapter());
  }

  // Type ID 28: AppNotification
  if (!Hive.isAdapterRegistered(28)) {
    Hive.registerAdapter(AppNotificationAdapter());
  }

  // Type ID 29: NotificationType enum
  if (!Hive.isAdapterRegistered(29)) {
    Hive.registerAdapter(NotificationTypeAdapter());
  }

  // Type ID 30: NotificationPreference
  if (!Hive.isAdapterRegistered(30)) {
    Hive.registerAdapter(NotificationPreferenceAdapter());
  }

  // Type ID 31: DeviceInfo
  if (!Hive.isAdapterRegistered(31)) {
    Hive.registerAdapter(DeviceInfoAdapter());
  }

  // Type ID 32: Huddle
  if (!Hive.isAdapterRegistered(32)) {
    Hive.registerAdapter(HuddleAdapter());
  }

  // Type ID 33: HuddleStatus enum
  if (!Hive.isAdapterRegistered(33)) {
    Hive.registerAdapter(HuddleStatusAdapter());
  }

  // Type ID 34: Poll
  if (!Hive.isAdapterRegistered(34)) {
    Hive.registerAdapter(PollAdapter());
  }

  // Type ID 35: PollOption
  if (!Hive.isAdapterRegistered(35)) {
    Hive.registerAdapter(PollOptionAdapter());
  }

  // Type ID 36: ScheduledMessage
  if (!Hive.isAdapterRegistered(36)) {
    Hive.registerAdapter(ScheduledMessageAdapter());
  }

  // Type ID 37: ChannelLink
  if (!Hive.isAdapterRegistered(37)) {
    Hive.registerAdapter(ChannelLinkAdapter());
  }

  // Type ID 38: ChannelTab
  if (!Hive.isAdapterRegistered(38)) {
    Hive.registerAdapter(ChannelTabAdapter());
  }

  // Type ID 39: ChannelTemplate
  if (!Hive.isAdapterRegistered(39)) {
    Hive.registerAdapter(ChannelTemplateAdapter());
  }

  // Type ID 40: AuditLogEntry
  if (!Hive.isAdapterRegistered(40)) {
    Hive.registerAdapter(AuditLogEntryAdapter());
  }

  // Type ID 41: Role
  if (!Hive.isAdapterRegistered(41)) {
    Hive.registerAdapter(AppRoleAdapter());
  }

  // Type ID 42: SecurityPolicy
  if (!Hive.isAdapterRegistered(42)) {
    Hive.registerAdapter(SecurityPolicyAdapter());
  }
}
