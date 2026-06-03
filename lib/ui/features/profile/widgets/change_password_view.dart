import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({ super.key, });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isButtonEnabled = false;

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
      _isButtonEnabled = oldPasswordText.isNotEmpty && newPasswordText.isNotEmpty && confirmPasswordText.isNotEmpty;
    });
  }

  /* ================================================================================================= */

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
                child: CustomButton(
                  label: 'DONE', 
                  onPressed: _isButtonEnabled 
                      ? () async {
                          FocusScope.of(context).unfocus();
                          final oldPassword = _oldPasswordController.text.trim();
                          final newPassword = _newPasswordController.text.trim();
                          print('Current password: $oldPassword');
                          print('New password: $newPassword');
                        }
                      : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
