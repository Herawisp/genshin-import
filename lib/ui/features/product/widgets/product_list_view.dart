import 'package:flutter/material.dart';
import 'package:genshin_import/data/models/weapon.dart';
import 'package:genshin_import/data/services/weapon_api_service.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/section_header.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/cards/product_card.dart';
import 'package:go_router/go_router.dart';

class ProductListView extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showActions;
  final bool deletionOnProductTap;
  final bool showCreateButton;
  final bool useAdminWeapons;

  const ProductListView({
    super.key,
    required this.title,
    required this.subtitle,
    this.showActions = false,
    required this.deletionOnProductTap,
    this.showCreateButton = false,
    this.useAdminWeapons = false,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final WeaponApiService _weaponApiService = WeaponApiService();
  late Future<List<Weapon>> _weaponsFuture;

  @override
  void initState() {
    super.initState();
    _weaponsFuture = _loadWeapons();
  }

  Future<List<Weapon>> _loadWeapons() {
    if (widget.useAdminWeapons) {
      return _weaponApiService.getAdminWeapons();
    }

    return _weaponApiService.getWeapons();
  }

  void _reloadWeapons() {
    setState(() {
      _weaponsFuture = _loadWeapons();
    });
  }

  Future<void> _openCreateForm() async {
    final changed = await context.push<bool>('/admin/product-form');

    if (changed == true) {
      _reloadWeapons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: widget.title, subtitle: widget.subtitle),
        if (widget.showCreateButton)
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
            child: CustomButton(
              label: 'CREATE WEAPON',
              onPressed: _openCreateForm,
            ),
          ),
        Expanded(
          child: FutureBuilder<List<Weapon>>(
            future: _weaponsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return ProductStatusView(
                  icon: Icons.cloud_off,
                  title: 'Unable to load weapons',
                  message: snapshot.error.toString(),
                  actionLabel: 'RETRY',
                  onAction: _reloadWeapons,
                );
              }

              final weapons = snapshot.data ?? [];

              if (weapons.isEmpty) {
                return const ProductStatusView(
                  icon: Icons.inventory_2_outlined,
                  title: 'No weapons found',
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
                itemCount: weapons.length,
                itemBuilder: (context, index) {
                  final weapon = weapons[index];

                  return ProductCard(
                    weapon: weapon,
                    showActions: widget.showActions,
                    deletionPage: widget.deletionOnProductTap,
                    onChanged: _reloadWeapons,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductStatusView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ProductStatusView({
    super.key,
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
