import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_model.dart';

/// Service untuk mengambil data menu dari Firebase Firestore
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Collection name di Firestore
  static const String _menusCollection = 'menus';

  /// Fetch semua menu dari Firestore
  Future<List<MenuModel>> fetchMenus() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_menusCollection).get();
      
      // Convert documents ke MenuModel
      List<MenuModel> menus = snapshot.docs.map((doc) {
        return MenuModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
      
      // Remove duplicates berdasarkan id
      Map<String, MenuModel> uniqueMenus = {};
      for (var menu in menus) {
        uniqueMenus[menu.id] = menu;
      }
      
      return uniqueMenus.values.toList();
    } catch (e) {
      throw Exception('Gagal mengambil data menu dari Firebase: $e');
    }
  }

  /// Group menus berdasarkan kategori dan sort berdasarkan urutanTampil
  Map<String, List<MenuModel>> groupAndSortMenus(List<MenuModel> menus) {
    Map<String, List<MenuModel>> grouped = {};
    
    for (var menu in menus) {
      if (!grouped.containsKey(menu.kategori)) {
        grouped[menu.kategori] = [];
      }
      grouped[menu.kategori]!.add(menu);
    }
    
    // Sort setiap kategori berdasarkan urutanTampil
    grouped.forEach((kategori, menuList) {
      menuList.sort((a, b) => a.urutanTampil.compareTo(b.urutanTampil));
    });
    
    return grouped;
  }

  /// Tambah menu baru (optional - untuk admin)
  Future<void> addMenu(MenuModel menu) async {
    try {
      await _firestore.collection(_menusCollection).doc(menu.id).set({
        'namaMenu': menu.namaMenu,
        'imageUrl': menu.imageUrl,
        'harga': menu.harga,
        'kategori': menu.kategori,
        'urutanTampil': menu.urutanTampil,
      });
    } catch (e) {
      throw Exception('Gagal menambahkan menu: $e');
    }
  }

  /// Update menu (optional - untuk admin)
  Future<void> updateMenu(MenuModel menu) async {
    try {
      await _firestore.collection(_menusCollection).doc(menu.id).update({
        'namaMenu': menu.namaMenu,
        'imageUrl': menu.imageUrl,
        'harga': menu.harga,
        'kategori': menu.kategori,
        'urutanTampil': menu.urutanTampil,
      });
    } catch (e) {
      throw Exception('Gagal mengupdate menu: $e');
    }
  }

  /// Delete menu (optional - untuk admin)
  Future<void> deleteMenu(String menuId) async {
    try {
      await _firestore.collection(_menusCollection).doc(menuId).delete();
    } catch (e) {
      throw Exception('Gagal menghapus menu: $e');
    }
  }
}
