import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar_item_data.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_item.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.onTabChanged,
  }) : assert(items.length >= 2, 'Navbar requires at least 2 items');

  final List<NavbarItemData> items;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {

  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialIndex;
  }

  void _selectTab(int index) {
    if (_currentTabIndex == index) return;
    setState(() {
      _currentTabIndex = index;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.myColors.neutralLightest,
        border: Border(
          top: BorderSide(
            color: context.myColors.neutralDark!,
            width: 2,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              return NavigationItem(
                icon: item.icon,
                size: item.size,
                onPressed: _currentTabIndex == index
                    ? null
                    : () => _selectTab(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}