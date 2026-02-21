class ApiConstants {
  ApiConstants._();

  // Change this to your computer's IP if using physical device
  // For Android emulator: 10.0.2.2
  // For physical device: your computer's IP (e.g., 192.168.29.198)
  // For web browser: localhost
  static const String _host = '127.0.0.1';

  // Kong API Gateway — single entry point for REST API services
  static const int _kongPort = 8080;
  static const String kongBaseUrl = 'http://$_host:$_kongPort';

  // Envoy Proxy — handles WebSocket connections
  static const int _envoyPort = 8090;
  static const String envoyWsBaseUrl = 'ws://$_host:$_envoyPort';

  // LiveKit — media server for video/audio calls
  static const int _livekitPort = 7880;
  static const String livekitUrl = 'ws://$_host:$_livekitPort';

  // Base URLs — REST routed through Kong
  static const String authServiceBaseUrl = 'http://$_host:$_kongPort/api/auth';
  static const String userServiceBaseUrl = 'http://$_host:$_kongPort';
  static const String permissionServiceBaseUrl = 'http://$_host:$_kongPort';
  static const String gatewayBaseUrl = 'http://$_host:$_kongPort';

  // Elixir Services — WebSocket routed through Envoy, REST through Kong
  static const String realtimeServiceWsUrl = 'ws://$_host:$_envoyPort/socket/websocket';
  static const String messageServiceBaseUrl = 'http://$_host:$_kongPort';

  // Auth endpoints - Phone OTP
  static const String login = '/v1/auth/phone/request-otp';
  static const String requestOtp = '/v1/auth/phone/request-otp';
  static const String verifyOtp = '/v1/auth/phone/login';
  static const String loginWithOtp = '/v1/auth/phone/login';
  static const String resendOtp = '/v1/auth/phone/resend-otp';

  // Auth endpoints - Email OTP (for email verification)
  static const String requestEmailOtp = '/v1/auth/email/request-otp';
  static const String verifyEmailOtp = '/v1/auth/email/verify-otp';
  static const String requestEmailOtpAuthenticated = '/v1/auth/email/request-otp/authenticated';
  static const String verifyEmailOtpAuthenticated = '/v1/auth/email/verify-otp/authenticated';

  // Auth endpoints - General
  static const String logout = '/v1/logout';
  static const String refreshToken = '/v1/token/refresh';
  static const String sessions = '/v1/sessions';
  static const String me = '/v1/users/me';

  // User endpoints
  static const String users = '/api/users/v1';
  static const String userProfile = '/api/users/v1/profile';
  static const String searchUsers = '/api/users/v1/search';

  // Permission endpoints
  static const String permissions = '/api/permissions/v1';
  static const String roles = '/api/permissions/v1/roles';
  static const String userPermissions = '/api/permissions/v1/users';

  // Workspace endpoints
  static const String workspaces = '/api/v1/workspaces';
  static const String joinWorkspace = '/api/v1/join';
  static const String acceptInvite = '/api/v1/invites'; // + /:token/accept

  // Channel endpoints
  static const String channels = '/api/v1/channels';

  // Thread endpoints
  static const String threads = '/api/v1/threads';

  // File, Attachment & Media endpoints
  static const String files = '/api/v1/files';
  static const String attachments = '/api/v1/attachments';
  static const String media = '/api/v1/media';

  // Bookmark & Reminder endpoints
  static const String bookmarks = '/api/bookmarks';
  static const String bookmarkFolders = '/api/bookmarks/folders';
  static const String reminders = '/api/v1/reminders';

  // Search endpoints
  static const String search = '/api/v1/search';

  // Notification endpoints
  static const String notifications = '/api/notifications';
  static const String devices = '/api/devices';
  static const String preferences = '/api/preferences';

  // Call & Huddle endpoints
  static const String calls = '/api/v1/calls';
  static const String huddles = '/api/v1/huddles';

  // Admin, Audit, Permission & Security endpoints
  static const String admin = '/api/admin';
  static const String audit = '/api/audit';
  static const String permissionsApi = '/api/permissions';
  static const String security = '/api/security';

  // Event & Realtime REST endpoints
  static const String events = '/api/v1/events';
  static const String realtimeRest = '/api/realtime';

  // Placeholder service endpoints
  static const String analytics = '/api/v1/analytics';
  static const String export = '/api/v1/export';
  static const String integrations = '/api/v1/integrations';
  static const String ml = '/api/v1/ml';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
