import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'bloc/bloc.dart';
import 'core/theme/theme.dart';
import 'ui/screens/screens.dart';

/// A Listenable that notifies when auth state changes
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(this._authBloc) {
    _authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  final AuthBloc _authBloc;

  AuthState get authState => _authBloc.state;
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  late final GoRouter _router;
  late final AuthChangeNotifier _authNotifier;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize router only once
    if (!_isRouterInitialized) {
      _authNotifier = AuthChangeNotifier(context.read<AuthBloc>());
      _router = _createRouter();
      _isRouterInitialized = true;
    }
  }

  bool _isRouterInitialized = false;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: _authNotifier,
      redirect: (context, state) {
        final authState = _authNotifier.authState;
        final isLoggedIn = authState.isAuthenticated;
        final needsProfileSetup = authState.needsProfileSetup;
        final isLoggingIn = state.matchedLocation == '/login';
        final isOtpScreen = state.matchedLocation == '/otp';
        final isRegisterNameScreen = state.matchedLocation == '/register-name';

        // Show nothing while checking initial auth
        if (authState.status == AuthStatus.initial) {
          return null;
        }

        // Handle OTP verification
        if (authState.isOtpSent && !isOtpScreen) {
          return '/otp';
        }

        // Handle new user - must register name first
        if (needsProfileSetup && !isRegisterNameScreen) {
          return '/register-name';
        }

        // Don't allow register-name if not in profile setup mode
        if (!needsProfileSetup && isRegisterNameScreen && !isLoggedIn) {
          return '/login';
        }

        // Redirect to login if OTP was cancelled (on OTP screen but no OTP pending)
        if (!isLoggedIn && !needsProfileSetup && isOtpScreen && !authState.isOtpSent) {
          return '/login';
        }

        // Redirect to login if not logged in and not on auth screens
        if (!isLoggedIn && !needsProfileSetup && !isLoggingIn && !isOtpScreen) {
          return '/login';
        }

        // Redirect to home if logged in and trying to access auth pages
        if (isLoggedIn && (isLoggingIn || isOtpScreen || isRegisterNameScreen)) {
          return '/';
        }

        return null;
      },
      routes: [
        // Auth routes (outside shell)
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const OtpScreen(),
        ),
        GoRoute(
          path: '/register-name',
          builder: (context, state) => const RegisterNameScreen(),
        ),

        // Main app shell with bottom navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShellScreen(navigationShell: navigationShell);
          },
          branches: [
            // Branch 0: Chats
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const ConversationsScreen(),
                ),
              ],
            ),
            // Branch 1: Channels
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/channels',
                  builder: (context, state) => const ChannelListScreen(),
                ),
              ],
            ),
            // Branch 2: Search
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/search',
                  builder: (context, state) => const SearchScreen(),
                ),
              ],
            ),
            // Branch 3: Notifications
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/notifications',
                  builder: (context, state) => const NotificationListScreen(),
                ),
              ],
            ),
            // Branch 4: More
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/more',
                  builder: (context, state) => const MoreScreen(),
                ),
              ],
            ),
          ],
        ),

        // Detail routes (pushed on top of shell)
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(
            onToggleTheme: _toggleTheme,
            isDarkMode: _themeMode == ThemeMode.dark,
          ),
        ),
        GoRoute(
          path: '/conversations',
          builder: (context, state) => const ConversationsScreen(),
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) => ChatScreen(
            conversationId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/new-chat',
          builder: (context, state) => const NewChatScreen(),
        ),
        GoRoute(
          path: '/chat/:id/info',
          builder: (context, state) => ChatInfoScreen(
            conversationId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/chat/:id/media',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return MediaGalleryScreen(
              conversationId: state.pathParameters['id']!,
              conversationName: extra?['conversationName'] as String? ?? 'Chat',
            );
          },
        ),
        // Workspace routes
        GoRoute(
          path: '/workspaces',
          builder: (context, state) => const WorkspaceListScreen(),
        ),
        GoRoute(
          path: '/workspaces/create',
          builder: (context, state) => const CreateWorkspaceScreen(),
        ),
        GoRoute(
          path: '/workspace/:id',
          builder: (context, state) => WorkspaceDetailScreen(
            workspaceId: state.pathParameters['id']!,
          ),
        ),
        // Channel detail routes
        GoRoute(
          path: '/channels/create',
          builder: (context, state) => const CreateChannelScreen(),
        ),
        GoRoute(
          path: '/channel/:id',
          builder: (context, state) => ChannelDetailScreen(
            channelId: state.pathParameters['id']!,
          ),
        ),
        // Thread routes
        GoRoute(
          path: '/threads',
          builder: (context, state) => const ThreadListScreen(),
        ),
        GoRoute(
          path: '/thread/:id',
          builder: (context, state) => ThreadViewScreen(
            threadId: state.pathParameters['id']!,
          ),
        ),
        // File routes
        GoRoute(
          path: '/files',
          builder: (context, state) => const FileBrowserScreen(),
        ),
        GoRoute(
          path: '/file/:id/preview',
          builder: (context, state) => FilePreviewScreen(
            fileId: state.pathParameters['id']!,
          ),
        ),
        // Bookmark routes
        GoRoute(
          path: '/bookmarks',
          builder: (context, state) => const BookmarkListScreen(),
        ),
        GoRoute(
          path: '/bookmarks/folder/:id',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return BookmarkFolderScreen(
              folderId: state.pathParameters['id']!,
              folderName: extra?['folderName'] as String? ?? 'Folder',
            );
          },
        ),
        // Reminder routes
        GoRoute(
          path: '/reminders',
          builder: (context, state) => const ReminderListScreen(),
        ),
        GoRoute(
          path: '/reminders/create',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CreateReminderScreen(
              messageId: extra?['messageId'] as String? ?? '',
              channelId: extra?['channelId'] as String? ?? '',
            );
          },
        ),
        // Notification settings
        GoRoute(
          path: '/notifications/settings',
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: '/devices',
          builder: (context, state) => const DeviceManagementScreen(),
        ),
        // Call & Huddle routes
        GoRoute(
          path: '/call-history',
          builder: (context, state) => const CallHistoryScreen(),
        ),
        GoRoute(
          path: '/huddle/:id',
          builder: (context, state) => HuddleScreen(
            channelId: state.pathParameters['id']!,
          ),
        ),
        // Channel advanced feature routes
        GoRoute(
          path: '/channel/:id/polls',
          builder: (context, state) => PollScreen(
            channelId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/channel/:id/scheduled',
          builder: (context, state) => ScheduledMessagesScreen(
            channelId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/channel/:id/links',
          builder: (context, state) => ChannelLinksScreen(
            channelId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/channel/:id/tabs',
          builder: (context, state) => ChannelTabsScreen(
            channelId: state.pathParameters['id']!,
          ),
        ),
        // Admin routes
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: '/admin/audit',
          builder: (context, state) => const AuditLogScreen(),
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (context, state) => const AdminSettingsScreen(),
        ),
        // Auth enhancement routes
        GoRoute(
          path: '/settings/2fa',
          builder: (context, state) => const TwoFactorSetupScreen(),
        ),
        GoRoute(
          path: '/settings/sessions',
          builder: (context, state) => const SessionManagementScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a placeholder until router is initialized
    if (!_isRouterInitialized) {
      return MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      title: 'QuickApp Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
