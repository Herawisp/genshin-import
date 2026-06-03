import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/appbar/section_header.dart';
import 'package:genshin_import/ui/core/widgets/cards/product_card.dart';
import 'package:genshin_import/ui/features/product/widgets/product_detail_view.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ProductListView extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Product> products;
  final bool showActions;
  final bool deletionOnProductTap;

  const ProductListView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.products,
    this.showActions = false,
    required this.deletionOnProductTap,
  });

  /* ================================================================================================= */

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: title,
          subtitle: subtitle,
        ),

        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              childAspectRatio: 0.7,
            ),

            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: Product(
                  productName: product.productName, 
                  stock: product.stock, 
                  price: product.price, 
                  description1: product.description1,
                  description2: product.description2
                ),
                showActions: showActions,
                deletionPage: deletionOnProductTap,
              );
            },
          ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
