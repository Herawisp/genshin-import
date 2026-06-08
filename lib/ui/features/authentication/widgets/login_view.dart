import 'package:flutter/material.dart';
import 'package:genshin_import/data/services/auth_session.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/double_text_field.dart';
import 'package:genshin_import/ui/features/authentication/view_models/login_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppbar(icon: Icons.arrow_back),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),

        child: Column(
          spacing: 32,

          children: [
            DoubleTextField(
              labelText: "Enter your information here",
              topFieldHintText: "Email address",
              bottomFieldHintText: "Password",
              topFieldController: _emailController,
              bottomFieldController: _passwordController,
              errorText: viewModel.errorMessage,
              bottomFieldIsPassword: true,
            ),

            Column(
              spacing: 16,

              children: [
                CustomButton(
                  label: "LOG IN",
                  oneShot: true,
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final success = await viewModel.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (success && context.mounted) {
                            context.go(AuthSession.homeRoute);
                          }
                        },
                ),

                TextButton(
                  onPressed: () => context.push('/forgot_password'),
                  child: Text(
                    "FORGOT PASSWORD",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.myColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            CustomButton(
              label: "GOOGLE",
              variant: ButtonVariant.neutral,
              outlined: true,
              oneShot: true,
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final success = await viewModel.loginWithGoogle();

                      if (success && context.mounted) {
                        context.go(AuthSession.homeRoute);
                      }
                    },
              icon: Image.asset('assets/images/Google.png', height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
