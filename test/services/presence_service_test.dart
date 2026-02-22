import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_app/core/websocket/phoenix_channel.dart';
import 'package:chat_app/models/presence.dart';
import 'package:chat_app/services/presence_service.dart';
import 'package:chat_app/services/realtime_service.dart';

import '../helpers/test_helpers.dart';

class MockRealtimeService extends Mock implements RealtimeService {}

class MockPhoenixChannel extends Mock implements PhoenixChannel {}

void main() {
  late MockRealtimeService mockRealtimeService;
  late MockPhoenixChannel mockPresenceChannel;
  late PresenceService presenceService;

  setUp(() {
    mockRealtimeService = MockRealtimeService();
    mockPresenceChannel = MockPhoenixChannel();
    presenceService = PresenceService(mockRealtimeService);
  });

  tearDown(() {
    presenceService.dispose();
  });

  group('startListening', () {
    test('is idempotent (only subscribes once)', () {
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);
      when(() => mockPresenceChannel.on(any(), any())).thenReturn(null);

      presenceService.startListening();
      presenceService.startListening();

      // on() is called 4 times on the first startListening (presenceState,
      // presenceDiff, userOnline, userOffline) and not called again on the
      // second invocation.
      verify(() => mockPresenceChannel.on(any(), any())).called(4);
    });

    test('does nothing when presenceChannel is null', () {
      when(() => mockRealtimeService.presenceChannel).thenReturn(null);

      // Should not throw
      presenceService.startListening();

      verifyNever(() => mockPresenceChannel.on(any(), any()));
    });
  });

  group('stopListening', () {
    test('clears presences and notifies listeners', () async {
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);
      when(() => mockPresenceChannel.on(any(), any())).thenReturn(null);

      presenceService.startListening();

      // Listen for a presenceStream emission from stopListening
      final emitted = Completer<Map<String, UserPresence>>();
      presenceService.presenceStream.listen((data) {
        if (!emitted.isCompleted) emitted.complete(data);
      });

      presenceService.stopListening();

      final result = await emitted.future;
      expect(result, isEmpty);
      expect(presenceService.presences, isEmpty);
    });
  });

  group('getPresence', () {
    test('returns cached presence for userId', () {
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);

      // Capture the userOnline handler and invoke it to populate the cache
      void Function(Map<String, dynamic>)? userOnlineHandler;
      when(() => mockPresenceChannel.on(any(), any())).thenAnswer((inv) {
        final event = inv.positionalArguments[0] as String;
        if (event == 'user:online') {
          userOnlineHandler = inv.positionalArguments[1]
              as void Function(Map<String, dynamic>);
        }
      });

      presenceService.startListening();
      userOnlineHandler?.call({'userId': 'user-1'});

      final result = presenceService.getPresence('user-1');

      expect(result, isNotNull);
      expect(result!.userId, 'user-1');
      expect(result.status, PresenceStatus.online);
    });

    test('returns null for unknown userId', () {
      final result = presenceService.getPresence('unknown-user');

      expect(result, isNull);
    });
  });

  group('isOnline', () {
    test('returns true when user status is online', () {
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);

      void Function(Map<String, dynamic>)? userOnlineHandler;
      when(() => mockPresenceChannel.on(any(), any())).thenAnswer((inv) {
        final event = inv.positionalArguments[0] as String;
        if (event == 'user:online') {
          userOnlineHandler = inv.positionalArguments[1]
              as void Function(Map<String, dynamic>);
        }
      });

      presenceService.startListening();
      userOnlineHandler?.call({'userId': 'user-1'});

      expect(presenceService.isOnline('user-1'), true);
    });

    test('returns false for unknown userId', () {
      expect(presenceService.isOnline('unknown-user'), false);
    });
  });

  group('updateStatus', () {
    test('pushes status:update to presence channel', () {
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);
      when(() => mockPresenceChannel.isJoined).thenReturn(true);
      when(() => mockPresenceChannel.pushNoReply(any(), any()))
          .thenReturn(null);

      presenceService.updateStatus(PresenceStatus.away,
          statusMessage: 'In a meeting');

      verify(() => mockPresenceChannel.pushNoReply('status:update', {
            'status': 'away',
            'statusMessage': 'In a meeting',
          })).called(1);
    });

    test('does nothing when channel is null or not joined', () {
      // Case 1: channel is null
      when(() => mockRealtimeService.presenceChannel).thenReturn(null);

      presenceService.updateStatus(PresenceStatus.online);

      verifyNever(() => mockPresenceChannel.pushNoReply(any(), any()));

      // Case 2: channel exists but not joined
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);
      when(() => mockPresenceChannel.isJoined).thenReturn(false);

      presenceService.updateStatus(PresenceStatus.online);

      verifyNever(() => mockPresenceChannel.pushNoReply(any(), any()));
    });
  });

  group('dispose', () {
    test('stops listening and closes controller', () async {
      when(() => mockRealtimeService.presenceChannel)
          .thenReturn(mockPresenceChannel);
      when(() => mockPresenceChannel.on(any(), any())).thenReturn(null);

      presenceService.startListening();
      presenceService.dispose();

      expect(presenceService.presences, isEmpty);
    });
  });
}
