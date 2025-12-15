import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/menu_model.dart';
import '../services/cart_local_storage.dart';

/// Provider untuk mengelola state keranjang belanja
class CartProvider with ChangeNotifier {
  final CartLocalStorage _localStorage = CartLocalStorage();

  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  /// Constructor - auto load cart saat inisialisasi
  CartProvider() {
    _initializeCart();
  }

  /// Initialize cart dengan proper async handling
  Future<void> _initializeCart() async {
    debugPrint('🔄 CartProvider: Initializing...');
    await loadCart();
    _isInitialized = true;
    debugPrint('✅ CartProvider: Initialization complete');
  }

  // Getters
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  int get itemCount => _cartItems.length;
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal (total harga semua item)
  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Service charge (7.5% dari subtotal)
  double get serviceCharge {
    return subtotal * 0.075;
  }

  /// PB1/Pajak (10% dari subtotal + service charge)
  double get pb1 {
    return (subtotal + serviceCharge) * 0.10;
  }

  /// Total akhir (subtotal + service charge + PB1)
  double get grandTotal {
    return subtotal + serviceCharge + pb1;
  }

  /// Load keranjang dari local storage saat inisialisasi
  Future<void> loadCart() async {
    debugPrint('🔄 CartProvider: Loading cart...');
    _isLoading = true;
    notifyListeners();

    try {
      _cartItems = await _localStorage.loadCart();
      // Sort berdasarkan waktu ditambahkan (terbaru di atas)
      _cartItems.sort((a, b) => a.addedAt.compareTo(b.addedAt));
      debugPrint('✅ CartProvider: Loaded ${_cartItems.length} items');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ CartProvider: Error loading cart: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tambah menu ke keranjang
  Future<void> addToCart(MenuModel menu) async {
    // Cek apakah menu sudah ada di keranjang
    final existingIndex = _cartItems.indexWhere((item) => item.menu.id == menu.id);

    if (existingIndex != -1) {
      // Jika sudah ada, tambah quantity
      _cartItems[existingIndex].quantity++;
    } else {
      // Jika belum ada, tambah item baru
      _cartItems.add(CartItem(menu: menu));
    }

    await _saveCart();
    notifyListeners();
  }

  /// Update quantity item di keranjang
  Future<void> updateQuantity(String menuId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(menuId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.menu.id == menuId);
    if (index != -1) {
      _cartItems[index].quantity = newQuantity;
      await _saveCart();
      notifyListeners();
    }
  }

  /// Hapus item dari keranjang
  Future<void> removeFromCart(String menuId) async {
    _cartItems.removeWhere((item) => item.menu.id == menuId);
    await _saveCart();
    notifyListeners();
  }

  /// Clear semua item dari keranjang
  Future<void> clearCart() async {
    _cartItems.clear();
    await _localStorage.clearCart();
    notifyListeners();
  }

  /// Simpan keranjang ke local storage
  Future<void> _saveCart() async {
    try {
      debugPrint('💾 Saving cart: ${_cartItems.length} items');
      await _localStorage.saveCart(_cartItems);
      debugPrint('✅ Cart saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving cart: $e');
    }
  }

  /// Check apakah menu sudah ada di keranjang
  bool isInCart(String menuId) {
    return _cartItems.any((item) => item.menu.id == menuId);
  }

  /// Get quantity menu di keranjang
  int getQuantity(String menuId) {
    final item = _cartItems.firstWhere(
      (item) => item.menu.id == menuId,
      orElse: () => CartItem(
        menu: MenuModel(
          id: '',
          namaMenu: '',
          imageUrl: '',
          harga: 0,
          kategori: '',
          urutanTampil: 0,
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}
