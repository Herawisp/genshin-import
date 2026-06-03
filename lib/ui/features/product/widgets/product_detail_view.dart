import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/features/product/widgets/confirmation_dialog.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class Product {
  final String productName;
  final int stock;
  final int price;
  final String? description1;
  final String? description2;

  const Product({
    required this.productName,
    required this.stock,
    required this.price,
    required this.description1,
    this.description2
  });
}

/* =================================================================================================== */
/* =================================================================================================== */

class ProductDetailView extends StatelessWidget {
  final Product product;
  final bool deletionPage;

  const ProductDetailView({
    super.key,
    required this.product,
    required this.deletionPage,
  });

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: context.myColors.darken,

      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: deletionPage ? 'Delete item?' : 'Confirm Purchase',
          subtitle: deletionPage ? 
            'Are you sure you want to delete this item?\nThis action cannot be undone.' : 
            'Are you sure you want to buy this item?',
          deletionPage: deletionPage,
          onCancel: () async {context.pop();},
          onAccept: () async {context.pop();},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            ProductHeader(
              productName: product.productName, 
              stock: product.stock, 
              price: product.price
            ),
        
            ProductDescription(
              description1: product.description1!, 
              description2: product.description2
            ),
            
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                spacing: 8,
                children: [
                  if (!deletionPage)
                    Text(
                      'You own ${1200} // TODO: actual owned money',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: context.myColors.neutralDarkest,
                      ),
                    ),

                  CustomButton(
                    label: deletionPage ? 'DELETE' : 'BUY',
                    onPressed: () async {_showConfirmation(context);},
                    variant: deletionPage ? ButtonVariant.error : ButtonVariant.primary,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    super.key,
    required this.productName,
    required this.stock,
    required this.price,
  });

  final String productName;
  final int stock;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
    
        AspectRatio(
          aspectRatio: 402 / 250,
          child: Image.asset(
            'assets/images/product_detail_background.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        
        Positioned(
          top: 32, left: 16, right: 16,
          child: CustomAppbar(
            icon: Icons.arrow_back,
            iconColor: context.myColors.neutralLightest,
          ),
        ),
    
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 72, right: 32, left: 32
            ),
    
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductInfo(
                  productName: productName,
                  stock: stock,
                  price: price,
                ),
                
                Image.asset(
                  'assets/images/Weapon_image.png',
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    super.key,
    required this.description1,
    required this.description2,
  });

  final String description1;
  final String? description2;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
    
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  description1,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.myColors.neutralDarkest,
                  ),
                ),
                Text(
                  description2!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.myColors.neutralDark,
                  ),
                ),
              ],
            )
          ],
        ),
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

  Widget _buildText(BuildContext context, String text, {required Color? color}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,

      children: [
        _buildText(context, productName, color: context.myColors.neutralLightest),

        // STOCK INFO
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(context, 'Stock', color: context.myColors.neutralDark),

            Row(
              spacing: 4,
              children:[
                _buildText(context, '$stock', color: context.myColors.neutralLightest),
                _buildText(context, 'available', color: context.myColors.neutralDark),
              ],
            )
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(context, 'Price', color: context.myColors.neutralDark),
            _buildText(context, '\$$price', color: context.myColors.neutralLightest),
          ],
        ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */