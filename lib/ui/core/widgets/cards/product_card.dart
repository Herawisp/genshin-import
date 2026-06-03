import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/features/product/widgets/confirmation_dialog.dart';
import 'package:genshin_import/ui/features/product/widgets/product_detail_view.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ProductCard extends StatefulWidget {
  final Product product;
  final String weaponImagePath;
  final bool? showActions;
  final bool deletionPage;

  const ProductCard({
    super.key,
    required this.product,
    this.weaponImagePath = 'assets/images/Weapon_image.png',
    this.showActions = false,
    required this.deletionPage,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/product_detail',
        extra: {
          'product': widget.product,
          'deletionPage': widget.deletionPage, // Your extra variable
        },
      ),
      
      child: Container(
        width: 150,
        height: 215,
      
        decoration: ShapeDecoration(
          color: context.myColors.neutralMidLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 2,
            )
          ], 
        ),
      
        child: Column(
          mainAxisSize: MainAxisSize.min,
        
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
            
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Product_card_background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    Positioned.fill(
                      child: Image.asset(
                        widget.weaponImagePath,
                        fit: BoxFit.cover,
                      )
                    ),

                    if (widget.showActions == true) ...[
                      ActionButtons(product: widget.product)
                    ]
                  ],
                ),
              ),
            ),
      
            // PRODUCT INFO
            ProductInfo(
              productName: widget.product.productName,
              stock: widget.product.stock,
              price: widget.product.price,
            )
          ]
        ),
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class ActionButtons extends StatelessWidget {
  final Product product;

  const ActionButtons({
    super.key,
    required this.product,
  });

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: context.myColors.darken,

      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: 'Delete item?',
          subtitle: 'Are you sure you want to delete this item?\nThis action cannot be undone.',
          deletionPage: true,
          onCancel: () async {context.pop();},
          onAccept: () async {context.pop();},
        );
      },
    );
  }

  /* ================================================================================================= */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 4,
        children: [
          CustomIconButton(
            icon: Icons.edit, 
            onPressed: () => context.push(
              '/product_detail',
              extra: {
                'product': product,
                'deletionPage': false, // Your extra variable
              },
            ),
            color: context.myColors.neutralLightest,
          ),
          CustomIconButton(
            icon: Icons.delete, 
            onPressed: () => _showConfirmation(context),
            color: context.myColors.errorLight,
          ),
        ]
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class ProductInfo extends StatelessWidget {
  final String productName;
  final int stock;
  final int price;

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
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.myColors.neutralDarkest
            ),
          ),
          
          Divider(
            height: 1,
            color: context.myColors.neutralLight,
          ),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
              
            children: [
              ProductStat(
                label: stock.toString(),
                icon: Icons.inventory,
              ),
          
              ProductStat(
                label: '\$$price',
                icon: Icons.local_offer,
              ),
            ],
          )
        ],
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

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

/* =================================================================================================== */
/* =================================================================================================== */

class ProductStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProductStat({
    super.key,
    required this.icon,
    required this.label, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
    
      children: [
        Icon(
          icon,
          color: context.myColors.primary,
          size: 16,
        ),
    
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.myColors.neutralDarkest
          ),
        ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
