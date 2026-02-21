import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/bloc/auth/auth_bloc.dart';

/// Helper to retrieve the test OTP code from the AuthBloc state.
///
/// The auth-service in dev mode returns `testOtp` in the OTP request response.
/// We capture it in AuthState so integration tests can read it without a
/// separate API call.
class TestOtpHelper {
  /// Reads testOtp from AuthBloc state after an OTP request has been made.
  static String getTestOtpFromBloc(WidgetTester tester) {
    // Find the MaterialApp to get a valid BuildContext
    final element = tester.element(find.byType(MaterialApp).first);
    final authBloc = element.read<AuthBloc>();
    final testOtp = authBloc.state.testOtp;

    if (testOtp == null || testOtp.isEmpty) {
      throw Exception(
        'testOtp not available in AuthBloc state. '
        'Ensure the auth-service returns testOtp in dev mode '
        'and OtpRequestResponse captures it.',
      );
    }
    return testOtp;
  }
}
