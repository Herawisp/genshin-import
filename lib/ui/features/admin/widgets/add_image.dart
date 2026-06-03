import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class AddImagePlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const AddImagePlaceholder({
    super.key,
    required this.onTap,
    this.size = 150, // Default bounding box size (width & height)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // Outer box background color
        color: context.myColors.neutralMidLight, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Subtle border wrapper visible in the design
          color: context.myColors.neutralDark!.withOpacity(0.3), 
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              Icons.add_photo_alternate_outlined, // Perfect match for the "image with a plus sign" look
              size: size * 0.45, // Scales the icon proportionally to the container box
              color: context.myColors.neutralDark, // Placed centered placeholder color tint
            ),
          ),
        ),
      ),
    );
  }
}