import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final bool centerTitle;
  final String? titleText;
  final bool showTitleText;
  final VoidCallback? onBackPress;
  final Color? iconColor;

  const CustomAppbar({
    super.key,
    required this.icon,
    this.showTitleText = false,
    this.centerTitle = false,
    this.titleText,
    this.onBackPress,
    this.iconColor,
  });
  
  /* ================================================================================== */
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,

      leading: IconButton(
        icon: Icon(
          icon, 
          size: 24, 
          color: iconColor ?? context.myColors.neutralDarkest,
        ),
        color: context.myColors.neutralDarkest,
        onPressed: onBackPress ?? () => Navigator.of(context).pop(),
      ),

      title: showTitleText ? Text(
        titleText!,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: context.myColors.neutralDarkest,
        )
      ) : null
    );
  }

  /* ================================================================================== */
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}