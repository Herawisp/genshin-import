import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar_item_data.dart';
import 'package:genshin_import/ui/features/inventory/widgets/inventory_view.dart';
import 'package:genshin_import/ui/features/product/widgets/product_list_view.dart';
import 'package:genshin_import/ui/features/profile/widgets/profile_view.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class UserMainView extends StatefulWidget {
  const UserMainView({super.key});

  @override
  State<UserMainView> createState() => _UserMainViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _UserMainViewState extends State<UserMainView> {
  int _currentTabIndex = 0;
  int _inventoryRefreshToken = 0;

  /* ================================================================================================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          const ProductListView(
            title: 'MARKET',
            subtitle: 'Available weapons',
            deletionOnProductTap: false,
          ),
          InventoryView(refreshToken: _inventoryRefreshToken),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        initialIndex: _currentTabIndex,
        onTabChanged: (index) {
          setState(() {
            _currentTabIndex = index;

            if (index == 1) {
              _inventoryRefreshToken++;
            }
          });
        },
        items: const [
          NavbarItemData(icon: Icons.store),
          NavbarItemData(icon: Icons.inventory),
          NavbarItemData(icon: Icons.person),
        ],
      ),
    );
  }
}

/* =================================================================================================== */
