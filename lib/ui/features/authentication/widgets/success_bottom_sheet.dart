import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:go_router/go_router.dart';

void showSuccessBottomSheet({
  required BuildContext context,
  required String email,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    ),
    builder: (modalContext) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.myColors.neutralLightest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              // GRAB HANDLER
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: context.myColors.neutralDarkest,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              Text(
                "Check your email!",
                style: Theme.of(modalContext).textTheme.labelLarge?.copyWith(
                  color: context.myColors.neutralDarkest,
                ),
              ),

              Text.rich(
                TextSpan(
                  text: "We’ve sent an email to ",
                  children: [
                    TextSpan(
                      text: email,
                      style: Theme.of(modalContext).textTheme.labelSmall
                          ?.copyWith(color: context.myColors.neutralDarkest),
                    ),
                    TextSpan(
                      text:
                          ".\nDidn’t receive it? Check your spam folder and try again.",
                      style: Theme.of(modalContext).textTheme.bodySmall
                          ?.copyWith(color: context.myColors.neutralDarkest),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: Theme.of(modalContext).textTheme.bodySmall?.copyWith(
                  color: context.myColors.neutralDarkest,
                ),
              ),

              CustomButton(
                label: "OK",
                onPressed: () async {
                  Navigator.pop(modalContext);
                  context.pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
