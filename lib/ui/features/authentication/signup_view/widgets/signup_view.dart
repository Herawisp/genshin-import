import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/double_text_field.dart';
import 'package:genshin_import/ui/features/authentication/signup_view/view_models/signup_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
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

  Future<void> _onSignup(SignupViewModel viewModel) async {
    if (viewModel.isLoading) return;

    final success = await viewModel.register(
      email: _emailController.text,
      password: _passwordController.text,
    );
    
    if (success && context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: const CustomAppbar(icon: Icons.arrow_back),
      
      body: SafeArea(
        child: Padding(
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
                onBottomFieldSubmitted: (_) => _onSignup(viewModel),
              ),

              CustomButton(
                label: "SIGN UP", 
                oneShot: true,
                onPressed: viewModel.isLoading ? null : () => _onSignup(viewModel),
              ),

              const Spacer(),

              CustomButton(
                icon: Image.asset(
                  'assets/images/Google.png',
                  height: 24,
                ),
                label: "GOOGLE",
                variant: ButtonVariant.neutral,
                outlined: true,
                onPressed: viewModel.isLoading ? null : () async {
                  // TODO: implement Google Sign in through ViewModel
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}