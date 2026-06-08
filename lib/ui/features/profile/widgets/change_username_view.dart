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

class ChangeUsernameView extends StatefulWidget {
  const ChangeUsernameView({super.key});

  @override
  State<ChangeUsernameView> createState() => _ChangeUsernameViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ChangeUsernameViewState extends State<ChangeUsernameView> {
  final AuthApiService _authApiService = AuthApiService();
  late final TextEditingController _usernameController;
  bool _isButtonEnabled = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _usernameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onTextChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _usernameController.text.trim();
    setState(() {
      _isButtonEnabled = text.isNotEmpty && !_isSaving;
    });
  }

  /* ================================================================================================= */

  Future<void> _saveUsername() async {
    final name = _usernameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Username is required');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _authApiService.updateName(name: name);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully')),
      );
      context.pop(true);
    } on AuthApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to update username');
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
    final currentName = AuthSession.user?['name']?.toString() ?? 'Guest';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
        appBar: CustomAppbar(
          icon: Icons.arrow_back,
          titleText: 'Change Username',
          showTitleText: true,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 32,
            children: [
              SingleTextField(
                labelText: 'Username',
                hintText: 'Enter your new username',
                supportingText: 'Current username: $currentName',
                controller: _usernameController,
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
                      onPressed: _isButtonEnabled ? _saveUsername : null,
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
