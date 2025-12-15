import 'package:flutter/foundation.dart';
import '../models/menu_model.dart';
import '../services/firebase_service.dart';

/// Provider untuk mengelola state menu dari Firebase
class MenuProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<MenuModel> _allMenus = [];
  Map<String, List<MenuModel>> _groupedMenus = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MenuModel> get allMenus => _allMenus;
  Map<String, List<MenuModel>> get groupedMenus => _groupedMenus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get categories => _groupedMenus.keys.toList();

  /// Load menu dari Firebase Firestore saat inisialisasi aplikasi
  Future<void> loadMenus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allMenus = await _firebaseService.fetchMenus();
      
      // Jika Firebase kosong, gunakan mock data
      if (_allMenus.isEmpty) {
        _allMenus = _getMockData();
      }
      
      _groupedMenus = _firebaseService.groupAndSortMenus(_allMenus);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Jika error Firebase, fallback ke mock data
      _allMenus = _getMockData();
      _groupedMenus = _firebaseService.groupAndSortMenus(_allMenus);
      _error = 'Menggunakan data mock (Firebase: $e)';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mock data sebagai fallback
  List<MenuModel> _getMockData() {
    return [
      // Makanan
      MenuModel(id: 'M001', namaMenu: 'Nasi Goreng Spesial', imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400', harga: 25000, kategori: 'Makanan', urutanTampil: 1),
      MenuModel(id: 'M002', namaMenu: 'Mie Ayam', imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400', harga: 18000, kategori: 'Makanan', urutanTampil: 2),
      MenuModel(id: 'M003', namaMenu: 'Soto Ayam', imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400', harga: 20000, kategori: 'Makanan', urutanTampil: 3),
      MenuModel(id: 'M004', namaMenu: 'Gado-Gado', imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400', harga: 16000, kategori: 'Makanan', urutanTampil: 4),
      MenuModel(id: 'M005', namaMenu: 'Ayam Geprek', imageUrl: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400', harga: 22000, kategori: 'Makanan', urutanTampil: 5),
      
      // Minuman
      MenuModel(id: 'D001', namaMenu: 'Es Teh Manis', imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400', harga: 5000, kategori: 'Minuman', urutanTampil: 1),
      MenuModel(id: 'D002', namaMenu: 'Es Jeruk', imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400', harga: 8000, kategori: 'Minuman', urutanTampil: 2),
      MenuModel(id: 'D003', namaMenu: 'Jus Alpukat', imageUrl: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400', harga: 12000, kategori: 'Minuman', urutanTampil: 3),
      MenuModel(id: 'D004', namaMenu: 'Cappuccino', imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400', harga: 18000, kategori: 'Minuman', urutanTampil: 4),
      MenuModel(id: 'D005', namaMenu: 'Thai Tea', imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400', harga: 10000, kategori: 'Minuman', urutanTampil: 5),
      
      // Snack
      MenuModel(id: 'S001', namaMenu: 'Pisang Goreng', imageUrl: 'https://images.unsplash.com/photo-1587132137056-bfbf0166836e?w=400', harga: 8000, kategori: 'Snack', urutanTampil: 1),
      MenuModel(id: 'S002', namaMenu: 'Bakwan Jagung', imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400', harga: 7000, kategori: 'Snack', urutanTampil: 2),
      MenuModel(id: 'S003', namaMenu: 'Tahu Crispy', imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400', harga: 9000, kategori: 'Snack', urutanTampil: 3),
    ];
  }

  /// Get menu berdasarkan kategori
  List<MenuModel> getMenusByCategory(String category) {
    return _groupedMenus[category] ?? [];
  }

  /// Cari menu berdasarkan ID
  MenuModel? getMenuById(String id) {
    try {
      return _allMenus.firstWhere((menu) => menu.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Refresh menu dari cloud
  Future<void> refreshMenus() async {
    await loadMenus();
  }
}
