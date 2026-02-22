import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_app/core/network/api_client.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/user_service.dart';

import '../helpers/test_helpers.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late UserService userService;

  setUp(() {
    mockApiClient = MockApiClient();
    userService = UserService(apiClient: mockApiClient);
  });

  group('getUserById', () {
    test('calls GET with user ID', () async {
      final user = makeUser(id: 'user-42');
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: user.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await userService.getUserById('user-42');

      expect(result.id, 'user-42');
      verify(() => mockApiClient.get('/api/users/v1/user-42')).called(1);
    });
  });

  group('getProfile', () {
    test('calls GET userProfile endpoint', () async {
      final user = makeUser();
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: user.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await userService.getProfile();

      expect(result.id, user.id);
      verify(() => mockApiClient.get('/api/users/v1/profile')).called(1);
    });
  });

  group('updateProfile', () {
    test('calls PATCH with only provided fields', () async {
      final user = makeUser(firstName: 'Jane');
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: user.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await userService.updateProfile(firstName: 'Jane');

      expect(result.id, user.id);
      verify(() => mockApiClient.patch(
            '/api/users/v1/profile',
            data: {'firstName': 'Jane'},
          )).called(1);
    });
  });

  group('searchUsers', () {
    test('calls GET with query params, parses list response', () async {
      final user1 = makeUser(id: 'user-1');
      final user2 = makeUser(id: 'user-2');
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: [user1.toJson(), user2.toJson()],
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await userService.searchUsers(query: 'John');

      expect(result.length, 2);
      expect(result[0].id, 'user-1');
      expect(result[1].id, 'user-2');
      verify(() => mockApiClient.get(
            '/api/users/v1/search',
            queryParameters: {'q': 'John', 'page': 1, 'limit': 20},
          )).called(1);
    });

    test('handles wrapped {users: [...]} response format', () async {
      final user = makeUser(id: 'user-1');
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'users': [user.toJson()],
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await userService.searchUsers(query: 'John');

      expect(result.length, 1);
      expect(result[0].id, 'user-1');
    });

    test('returns empty list for unexpected format', () async {
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: 'unexpected',
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await userService.searchUsers(query: 'John');

      expect(result, isEmpty);
    });
  });

  group('getUsersByIds', () {
    test('calls POST /batch with ids', () async {
      final user1 = makeUser(id: 'user-1');
      final user2 = makeUser(id: 'user-2');
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: [user1.toJson(), user2.toJson()],
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result =
          await userService.getUsersByIds(['user-1', 'user-2']);

      expect(result.length, 2);
      verify(() => mockApiClient.post(
            '/api/users/v1/batch',
            data: {
              'ids': ['user-1', 'user-2']
            },
          )).called(1);
    });
  });

  group('updateStatus', () {
    test('calls PATCH with status name', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      await userService.updateStatus(UserStatus.away);

      verify(() => mockApiClient.patch(
            '/api/users/v1/profile/status',
            data: {'status': 'away'},
          )).called(1);
    });
  });

  group('deleteAccount', () {
    test('calls DELETE on userProfile', () async {
      when(() => mockApiClient.delete(any()))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      await userService.deleteAccount();

      verify(() => mockApiClient.delete('/api/users/v1/profile')).called(1);
    });
  });
}
