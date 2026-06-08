import 'package:genshin_import/data/models/weapon.dart';

class InventoryItem {
  final Weapon weapon;
  final int quantity;

  const InventoryItem({required this.weapon, required this.quantity});

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    final weaponJson = json['weapon'];

    return InventoryItem(
      weapon: weaponJson is Map<String, dynamic>
          ? Weapon.fromJson(weaponJson)
          : Weapon.fromJson(const {}),
      quantity: _toInt(json['quantity']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class InventoryResult {
  final int totalItems;
  final List<InventoryItem> items;

  const InventoryResult({required this.totalItems, required this.items});

  factory InventoryResult.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];

    return InventoryResult(
      totalItems: InventoryItem._toInt(json['totalItems']),
      items: itemsJson is List
          ? itemsJson
                .whereType<Map<String, dynamic>>()
                .map(InventoryItem.fromJson)
                .toList()
          : const [],
    );
  }
}
