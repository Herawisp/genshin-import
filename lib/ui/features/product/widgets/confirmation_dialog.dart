import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool deletionPage;
  final int? quantity;
  final double? totalPrice;
  final String? warningMessage;
  final Future<void> Function()? onCancel;
  final Future<void> Function()? onAccept;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.deletionPage,
    this.quantity,
    this.totalPrice,
    this.warningMessage,
    required this.onCancel,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.myColors.neutralLightest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
          ),

          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
          ),
        ],
      ),

      content: deletionPage
          ? DeletionWarning(message: warningMessage)
          : CostBreakdown(quantity: quantity, totalPrice: totalPrice),

      actions: [
        Row(
          spacing: 16,

          children: [
            Expanded(
              child: CustomButton(
                label: 'CANCEL',
                onPressed: onCancel,
                variant: ButtonVariant.neutral,
              ),
            ),

            Expanded(
              child: CustomButton(
                label: deletionPage ? 'DELETE' : 'CONFIRM',
                onPressed: onAccept,
                variant: deletionPage
                    ? ButtonVariant.error
                    : ButtonVariant.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class CostBreakdown extends StatelessWidget {
  final int? quantity;
  final double? totalPrice;

  const CostBreakdown({super.key, this.quantity, this.totalPrice});

  String _formatPrice(double price) {
    if (price % 1 == 0) {
      return '\$${price.toInt()}';
    }

    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final currentQuantity = quantity;
    final currentTotalPrice = totalPrice;

    return Container(
      decoration: ShapeDecoration(
        color: context.myColors.neutralMidLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Column(
            spacing: 8,

            children: [
              CostBreakdownItem(
                label: 'Quantity',
                value: currentQuantity?.toString() ?? '-',
              ),
              CostBreakdownItem(
                label: 'Total Price',
                value: currentTotalPrice == null
                    ? '-'
                    : _formatPrice(currentTotalPrice),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class CostBreakdownItem extends StatelessWidget {
  final String label;
  final String value;

  const CostBreakdownItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: context.myColors.neutralMidDark,
                ),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.myColors.neutralMidDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Divider(color: context.myColors.neutralDark, height: 1, thickness: 1),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class DeletionWarning extends StatelessWidget {
  final String? message;

  const DeletionWarning({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: context.myColors.errorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: context.myColors.errorVariantLight!,
            width: 2,
          ),
        ),
      ),

      child: Row(
        spacing: 16,
        children: [
          Icon(Icons.error, color: context.myColors.error),

          Expanded(
            child: Text(
              message ??
                  'Deleting this item will remove it from your inventory permanently',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: context.myColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
