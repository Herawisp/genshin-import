class Weapon {
  final int id;
  final String name;
  final String type;
  final String description;
  final String detail;
  final int stock;
  final String image;
  final double price;
  final bool isHidden;

  const Weapon({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.detail,
    required this.stock,
    required this.image,
    required this.price,
    this.isHidden = false,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      type: _toString(json['type']),
      description: _toString(json['description']),
      detail: _toString(json['detail']),
      stock: _toInt(json['stock']),
      image: _toString(json['image']),
      price: _toDouble(json['price']),
      isHidden: _toBool(json['isHidden'] ?? json['is_hidden']),
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'detail': detail,
      'stock': stock,
      'image': image,
      'price': price,
    };
  }

  Weapon copyWith({
    int? id,
    String? name,
    String? type,
    String? description,
    String? detail,
    int? stock,
    String? image,
    double? price,
    bool? isHidden,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      detail: detail ?? this.detail,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      price: price ?? this.price,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  String get formattedPrice {
    if (price % 1 == 0) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }
    return false;
  }
}
