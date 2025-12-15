import 'menu_model.dart';

/// Model untuk item dalam keranjang belanja
class CartItem {
  final MenuModel menu;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.menu,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Total harga untuk item ini
  double get totalPrice => menu.harga * quantity;

  /// Convert dari JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menu: MenuModel.fromJson(json['menu'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create copy dengan perubahan
  CartItem copyWith({
    MenuModel? menu,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      menu: menu ?? this.menu,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
