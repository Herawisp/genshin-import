import 'package:flutter/material.dart';
import 'package:genshin_import/data/models/inventory_item.dart';
import 'package:genshin_import/data/services/inventory_api_service.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/section_header.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/cards/product_card.dart'
    show ProductStat, WeaponImage;
import 'package:go_router/go_router.dart';

class InventoryView extends StatefulWidget {
  final int refreshToken;

  const InventoryView({super.key, this.refreshToken = 0});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final InventoryApiService _inventoryApiService = InventoryApiService();
  late Future<InventoryResult> _inventoryFuture;

  @override
  void initState() {
    super.initState();
    _inventoryFuture = _inventoryApiService.getInventory();
  }

  @override
  void didUpdateWidget(covariant InventoryView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshToken != widget.refreshToken) {
      _inventoryFuture = _inventoryApiService.getInventory();
    }
  }

  void _reloadInventory() {
    setState(() {
      _inventoryFuture = _inventoryApiService.getInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InventoryResult>(
      future: _inventoryFuture,
      builder: (context, snapshot) {
        final ownedItemTypes = snapshot.data?.items.length ?? 0;

        return Column(
          children: [
            SectionHeader(
              title: 'INVENTORY',
              subtitle: 'You own $ownedItemTypes items',
            ),
            Expanded(
              child: _InventoryContent(
                snapshot: snapshot,
                onRetry: _reloadInventory,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InventoryContent extends StatelessWidget {
  final AsyncSnapshot<InventoryResult> snapshot;
  final VoidCallback onRetry;

  const _InventoryContent({required this.snapshot, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return _InventoryStatusView(
        icon: Icons.cloud_off,
        title: 'Unable to load inventory',
        message: snapshot.error.toString(),
        actionLabel: 'RETRY',
        onAction: onRetry,
      );
    }

    final items = snapshot.data?.items ?? [];

    if (items.isEmpty) {
      return const _InventoryStatusView(
        icon: Icons.inventory_2_outlined,
        title: 'No weapons owned',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return InventoryCard(item: items[index], onChanged: onRetry);
      },
    );
  }
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback? onChanged;

  const InventoryCard({super.key, required this.item, this.onChanged});

  Future<void> _openDetail(BuildContext context) async {
    final changed = await context.push<bool>(
      '/product_detail',
      extra: {
        'weaponId': item.weapon.id,
        'deletionPage': false,
        'inventoryQuantity': item.quantity,
      },
    );

    if (changed == true) {
      onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final weapon = item.weapon;

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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    weapon.name,
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
                      ProductStat(
                        label: item.quantity.toString(),
                        icon: Icons.inventory,
                      ),
                      ProductStat(
                        label: '\$${weapon.formattedPrice}',
                        icon: Icons.local_offer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryStatusView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _InventoryStatusView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Icon(icon, size: 48, color: context.myColors.primary),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.myColors.neutralDarkest,
              ),
            ),
            if (message != null && message!.isNotEmpty)
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.myColors.neutralMidDark,
                ),
              ),
            if (actionLabel != null && onAction != null)
              CustomButton(
                label: actionLabel!,
                onPressed: () async => onAction!(),
                variant: ButtonVariant.neutral,
                outlined: true,
              ),
          ],
        ),
      ),
    );
  }
}
