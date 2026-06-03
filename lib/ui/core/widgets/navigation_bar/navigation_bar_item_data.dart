import 'package:flutter/material.dart';

class NavbarItemData {
  const NavbarItemData({
    required this.icon,
    this.size = 56,
  });

  final IconData icon;
  final double size;
}