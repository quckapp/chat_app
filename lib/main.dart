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
}
