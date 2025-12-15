import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

/// Service untuk penyimpanan lokal keranjang belanja
class CartLocalStorage {
  static const String _cartKey = 'shopping_cart';

  /// Simpan keranjang ke local storage
  Future<void> saveCart(List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = cartItems.map((item) => item.toJson()).toList();
      final cartString = jsonEncode(cartJson);
      final success = await prefs.setString(_cartKey, cartString);
      print('💾 Attempting to save cart: ${cartItems.length} items');
      print('📦 Cart data: ${cartString.substring(0, cartString.length > 100 ? 100 : cartString.length)}...');
      print('✅ Save result: $success');
      
      // Verify save by reading it back
      final verifyData = prefs.getString(_cartKey);
      print('🔍 Verification read: ${verifyData != null ? "Data found" : "NO DATA"}');
    } catch (e) {
      print('❌ Error saving cart: $e');
      throw Exception('Gagal menyimpan keranjang: $e');
    }
  }

  /// Load keranjang dari local storage
  Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      print('🔍 Loading cart from SharedPreferences...');
      print('📦 Stored data: $cartString');

      if (cartString == null || cartString.isEmpty) {
        print('📭 Cart is empty');
        return [];
      }

      final List<dynamic> cartJson = jsonDecode(cartString);
      final items = cartJson
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();
      print('✅ Cart loaded: ${items.length} items');
      return items;
    } catch (e) {
      print('❌ Error loading cart: $e');
      throw Exception('Gagal memuat keranjang: $e');
    }
  }

  /// Clear keranjang dari local storage
  Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      throw Exception('Gagal menghapus keranjang: $e');
    }
  }

  /// Check apakah ada data keranjang tersimpan
  Future<bool> hasCartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cartKey);
    } catch (e) {
      return false;
    }
  }
}
