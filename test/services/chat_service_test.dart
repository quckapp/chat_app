import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_app/core/websocket/phoenix_channel.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/realtime_service.dart';

import '../helpers/test_helpers.dart';

class MockRealtimeService extends Mock implements RealtimeService {}

class MockPhoenixChannel extends Mock implements PhoenixChannel {}

void main() {
  late MockRealtimeService mockRealtimeService;
  late MockPhoenixChannel mockChannel;
  late ChatService chatService;

  const conversationId = 'conv-1';

  setUp(() {
    mockRealtimeService = MockRealtimeService();
    mockChannel = MockPhoenixChannel();
    chatService = ChatService(mockRealtimeService);
  });

  tearDown(() {
    chatService.dispose();
  });

  /// Helper to join a conversation with a mock channel that is already set up.
  Future<void> joinWithMockChannel() async {
    when(() => mockRealtimeService.getConversationChannel(conversationId))
        .thenReturn(mockChannel);
    when(() => mockChannel.join())
        .thenAnswer((_) async => PhoenixReply(status: 'ok', response: {}));
    when(() => mockChannel.on(any(), any())).thenReturn(null);
    when(() => mockChannel.isJoined).thenReturn(true);
    await chatService.joinConversation(conversationId);
  }

  group('joinConversation', () {
    test('gets channel from RealtimeService and joins it', () async {
      when(() => mockRealtimeService.getConversationChannel(conversationId))
          .thenReturn(mockChannel);
      when(() => mockChannel.join())
          .thenAnswer((_) async => PhoenixReply(status: 'ok', response: {}));
      when(() => mockChannel.isJoined).thenReturn(true);
      when(() => mockChannel.on(any(), any())).thenReturn(null);

      final result = await chatService.joinConversation(conversationId);

      expect(result, true);
      verify(() => mockRealtimeService.getConversationChannel(conversationId))
          .called(1);
      verify(() => mockChannel.join()).called(1);
    });

    test('returns true when already joined (idempotent)', () async {
      when(() => mockRealtimeService.getConversationChannel(conversationId))
          .thenReturn(mockChannel);
      when(() => mockChannel.join())
          .thenAnswer((_) async => PhoenixReply(status: 'ok', response: {}));
      when(() => mockChannel.on(any(), any())).thenReturn(null);

      await chatService.joinConversation(conversationId);
      final result = await chatService.joinConversation(conversationId);

      expect(result, true);
      // join() should only be called once because the second call is short-circuited
      verify(() => mockChannel.join()).called(1);
    });

    test('returns false when join reply is not ok', () async {
      when(() => mockRealtimeService.getConversationChannel(conversationId))
          .thenReturn(mockChannel);
      when(() => mockChannel.join()).thenAnswer((_) async =>
          PhoenixReply(status: 'error', response: {'reason': 'unauthorized'}));

      final result = await chatService.joinConversation(conversationId);

      expect(result, false);
    });
  });

  group('leaveConversation', () {
    test('removes channel and closes controllers', () async {
      when(() => mockRealtimeService.getConversationChannel(conversationId))
          .thenReturn(mockChannel);
      when(() => mockChannel.join())
          .thenAnswer((_) async => PhoenixReply(status: 'ok', response: {}));
      when(() => mockChannel.on(any(), any())).thenReturn(null);
      when(() => mockChannel.leave()).thenAnswer((_) async {});
      when(() => mockRealtimeService.leaveConversationChannel(conversationId))
          .thenReturn(null);

      await chatService.joinConversation(conversationId);
      chatService.leaveConversation(conversationId);

      verify(() => mockChannel.leave()).called(1);
      verify(() => mockRealtimeService.leaveConversationChannel(conversationId))
          .called(1);
    });
  });

  group('sendMessage', () {
    test('pushes message:send event with correct payload', () async {
      await joinWithMockChannel();
      when(() => mockChannel.push(any(), any())).thenAnswer(
          (_) async => PhoenixReply(status: 'ok', response: {'messageId': 'msg-1'}));

      final reply = await chatService.sendMessage(
        conversationId: conversationId,
        content: 'Hello!',
        type: 'text',
      );

      expect(reply.isOk, true);
      verify(() => mockChannel.push('message:send', {
            'conversationId': conversationId,
            'type': 'text',
            'content': 'Hello!',
          })).called(1);
    });

    test('returns error reply when not joined', () async {
      final reply = await chatService.sendMessage(
        conversationId: conversationId,
        content: 'Hello!',
      );

      expect(reply.isError, true);
      expect(reply.response['reason'], 'not_joined');
    });
  });

  group('editMessage', () {
    test('pushes message:edit event', () async {
      await joinWithMockChannel();
      when(() => mockChannel.push(any(), any())).thenAnswer(
          (_) async => PhoenixReply(status: 'ok', response: {}));

      final reply = await chatService.editMessage(
        conversationId: conversationId,
        messageId: 'msg-1',
        content: 'Edited!',
      );

      expect(reply.isOk, true);
      verify(() => mockChannel.push('message:edit', {
            'messageId': 'msg-1',
            'content': 'Edited!',
          })).called(1);
    });
  });

  group('deleteMessage', () {
    test('pushes message:delete event', () async {
      await joinWithMockChannel();
      when(() => mockChannel.push(any(), any())).thenAnswer(
          (_) async => PhoenixReply(status: 'ok', response: {}));

      final reply = await chatService.deleteMessage(
        conversationId: conversationId,
        messageId: 'msg-1',
      );

      expect(reply.isOk, true);
      verify(() => mockChannel.push('message:delete', {
            'messageId': 'msg-1',
          })).called(1);
    });
  });

  group('addReaction', () {
    test('pushes message:reaction:add event', () async {
      await joinWithMockChannel();
      when(() => mockChannel.push(any(), any())).thenAnswer(
          (_) async => PhoenixReply(status: 'ok', response: {}));

      final reply = await chatService.addReaction(
        conversationId: conversationId,
        messageId: 'msg-1',
        emoji: '\u{1F44D}',
      );

      expect(reply.isOk, true);
      verify(() => mockChannel.push('message:reaction:add', {
            'messageId': 'msg-1',
            'emoji': '\u{1F44D}',
          })).called(1);
    });
  });

  group('markAsRead', () {
    test('pushes message:read event', () async {
      await joinWithMockChannel();
      when(() => mockChannel.push(any(), any())).thenAnswer(
          (_) async => PhoenixReply(status: 'ok', response: {}));

      final reply = await chatService.markAsRead(
        conversationId: conversationId,
        messageId: 'msg-1',
      );

      expect(reply.isOk, true);
      verify(() => mockChannel.push('message:read', {
            'messageId': 'msg-1',
            'conversationId': conversationId,
          })).called(1);
    });
  });

  group('typing indicators', () {
    test('startTyping/stopTyping push no-reply typing events', () async {
      await joinWithMockChannel();
      when(() => mockChannel.pushNoReply(any(), any())).thenReturn(null);

      chatService.startTyping(conversationId);
      verify(() => mockChannel.pushNoReply('typing:start', {
            'conversationId': conversationId,
          })).called(1);

      chatService.stopTyping(conversationId);
      verify(() => mockChannel.pushNoReply('typing:stop', {
            'conversationId': conversationId,
          })).called(1);
    });
  });

  group('streams', () {
    test('getMessageStream/getEventStream return broadcast streams', () {
      final messageStream = chatService.getMessageStream(conversationId);
      final eventStream = chatService.getEventStream(conversationId);

      expect(messageStream.isBroadcast, true);
      expect(eventStream.isBroadcast, true);

      // Multiple listeners should work on broadcast streams
      messageStream.listen((_) {});
      messageStream.listen((_) {});

      eventStream.listen((_) {});
      eventStream.listen((_) {});
    });
  });
}
