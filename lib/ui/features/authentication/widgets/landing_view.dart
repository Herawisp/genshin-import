import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:go_router/go_router.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),

          child: Column(
            spacing: 16,

            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              
              Column(
                spacing: 16,
                children: [
                  CustomButton(
                    label: "CREATE NEW ACCOUNT", 
                    onPressed: () => context.push('/signup'),
                  ),
                  CustomButton(
                    label: "I ALREADY HAVE AN ACCOUNT", 
                    onPressed: () => context.push('/login'),
                    variant: ButtonVariant.neutral,
                    outlined: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}