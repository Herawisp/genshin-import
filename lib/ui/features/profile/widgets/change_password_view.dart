import 'package:flutter/material.dart';
import 'package:genshin_import/data/services/auth_api_service.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final AuthApiService _authApiService = AuthApiService();
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isButtonEnabled = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _oldPasswordController.addListener(_onTextChanged);
    _newPasswordController.addListener(_onTextChanged);
    _confirmPasswordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _oldPasswordController.removeListener(_onTextChanged);
    _newPasswordController.removeListener(_onTextChanged);
    _confirmPasswordController.removeListener(_onTextChanged);
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final oldPasswordText = _oldPasswordController.text.trim();
    final newPasswordText = _newPasswordController.text.trim();
    final confirmPasswordText = _confirmPasswordController.text.trim();

    setState(() {
      _isButtonEnabled =
          oldPasswordText.isNotEmpty &&
          newPasswordText.isNotEmpty &&
          confirmPasswordText.isNotEmpty &&
          !_isSaving;
    });
  }

  /* ================================================================================================= */

  Future<void> _savePassword() async {
    final currentPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      setState(() => _errorMessage = 'Current password is required');
      return;
    }

    if (newPassword.isEmpty) {
      setState(() => _errorMessage = 'New password is required');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => _errorMessage = 'Confirm password does not match');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _authApiService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      context.pop(true);
    } on AuthApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to update password');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
        _onTextChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        appBar: CustomAppbar(
          icon: Icons.arrow_back,
          titleText: 'Change Password',
          showTitleText: true,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              SingleTextField(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
                controller: _oldPasswordController,
                isPassword: true,
              ),

              SingleTextField(
                labelText: 'New Password',
                hintText: 'Enter your new password',
                controller: _newPasswordController,
                isPassword: true,
              ),

              SingleTextField(
                labelText: 'Confirm New Password',
                hintText: 'Enter your new password again',
                controller: _confirmPasswordController,
                isPassword: true,
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  spacing: 16,
                  children: [
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.myColors.error,
                        ),
                      ),
                    CustomButton(
                      label: 'DONE',
                      onPressed: _isButtonEnabled ? _savePassword : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
