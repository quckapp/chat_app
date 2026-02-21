import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../core/theme/theme.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  bool _isEnabled = false;
  String _selectedMethod = 'authenticator';
  final _codeController = TextEditingController();
  bool _isVerifying = false;
  bool _showVerification = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: _isEnabled ? Colors.green : AppColors.grey400,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Two-Factor Authentication',
                                  style: AppTypography.headlineSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _isEnabled ? 'Enabled' : 'Disabled',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: _isEnabled ? Colors.green : AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isEnabled,
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  _showVerification = true;
                                } else {
                                  _isEnabled = false;
                                  _showVerification = false;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (!_isEnabled) ...[
                Text('Method', style: AppTypography.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                RadioListTile<String>(
                  title: const Text('Authenticator App'),
                  subtitle: const Text('Use an authenticator app like Google Authenticator'),
                  value: 'authenticator',
                  groupValue: _selectedMethod,
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedMethod = v);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('SMS'),
                  subtitle: const Text('Receive codes via text message'),
                  value: 'sms',
                  groupValue: _selectedMethod,
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedMethod = v);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Email'),
                  subtitle: const Text('Receive codes via email'),
                  value: 'email',
                  groupValue: _selectedMethod,
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedMethod = v);
                  },
                ),
              ],
              if (_showVerification && !_isEnabled) ...[
                const SizedBox(height: AppSpacing.lg),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify Setup',
                          style: AppTypography.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Enter the verification code to enable 2FA',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            labelText: 'Verification Code',
                            hintText: 'Enter 6-digit code',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isVerifying ? null : _verifyCode,
                            child: _isVerifying
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Verify and Enable'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_isEnabled) ...[
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active Method', style: AppTypography.headlineSmall),
                        const SizedBox(height: AppSpacing.sm),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text(_selectedMethod == 'authenticator'
                              ? 'Authenticator App'
                              : _selectedMethod == 'sms'
                                  ? 'SMS'
                                  : 'Email'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _verifyCode() {
    if (_codeController.text.trim().length == 6) {
      setState(() => _isVerifying = true);
      // Simulate verification
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isVerifying = false;
            _isEnabled = true;
            _showVerification = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Two-factor authentication enabled'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    }
  }
}
