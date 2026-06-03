import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';

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
  late final TextEditingController _usernameController;
  bool _isButtonEnabled = false;

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
      _isButtonEnabled = text.isNotEmpty;
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
                supportingText: 'Current username: John Doe',
                controller: _usernameController, 
              ),

              const Spacer(),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomButton(
                  label: 'DONE', 
                  onPressed: _isButtonEnabled 
                      ? () async {
                          FocusScope.of(context).unfocus();
                          final newUsername = _usernameController.text.trim();
                          print('Saving username: $newUsername');
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
