import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar_item_data.dart';
import 'package:genshin_import/ui/features/product/widgets/product_list_view.dart';
import 'package:genshin_import/ui/features/profile/widgets/profile_view.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class AdminMainView extends StatefulWidget {
  const AdminMainView({super.key});

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _AdminMainViewState extends State<AdminMainView> {
  int _currentTabIndex = 0;

  static const List<Widget> _pages = [
    ProductListView(
      title: 'MARKET',
      subtitle: 'Manage weapons',
      deletionOnProductTap: true,
      showActions: true,
      showCreateButton: true,
      useAdminWeapons: true,
    ),

    ProfileView(),
  ];

  /* ================================================================================================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentTabIndex, children: _pages),

      bottomNavigationBar: CustomNavbar(
        initialIndex: _currentTabIndex,
        onTabChanged: (index) => setState(() => _currentTabIndex = index),
        items: [
          NavbarItemData(icon: Icons.store),
          NavbarItemData(icon: Icons.person),
        ],
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
