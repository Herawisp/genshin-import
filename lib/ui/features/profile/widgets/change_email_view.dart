import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({ super.key, });

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ChangeEmailViewState extends State<ChangeEmailView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isButtonEnabled = false;

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
      _isButtonEnabled = emailText.isNotEmpty && passwordText.isNotEmpty;
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
                child: CustomButton(
                  label: 'DONE', 
                  onPressed: _isButtonEnabled 
                      ? () async {
                          FocusScope.of(context).unfocus();
                          final newEmail = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          print('Saving email: $newEmail');
                          print('Password: $password');
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
