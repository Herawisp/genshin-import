import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool deletionPage;
  final Future<void> Function()? onCancel;
  final Future<void> Function()? onAccept;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.deletionPage,
    required this.onCancel,
    required this.onAccept
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.myColors.neutralLightest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
        ]
      ),
      
      content: deletionPage ? const DeletionWarning() : const CostBreakdown(),
    
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
                variant: deletionPage ? ButtonVariant.error : ButtonVariant.primary,
              ),
            )
          ],
        ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class CostBreakdown extends StatelessWidget {
  const CostBreakdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: context.myColors.neutralMidLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Column(
            spacing: 8,
          
            children: [
              CostBreakdownItem(
                label: 'Item Cost',
                value: '\$1000',
              ),
              CostBreakdownItem(
                label: 'Your Balance',
                value: '\$1200',
              ),
              CostBreakdownItem(
                label: 'Balance After Purchase',
                value: '\$200',
              ),
            ]
          ),
        ),
      )
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
      children:[
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
        Divider(
          color: context.myColors.neutralDark,
          height: 1,
          thickness: 1,
        ),
      ]
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class DeletionWarning extends StatelessWidget {
  const DeletionWarning({
    super.key,
  });

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
            width: 2
          )
        ),
      ),
        
      child: Row(
        spacing: 16,
        children: [
          Icon(
            Icons.error,
            color: context.myColors.error,
          ),
        
          Expanded(
            child: Text(
              'Deleting this item will remove it from your inventory permanently',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.myColors.error
              ),
            ),
          )
        ],
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
