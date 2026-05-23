import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';
import 'package:genshin_import/ui/features/authentication/forgot_password_view/view_models/forgot_password_view_model.dart';
import 'package:genshin_import/ui/features/authentication/forgot_password_view/widgets/success_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: const CustomAppbar(icon: Icons.arrow_back),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          spacing: 32,
          children: [
            SingleTextField(
              controller: _emailController,
              labelText: "Forgot password?",
              hintText: "Email address",
              supportingText: "Enter your email address to receive a link to reset your password.",
              errorText: viewModel.errorMessage,
            ),

            const Spacer(),

            CustomButton(
              label: "NEXT", 
              oneShot: true,
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final currentEmail = _emailController.text;
                      final success = await viewModel.sendPasswordReset(currentEmail);
                      
                      if (success && context.mounted) {
                        showSuccessBottomSheet(
                          context: context, 
                          email: currentEmail
                        );
                      }
                    },
            )
          ],
        ),
      ),
    );
  }
}