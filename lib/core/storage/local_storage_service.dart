import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../models/call_record.dart';

/// Service for managing local data persistence using Hive
class LocalStorageService {
  static const String conversationsBoxName = 'conversations';
  static const String messagesBoxName = 'messages';
  static const String usersBoxName = 'users';
  static const String callsBoxName = 'calls';
  static const String metadataBoxName = 'metadata';

  Box<Conversation>? _conversationsBox;
  Box<List<dynamic>>? _messagesBox;
  Box<User>? _usersBox;
  Box<CallRecord>? _callsBox;
  Box<dynamic>? _metadataBox;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize Hive and open all boxes
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _conversationsBox = await Hive.openBox<Conversation>(conversationsBoxName);
      _messagesBox = await Hive.openBox<List<dynamic>>(messagesBoxName);
      _usersBox = await Hive.openBox<User>(usersBoxName);
      _callsBox = await Hive.openBox<CallRecord>(callsBoxName);
      _metadataBox = await Hive.openBox<dynamic>(metadataBoxName);

      _isInitialized = true;
      debugPrint('LocalStorageService: Initialized successfully');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to initialize: $e');
      rethrow;
    }
  }

  // ============= Conversations =============

  /// Save a list of conversations
  Future<void> saveConversations(List<Conversation> conversations) async {
    if (!_isInitialized || _conversationsBox == null) return;

    try {
      final Map<String, Conversation> conversationMap = {
        for (final c in conversations) c.id: c
      };
      await _conversationsBox!.putAll(conversationMap);
      debugPrint('LocalStorageService: Saved ${conversations.length} conversations');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save conversations: $e');
    }
  }

  /// Get all cached conversations
  Future<List<Conversation>> getConversations() async {
    if (!_isInitialized || _conversationsBox == null) return [];

    try {
      final conversations = _conversationsBox!.values.toList();
      // Sort by updatedAt or createdAt descending
      conversations.sort((a, b) {
        final aTime = a.updatedAt ?? a.createdAt;
        final bTime = b.updatedAt ?? b.createdAt;
        return bTime.compareTo(aTime);
      });
      debugPrint('LocalStorageService: Retrieved ${conversations.length} conversations');
      return conversations;
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get conversations: $e');
      return [];
    }
  }

  /// Save a single conversation
  Future<void> saveConversation(Conversation conversation) async {
    if (!_isInitialized || _conversationsBox == null) return;

    try {
      await _conversationsBox!.put(conversation.id, conversation);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save conversation: $e');
    }
  }

  /// Get a single conversation by ID
  Future<Conversation?> getConversation(String id) async {
    if (!_isInitialized || _conversationsBox == null) return null;

    try {
      return _conversationsBox!.get(id);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get conversation $id: $e');
      return null;
    }
  }

  /// Delete a conversation
  Future<void> deleteConversation(String id) async {
    if (!_isInitialized || _conversationsBox == null) return;

    try {
      await _conversationsBox!.delete(id);
      await _messagesBox?.delete(id); // Also delete associated messages
    } catch (e) {
      debugPrint('LocalStorageService: Failed to delete conversation $id: $e');
    }
  }

  // ============= Messages =============

  /// Save messages for a conversation
  Future<void> saveMessages(String conversationId, List<Message> messages) async {
    if (!_isInitialized || _messagesBox == null) return;

    try {
      // Store as List<dynamic> since Hive doesn't support List<Message> directly
      await _messagesBox!.put(conversationId, messages.cast<dynamic>());
      debugPrint('LocalStorageService: Saved ${messages.length} messages for $conversationId');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save messages: $e');
    }
  }

  /// Get messages for a conversation
  Future<List<Message>> getMessages(String conversationId, {int? limit}) async {
    if (!_isInitialized || _messagesBox == null) return [];

    try {
      final dynamic rawMessages = _messagesBox!.get(conversationId);
      if (rawMessages == null) return [];

      List<Message> messages;
      if (rawMessages is List) {
        messages = rawMessages.cast<Message>().toList();
      } else {
        return [];
      }

      // Sort by createdAt ascending (oldest first)
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      if (limit != null && messages.length > limit) {
        // Return the most recent messages
        return messages.sublist(messages.length - limit);
      }

      return messages;
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get messages for $conversationId: $e');
      return [];
    }
  }

  /// Add a single message to a conversation
  Future<void> addMessage(String conversationId, Message message) async {
    if (!_isInitialized || _messagesBox == null) return;

    try {
      final messages = await getMessages(conversationId);

      // Check if message already exists (by ID or clientId)
      final existingIndex = messages.indexWhere(
        (m) => m.id == message.id || (m.clientId != null && m.clientId == message.clientId),
      );

      if (existingIndex >= 0) {
        // Replace existing message
        messages[existingIndex] = message;
      } else {
        // Add new message
        messages.add(message);
      }

      await saveMessages(conversationId, messages);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to add message: $e');
    }
  }

  /// Update a message in a conversation
  Future<void> updateMessage(String conversationId, Message message) async {
    await addMessage(conversationId, message);
  }

  /// Delete a message from a conversation
  Future<void> deleteMessage(String conversationId, String messageId) async {
    if (!_isInitialized || _messagesBox == null) return;

    try {
      final messages = await getMessages(conversationId);
      messages.removeWhere((m) => m.id == messageId);
      await saveMessages(conversationId, messages);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to delete message $messageId: $e');
    }
  }

  // ============= Users =============

  /// Save a user
  Future<void> saveUser(User user) async {
    if (!_isInitialized || _usersBox == null) return;

    try {
      await _usersBox!.put(user.id, user);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save user ${user.id}: $e');
    }
  }

  /// Save multiple users
  Future<void> saveUsers(List<User> users) async {
    if (!_isInitialized || _usersBox == null) return;

    try {
      final Map<String, User> userMap = {for (final u in users) u.id: u};
      await _usersBox!.putAll(userMap);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save users: $e');
    }
  }

  /// Get a user by ID
  Future<User?> getUser(String userId) async {
    if (!_isInitialized || _usersBox == null) return null;

    try {
      return _usersBox!.get(userId);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get user $userId: $e');
      return null;
    }
  }

  /// Get all cached users
  Future<List<User>> getAllUsers() async {
    if (!_isInitialized || _usersBox == null) return [];

    try {
      return _usersBox!.values.toList();
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get all users: $e');
      return [];
    }
  }

  // ============= Call Records =============

  /// Save a call record
  Future<void> saveCallRecord(CallRecord call) async {
    if (!_isInitialized || _callsBox == null) return;

    try {
      await _callsBox!.put(call.id, call);
      debugPrint('LocalStorageService: Saved call record ${call.id}');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save call record: $e');
    }
  }

  /// Save multiple call records
  Future<void> saveCallRecords(List<CallRecord> calls) async {
    if (!_isInitialized || _callsBox == null) return;

    try {
      final Map<String, CallRecord> callMap = {for (final c in calls) c.id: c};
      await _callsBox!.putAll(callMap);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to save call records: $e');
    }
  }

  /// Get all call records
  Future<List<CallRecord>> getCallRecords({int? limit}) async {
    if (!_isInitialized || _callsBox == null) return [];

    try {
      var calls = _callsBox!.values.toList();
      // Sort by timestamp descending (most recent first)
      calls.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (limit != null && calls.length > limit) {
        return calls.sublist(0, limit);
      }

      return calls;
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get call records: $e');
      return [];
    }
  }

  /// Delete a call record
  Future<void> deleteCallRecord(String id) async {
    if (!_isInitialized || _callsBox == null) return;

    try {
      await _callsBox!.delete(id);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to delete call record $id: $e');
    }
  }

  // ============= Metadata =============

  /// Save metadata value
  Future<void> setMetadata(String key, dynamic value) async {
    if (!_isInitialized || _metadataBox == null) return;

    try {
      await _metadataBox!.put(key, value);
    } catch (e) {
      debugPrint('LocalStorageService: Failed to set metadata $key: $e');
    }
  }

  /// Get metadata value
  Future<T?> getMetadata<T>(String key) async {
    if (!_isInitialized || _metadataBox == null) return null;

    try {
      return _metadataBox!.get(key) as T?;
    } catch (e) {
      debugPrint('LocalStorageService: Failed to get metadata $key: $e');
      return null;
    }
  }

  /// Get last sync timestamp for conversations
  Future<DateTime?> getLastConversationsSyncTime() async {
    final timestamp = await getMetadata<int>('last_conversations_sync');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Set last sync timestamp for conversations
  Future<void> setLastConversationsSyncTime(DateTime time) async {
    await setMetadata('last_conversations_sync', time.millisecondsSinceEpoch);
  }

  // ============= Clear Data =============

  /// Clear all data (for logout)
  Future<void> clearAll() async {
    if (!_isInitialized) return;

    try {
      await _conversationsBox?.clear();
      await _messagesBox?.clear();
      await _usersBox?.clear();
      await _callsBox?.clear();
      await _metadataBox?.clear();
      debugPrint('LocalStorageService: Cleared all data');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to clear all data: $e');
    }
  }

  /// Clear only chat data (conversations and messages)
  Future<void> clearChatData() async {
    if (!_isInitialized) return;

    try {
      await _conversationsBox?.clear();
      await _messagesBox?.clear();
      debugPrint('LocalStorageService: Cleared chat data');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to clear chat data: $e');
    }
  }

  /// Close all boxes
  Future<void> close() async {
    try {
      await _conversationsBox?.close();
      await _messagesBox?.close();
      await _usersBox?.close();
      await _callsBox?.close();
      await _metadataBox?.close();
      _isInitialized = false;
      debugPrint('LocalStorageService: Closed all boxes');
    } catch (e) {
      debugPrint('LocalStorageService: Failed to close boxes: $e');
    }
  }
}
