import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_app/core/network/api_client.dart';
import 'package:chat_app/models/permission.dart';
import 'package:chat_app/services/permission_service.dart';

import '../helpers/test_helpers.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late PermissionService permissionService;

  setUp(() {
    mockApiClient = MockApiClient();
    permissionService = PermissionService(apiClient: mockApiClient);
  });

  group('getCurrentUserPermissions', () {
    test('calls GET /me endpoint', () async {
      final perms = makeUserPermissions();
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: perms.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await permissionService.getCurrentUserPermissions();

      expect(result.userId, perms.userId);
      verify(() => mockApiClient.get('/api/permissions/v1/users/me'))
          .called(1);
    });
  });

  group('getUserPermissions', () {
    test('calls GET with userId', () async {
      final perms = makeUserPermissions(userId: 'user-42');
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: perms.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await permissionService.getUserPermissions('user-42');

      expect(result.userId, 'user-42');
      verify(() => mockApiClient.get('/api/permissions/v1/users/user-42'))
          .called(1);
    });
  });

  group('getAllRoles', () {
    test('returns list of Role objects', () async {
      final role1 = makeRole(id: 'role-1', name: 'admin');
      final role2 = makeRole(id: 'role-2', name: 'member');
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: [role1.toJson(), role2.toJson()],
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await permissionService.getAllRoles();

      expect(result.length, 2);
      expect(result[0].name, 'admin');
      expect(result[1].name, 'member');
      verify(() => mockApiClient.get('/api/permissions/v1/roles')).called(1);
    });
  });

  group('getRoleById', () {
    test('calls GET with roleId', () async {
      final role = makeRole(id: 'role-1', name: 'admin');
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: role.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await permissionService.getRoleById('role-1');

      expect(result.id, 'role-1');
      expect(result.name, 'admin');
      verify(() => mockApiClient.get('/api/permissions/v1/roles/role-1'))
          .called(1);
    });
  });

  group('getAllPermissions', () {
    test('returns list of Permission objects', () async {
      final perm1 = makePermission(id: 'perm-1', name: 'read:messages');
      final perm2 = makePermission(id: 'perm-2', name: 'write:messages');
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: [perm1.toJson(), perm2.toJson()],
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await permissionService.getAllPermissions();

      expect(result.length, 2);
      expect(result[0].name, 'read:messages');
      expect(result[1].name, 'write:messages');
      verify(() => mockApiClient.get('/api/permissions/v1')).called(1);
    });
  });

  group('hasPermission', () {
    test('calls GET check endpoint, returns bool', () async {
      when(() => mockApiClient.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'hasPermission': true},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result =
          await permissionService.hasPermission('read:messages');

      expect(result, true);
      verify(() => mockApiClient.get(
            '/api/permissions/v1/users/me/check',
            queryParameters: {'permission': 'read:messages'},
          )).called(1);
    });

    test('returns false on error', () async {
      when(() => mockApiClient.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(Exception('network error'));

      final result =
          await permissionService.hasPermission('read:messages');

      expect(result, false);
    });
  });

  group('checkPermissions', () {
    test('calls POST check-batch endpoint', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'read:messages': true,
                  'write:messages': false,
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await permissionService
          .checkPermissions(['read:messages', 'write:messages']);

      expect(result['read:messages'], true);
      expect(result['write:messages'], false);
      verify(() => mockApiClient.post(
            '/api/permissions/v1/users/me/check-batch',
            data: {
              'permissions': ['read:messages', 'write:messages']
            },
          )).called(1);
    });

    test('returns all false on error', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(Exception('network error'));

      final result = await permissionService
          .checkPermissions(['read:messages', 'write:messages']);

      expect(result['read:messages'], false);
      expect(result['write:messages'], false);
    });
  });

  group('assignRole', () {
    test('calls POST with userId and roleId', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      await permissionService.assignRole(
        userId: 'user-1',
        roleId: 'role-1',
      );

      verify(() => mockApiClient.post(
            '/api/permissions/v1/users/user-1/roles',
            data: {'roleId': 'role-1'},
          )).called(1);
    });
  });

  group('removeRole', () {
    test('calls DELETE with userId and roleId', () async {
      when(() => mockApiClient.delete(any()))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      await permissionService.removeRole(
        userId: 'user-1',
        roleId: 'role-1',
      );

      verify(() => mockApiClient
          .delete('/api/permissions/v1/users/user-1/roles/role-1')).called(1);
    });
  });
}
