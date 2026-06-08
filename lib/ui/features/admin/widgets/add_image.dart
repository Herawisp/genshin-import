import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class AddImagePlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final double size;

  const AddImagePlaceholder({
    super.key,
    required this.onTap,
    this.imagePath = '',
    this.size = 150, // Default bounding box size (width & height)
  });

  @override
  Widget build(BuildContext context) {
    final trimmedImagePath = imagePath.trim();

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
          color: context.myColors.neutralDark!.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: trimmedImagePath.isEmpty
              ? Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: size * 0.45,
                    color: context.myColors.neutralDark,
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    _ImagePreview(imagePath: trimmedImagePath),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: context.myColors.neutralLightest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: context.myColors.neutralDarkest,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String imagePath;

  const _ImagePreview({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(context),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(context),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) {
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 48,
        color: context.myColors.neutralDark,
      ),
    );
  }
}
