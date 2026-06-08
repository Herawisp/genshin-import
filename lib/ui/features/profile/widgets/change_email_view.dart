import 'package:flutter/material.dart';
import 'package:genshin_import/data/services/auth_api_service.dart';
import 'package:genshin_import/data/services/auth_session.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({super.key});

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ChangeEmailViewState extends State<ChangeEmailView> {
  final AuthApiService _authApiService = AuthApiService();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isButtonEnabled = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final emailText = _emailController.text.trim();
    final passwordText = _passwordController.text.trim();

    setState(() {
      _isButtonEnabled =
          emailText.isNotEmpty && passwordText.isNotEmpty && !_isSaving;
    });
  }

  /* ================================================================================================= */

  Future<void> _saveEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Email is required');
      return;
    }

    if (password.isEmpty) {
      setState(() => _errorMessage = 'Password is required');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _authApiService.updateEmail(email: email, password: password);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email updated successfully')),
      );
      context.pop(true);
    } on AuthApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to update email');
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
    final currentEmail = AuthSession.user?['email']?.toString() ?? '-';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        appBar: CustomAppbar(
          icon: Icons.arrow_back,
          titleText: 'Change Email',
          showTitleText: true,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              SingleTextField(
                labelText: 'New Email Address',
                hintText: 'Enter your new email',
                supportingText: 'Current email: $currentEmail',
                controller: _emailController,
              ),

              SingleTextField(
                labelText: 'Password',
                hintText: 'Enter your password to confirm',
                isPassword: true,
                controller: _passwordController,
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
                      onPressed: _isButtonEnabled ? _saveEmail : null,
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
