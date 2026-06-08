import 'package:flutter/material.dart';
import 'package:genshin_import/data/models/weapon.dart';
import 'package:genshin_import/data/services/inventory_api_service.dart';
import 'package:genshin_import/data/services/weapon_api_service.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/cards/product_card.dart'
    show WeaponImage;
import 'package:genshin_import/ui/features/product/widgets/confirmation_dialog.dart';
import 'package:genshin_import/ui/features/product/widgets/payment_dialog.dart';
import 'package:go_router/go_router.dart';

class ProductDetailView extends StatefulWidget {
  final int weaponId;
  final bool deletionPage;
  final int? inventoryQuantity;

  const ProductDetailView({
    super.key,
    required this.weaponId,
    required this.deletionPage,
    this.inventoryQuantity,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final WeaponApiService _weaponApiService = WeaponApiService();
  final InventoryApiService _inventoryApiService = InventoryApiService();
  late Future<Weapon> _weaponFuture;
  int _quantity = 1;
  bool _isSubmitting = false;
  String? _actionError;

  bool get _isInventoryPage => widget.inventoryQuantity != null;

  @override
  void initState() {
    super.initState();
    _weaponFuture = _weaponApiService.getWeapon(widget.weaponId);
  }

  void _reloadWeapon() {
    setState(() {
      _weaponFuture = _weaponApiService.getWeapon(widget.weaponId);
    });
  }

  void _changeQuantity(int delta, int stock) {
    final maxQuantity = stock < 1 ? 1 : stock;
    final nextQuantity = (_quantity + delta).clamp(1, maxQuantity);

    setState(() {
      _quantity = nextQuantity;
      _actionError = null;
    });
  }

  void _showConfirmation(BuildContext context, Weapon weapon) {
    if (!widget.deletionPage && !_isInventoryPage) {
      _openPaymentDetails(context, weapon);
      return;
    }

    final itemLabel = _quantity == 1 ? 'item' : 'items';
    final warningMessage = _isInventoryPage
        ? 'Deleting $_quantity $itemLabel will remove it from your inventory permanently'
        : 'Deleting this item will remove it from the store permanently';

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: context.myColors.darken,
      builder: (dialogContext) {
        return ConfirmationDialog(
          title: 'Delete item?',
          subtitle:
              'Are you sure you want to delete this item?\nThis action cannot be undone.',
          deletionPage: true,
          quantity: _quantity,
          totalPrice: weapon.price * _quantity,
          warningMessage: warningMessage,
          onCancel: () async => dialogContext.pop(),
          onAccept: () async {
            if (_isInventoryPage) {
              await _deleteInventoryItem(dialogContext, weapon);
              return;
            }

            await _deleteWeapon(dialogContext, weapon);
          },
        );
      },
    );
  }

  void _openPaymentDetails(BuildContext context, Weapon weapon) {
    if (weapon.stock <= 0) {
      setState(() => _actionError = 'Weapon is out of stock');
      return;
    }

    if (_quantity < 1) {
      setState(() => _actionError = 'Quantity must be greater than 0');
      return;
    }

    if (_quantity > weapon.stock) {
      setState(() => _actionError = 'Quantity cannot exceed stock');
      return;
    }

    setState(() => _actionError = null);

    final totalAmount = weapon.price * _quantity;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: context.myColors.darken,
      builder: (detailsContext) {
        return PaymentDetailsDialog(
          totalAmount: totalAmount,
          onCancel: () async => Navigator.of(detailsContext).pop(),
          onPayNow: () async {
            Navigator.of(detailsContext).pop();
            _openWaitingForPayment(context, weapon, totalAmount);
          },
        );
      },
    );
  }

  void _openWaitingForPayment(
    BuildContext context,
    Weapon weapon,
    double totalAmount,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: context.myColors.darken,
      builder: (waitingContext) {
        return WaitingForPaymentDialog(
          totalAmount: totalAmount,
          onRefresh: () =>
              _completePayment(waitingContext, weapon, totalAmount),
        );
      },
    );
  }

  Future<String?> _completePayment(
    BuildContext dialogContext,
    Weapon weapon,
    double totalAmount,
  ) async {
    setState(() {
      _isSubmitting = true;
      _actionError = null;
    });

    try {
      await _weaponApiService.buyWeapon(id: weapon.id, quantity: _quantity);

      if (dialogContext.mounted) {
        Navigator.of(dialogContext).pop();
      }

      if (!mounted) return null;

      setState(() {
        _quantity = 1;
      });
      _reloadWeapon();

      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: context.myColors.darken,
        builder: (successContext) {
          return PaymentSuccessfulDialog(
            totalAmount: totalAmount,
            onBackToShop: () async {
              Navigator.of(successContext).pop();

              if (context.mounted && context.canPop()) {
                context.pop(true);
              }
            },
          );
        },
      );

      return null;
    } on WeaponApiException catch (error) {
      return error.message;
    } catch (_) {
      return 'Unable to confirm payment';
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteWeapon(BuildContext dialogContext, Weapon weapon) async {
    setState(() {
      _isSubmitting = true;
      _actionError = null;
    });

    try {
      await _weaponApiService.deleteWeapon(weapon.id);

      if (dialogContext.mounted) {
        dialogContext.pop();
      }

      if (mounted) {
        context.pop(true);
      }
    } on WeaponApiException catch (error) {
      if (mounted) {
        setState(() => _actionError = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _actionError = 'Unable to delete weapon');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteInventoryItem(
    BuildContext dialogContext,
    Weapon weapon,
  ) async {
    setState(() {
      _isSubmitting = true;
      _actionError = null;
    });

    try {
      await _inventoryApiService.deleteInventoryItem(
        itemId: weapon.id,
        quantity: _quantity,
      );

      if (dialogContext.mounted) {
        dialogContext.pop();
      }

      if (mounted) {
        context.pop(true);
      }
    } on InventoryApiException catch (error) {
      if (mounted) {
        setState(() => _actionError = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _actionError = 'Unable to delete inventory item');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _updateWeaponVisibility(Weapon weapon) async {
    setState(() {
      _isSubmitting = true;
      _actionError = null;
    });

    try {
      await _weaponApiService.updateWeaponVisibility(
        id: weapon.id,
        isHidden: !weapon.isHidden,
      );

      if (mounted) {
        context.pop(true);
      }
    } on WeaponApiException catch (error) {
      if (mounted) {
        setState(() => _actionError = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _actionError = 'Unable to update weapon visibility');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weapon>(
      future: _weaponFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProductDetailScaffold(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return ProductDetailScaffold(
            child: ProductDetailStatus(
              icon: Icons.cloud_off,
              title: 'Unable to load weapon',
              message: snapshot.error.toString(),
              actionLabel: 'RETRY',
              onAction: _reloadWeapon,
            ),
          );
        }

        final weapon = snapshot.data;

        if (weapon == null) {
          return const ProductDetailScaffold(
            child: ProductDetailStatus(
              icon: Icons.inventory_2_outlined,
              title: 'Weapon not found',
              message: 'The selected weapon is unavailable.',
            ),
          );
        }

        final isInventoryPage = _isInventoryPage;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                ProductHeader(weapon: weapon),
                ProductDescription(weapon: weapon),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    spacing: 12,
                    children: [
                      if (!widget.deletionPage && !isInventoryPage)
                        QuantitySelector(
                          quantity: _quantity,
                          stock: weapon.stock,
                          onDecrease: () => _changeQuantity(-1, weapon.stock),
                          onIncrease: () => _changeQuantity(1, weapon.stock),
                        ),
                      if (isInventoryPage)
                        QuantitySelector(
                          quantity: _quantity,
                          stock: widget.inventoryQuantity ?? 1,
                          onDecrease: () => _changeQuantity(
                            -1,
                            widget.inventoryQuantity ?? 1,
                          ),
                          onIncrease: () =>
                              _changeQuantity(1, widget.inventoryQuantity ?? 1),
                        ),
                      if (_actionError != null)
                        Text(
                          _actionError!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.myColors.error),
                        ),
                      if (widget.deletionPage)
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: CustomButton(
                                label: weapon.isHidden ? 'SHOW' : 'HIDE',
                                onPressed: _isSubmitting
                                    ? null
                                    : () async =>
                                          _updateWeaponVisibility(weapon),
                                variant: ButtonVariant.neutral,
                                outlined: true,
                              ),
                            ),
                            Expanded(
                              child: CustomButton(
                                label: 'DELETE',
                                onPressed: _isSubmitting
                                    ? null
                                    : () async =>
                                          _showConfirmation(context, weapon),
                                variant: ButtonVariant.error,
                              ),
                            ),
                          ],
                        )
                      else if (isInventoryPage)
                        CustomButton(
                          label: 'DELETE',
                          onPressed: _isSubmitting
                              ? null
                              : () async => _showConfirmation(context, weapon),
                          variant: ButtonVariant.error,
                        )
                      else
                        CustomButton(
                          label: 'BUY',
                          onPressed: _isSubmitting
                              ? null
                              : () async => _showConfirmation(context, weapon),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductDetailScaffold extends StatelessWidget {
  final Widget child;

  const ProductDetailScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(icon: Icons.arrow_back),
      body: SafeArea(child: child),
    );
  }
}

class ProductDetailStatus extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ProductDetailStatus({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
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
            Text(
              message,
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

class ProductHeader extends StatelessWidget {
  final Weapon weapon;

  const ProductHeader({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 402 / 250,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/product_detail_background.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            top: 32,
            left: 16,
            right: 16,
            child: CustomAppbar(
              icon: Icons.arrow_back,
              iconColor: context.myColors.neutralLightest,
            ),
          ),
          Positioned(
            top: 102,
            left: 32,
            width: 150,
            child: ProductInfo(weapon: weapon),
          ),
          Positioned(
            right: 36,
            bottom: 0,
            width: 235,
            height: 235,
            child: Align(
              alignment: Alignment.bottomRight,
              child: WeaponImage(image: weapon.image, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  final Weapon weapon;

  const ProductDescription({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                weapon.description,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.myColors.neutralDarkest,
                ),
              ),
              Text(
                weapon.detail,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.myColors.neutralMidDark,
                ),
              ),
              Text(
                'Type: ${weapon.type}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.myColors.neutralDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int stock;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.stock,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.myColors.neutralMidLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Quantity',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: context.myColors.neutralDarkest,
              ),
            ),
          ),
          IconButton(
            onPressed: quantity <= 1 ? null : onDecrease,
            icon: const Icon(Icons.remove),
          ),
          Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
          ),
          IconButton(
            onPressed: quantity >= stock || stock <= 0 ? null : onIncrease,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final Weapon weapon;

  const ProductInfo({super.key, required this.weapon});

  Widget _buildText(
    BuildContext context,
    String text, {
    required Color? color,
  }) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        _buildText(
          context,
          weapon.name,
          color: context.myColors.neutralLightest,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(context, 'Stock', color: context.myColors.neutralDark),
            Row(
              spacing: 4,
              children: [
                _buildText(
                  context,
                  '${weapon.stock}',
                  color: context.myColors.neutralLightest,
                ),
                _buildText(
                  context,
                  'available',
                  color: context.myColors.neutralDark,
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(context, 'Price', color: context.myColors.neutralDark),
            _buildText(
              context,
              '\$${weapon.formattedPrice}',
              color: context.myColors.neutralLightest,
            ),
          ],
        ),
      ],
    );
  }
}
