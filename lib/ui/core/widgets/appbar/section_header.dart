import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

class SectionHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(
        left: 16, right: 16, 
        top: 32, bottom: 16
      ),

      decoration: BoxDecoration(
        color: context.myColors.neutralLightest,
        
        border: Border(
          bottom: BorderSide(
            color: context.myColors.neutralDarkest!,
            width: 1
          )
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ]
      ),

      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.myColors.neutralDarkest
              ),
            ),
              
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.myColors.neutralMidDark
              ),
            ),
          ],
        ),
      ),
    );
  }
}