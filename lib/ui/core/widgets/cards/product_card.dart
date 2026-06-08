import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genshin_import/data/models/weapon.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final Weapon weapon;
  final bool showActions;
  final bool deletionPage;
  final VoidCallback? onChanged;

  const ProductCard({
    super.key,
    required this.weapon,
    this.showActions = false,
    required this.deletionPage,
    this.onChanged,
  });

  Future<void> _openDetail(BuildContext context) async {
    final changed = await context.push<bool>(
      '/product_detail',
      extra: {'weaponId': weapon.id, 'deletionPage': deletionPage},
    );

    if (changed == true) {
      onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        width: 150,
        height: 215,
        decoration: ShapeDecoration(
          color: context.myColors.neutralMidLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Product_card_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: WeaponImage(
                        image: weapon.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (showActions)
                      ActionButtons(weapon: weapon, onChanged: onChanged),
                  ],
                ),
              ),
            ),
            ProductInfo(
              productName: weapon.name,
              stock: weapon.stock,
              price: weapon.formattedPrice,
            ),
          ],
        ),
      ),
    );
  }
}

class WeaponImage extends StatelessWidget {
  final String image;
  final BoxFit fit;

  const WeaponImage({super.key, required this.image, required this.fit});

  @override
  Widget build(BuildContext context) {
    final imagePath = image.trim();

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: fit,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.file(
      File(imagePath),
      fit: fit,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Image.asset('assets/images/Weapon_image.png', fit: fit);
  }
}

class ActionButtons extends StatelessWidget {
  final Weapon weapon;
  final VoidCallback? onChanged;

  const ActionButtons({super.key, required this.weapon, this.onChanged});

  Future<void> _openForm(BuildContext context) async {
    final changed = await context.push<bool>(
      '/admin/product-form',
      extra: {'weapon': weapon},
    );

    if (changed == true) {
      onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 4,
        children: [
          CustomIconButton(
            icon: Icons.edit,
            onPressed: () => _openForm(context),
            color: context.myColors.neutralLightest,
          ),
        ],
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final String productName;
  final int stock;
  final String price;

  const ProductInfo({
    super.key,
    required this.productName,
    required this.stock,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            productName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
          ),
          Divider(height: 1, color: context.myColors.neutralLight),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              ProductStat(label: stock.toString(), icon: Icons.inventory),
              ProductStat(label: '\$$price', icon: Icons.local_offer),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon),
      color: color ?? context.myColors.neutralLightest,
      onPressed: onPressed,
    );
  }
}

class ProductStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProductStat({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Icon(icon, color: context.myColors.primary, size: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.myColors.neutralDarkest,
          ),
        ),
      ],
    );
  }
}
