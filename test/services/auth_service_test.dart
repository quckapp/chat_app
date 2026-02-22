import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:chat_app/core/exceptions/api_exception.dart';
import 'package:chat_app/core/network/api_client.dart';
import 'package:chat_app/core/storage/secure_storage.dart';
import 'package:chat_app/services/auth_service.dart';

import '../helpers/test_helpers.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockApiClient mockApiClient;
  late MockSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorage = MockSecureStorage();
    authService = AuthService(apiClient: mockApiClient, storage: mockStorage);
  });

  group('requestOtp', () {
    test('calls POST, stores phone in SecureStorage, returns OtpRequestResponse',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': true,
                  'maskedPhone': '+91****3210',
                  'expiresInSeconds': 300,
                  'resendCooldownSeconds': 60,
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      when(() => mockStorage.saveVerificationData(
            verificationId: any(named: 'verificationId'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async {});

      final result = await authService.requestOtp(phoneNumber: '+919876543210');

      expect(result.maskedPhone, '+91****3210');
      expect(result.expiresInSeconds, 300);
      expect(result.resendCooldownSeconds, 60);
      verify(() => mockApiClient.post(
            '/v1/auth/phone/request-otp',
            data: {'phoneNumber': '+919876543210'},
          )).called(1);
      verify(() => mockStorage.saveVerificationData(
            verificationId: '',
            phoneNumber: '+919876543210',
          )).called(1);
    });

    test('throws ApiException when success != true', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': false,
                  'message': 'Rate limited',
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      expect(
        () => authService.requestOtp(phoneNumber: '+919876543210'),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Rate limited',
        )),
      );
    });
  });

  group('loginWithOtp', () {
    test('calls POST, saves auth data to storage, clears verification data',
        () async {
      final user = makeUser();
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': true,
                  'accessToken': 'access-123',
                  'refreshToken': 'refresh-456',
                  'user': user.toJson(),
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});
      when(() => mockStorage.saveUserInfo(
            id: any(named: 'id'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async {});
      when(() => mockStorage.clearVerificationData())
          .thenAnswer((_) async {});

      final result = await authService.loginWithOtp(
        phoneNumber: '+919876543210',
        code: '123456',
      );

      expect(result.accessToken, 'access-123');
      expect(result.refreshToken, 'refresh-456');
      expect(result.user.id, user.id);
      verify(() => mockStorage.saveTokens(
            accessToken: 'access-123',
            refreshToken: 'refresh-456',
          )).called(1);
      verify(() => mockStorage.saveUserInfo(
            id: user.id,
            phoneNumber: user.phoneNumber,
          )).called(1);
      verify(() => mockStorage.clearVerificationData()).called(1);
    });

    test('throws ApiException when success != true (with remainingAttempts message)',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': false,
                  'message': 'Invalid OTP',
                  'remainingAttempts': 2,
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      expect(
        () => authService.loginWithOtp(
          phoneNumber: '+919876543210',
          code: '000000',
        ),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Invalid OTP (2 attempts remaining)',
        )),
      );
    });
  });

  group('resendOtp', () {
    test('reads phone from storage and delegates to requestOtp', () async {
      when(() => mockStorage.getPhoneNumber())
          .thenAnswer((_) async => '+919876543210');
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': true,
                  'maskedPhone': '+91****3210',
                  'expiresInSeconds': 300,
                  'resendCooldownSeconds': 60,
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      when(() => mockStorage.saveVerificationData(
            verificationId: any(named: 'verificationId'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async {});

      final result = await authService.resendOtp();

      expect(result.maskedPhone, '+91****3210');
      verify(() => mockStorage.getPhoneNumber()).called(1);
      verify(() => mockApiClient.post(
            '/v1/auth/phone/request-otp',
            data: {'phoneNumber': '+919876543210'},
          )).called(1);
    });

    test('throws when no phone number stored', () async {
      when(() => mockStorage.getPhoneNumber())
          .thenAnswer((_) async => null);

      expect(
        () => authService.resendOtp(),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          'No phone number found',
        )),
      );
    });
  });

  group('logout', () {
    test('calls POST, signs out Google, clears storage (ignores errors from each step)',
        () async {
      when(() => mockApiClient.post(any()))
          .thenThrow(Exception('network error'));
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      // Should not throw even though backend call fails
      await authService.logout();

      verify(() => mockApiClient.post('/v1/logout')).called(1);
      verify(() => mockStorage.clearAll()).called(1);
    });
  });

  group('refreshToken', () {
    test('reads refresh token from storage, calls POST, saves new auth data',
        () async {
      final user = makeUser();
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'old-refresh');
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'accessToken': 'new-access',
                  'refreshToken': 'new-refresh',
                  'user': user.toJson(),
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));
      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});
      when(() => mockStorage.saveUserInfo(
            id: any(named: 'id'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async {});

      final result = await authService.refreshToken();

      expect(result.accessToken, 'new-access');
      expect(result.refreshToken, 'new-refresh');
      verify(() => mockStorage.getRefreshToken()).called(1);
      verify(() => mockApiClient.post(
            '/v1/token/refresh',
            data: {'refreshToken': 'old-refresh'},
          )).called(1);
      verify(() => mockStorage.saveTokens(
            accessToken: 'new-access',
            refreshToken: 'new-refresh',
          )).called(1);
    });

    test('throws UnauthorizedException when no refresh token', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => null);

      expect(
        () => authService.refreshToken(),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });

  group('getCurrentUser', () {
    test('calls GET /me endpoint', () async {
      final user = makeUser();
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => Response(
                data: user.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await authService.getCurrentUser();

      expect(result.id, user.id);
      expect(result.phoneNumber, user.phoneNumber);
      verify(() => mockApiClient.get('/v1/users/me')).called(1);
    });
  });

  group('isLoggedIn', () {
    test('delegates to storage.hasTokens', () async {
      when(() => mockStorage.hasTokens()).thenAnswer((_) async => true);

      final result = await authService.isLoggedIn();

      expect(result, true);
      verify(() => mockStorage.hasTokens()).called(1);
    });
  });

  group('updateProfile', () {
    test('sends displayName (constructed from firstName/lastName if needed)',
        () async {
      final user = makeUser(firstName: 'Jane', lastName: 'Smith');
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: user.toJson(),
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await authService.updateProfile(
        firstName: 'Jane',
        lastName: 'Smith',
      );

      expect(result.id, user.id);
      verify(() => mockApiClient.put(
            '/v1/users/me',
            data: {'displayName': 'Jane Smith'},
          )).called(1);
    });

    test('handles wrapped response {user: {...}} format', () async {
      final user = makeUser(displayName: 'Jane Smith');
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': true,
                  'user': user.toJson(),
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      final result = await authService.updateProfile(
        displayName: 'Jane Smith',
      );

      expect(result.id, user.id);
    });
  });

  group('verifyEmailOtp', () {
    test('throws with remainingAttempts when success != true', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'success': false,
                  'message': 'Invalid code',
                  'remainingAttempts': 1,
                },
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      expect(
        () => authService.verifyEmailOtp(
          email: 'test@test.com',
          code: '000000',
        ),
        throwsA(isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Invalid code (1 attempts remaining)',
        )),
      );
    });
  });
}
