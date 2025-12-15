import '../models/menu_model.dart';

/// Service untuk mengambil data menu dari cloud
/// Saat ini menggunakan data mock, bisa diintegrasikan dengan Firebase/API
class MenuCloudService {
  /// Fetch menu dari cloud
  /// TODO: Ganti dengan actual cloud service (Firebase/API)
  Future<List<MenuModel>> fetchMenus() async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // Data mock - dalam implementasi nyata, data ini dari cloud
    return [
      // Kategori: Makanan
      MenuModel(
        id: 'M001',
        namaMenu: 'Nasi Goreng Special',
        imageUrl: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Nasi+Goreng',
        harga: 25000,
        kategori: 'Makanan',
        urutanTampil: 1,
      ),
      MenuModel(
        id: 'M002',
        namaMenu: 'Mie Ayam Bakso',
        imageUrl: 'https://via.placeholder.com/150/33FF57/FFFFFF?text=Mie+Ayam',
        harga: 20000,
        kategori: 'Makanan',
        urutanTampil: 2,
      ),
      MenuModel(
        id: 'M003',
        namaMenu: 'Ayam Geprek',
        imageUrl: 'https://via.placeholder.com/150/3357FF/FFFFFF?text=Ayam+Geprek',
        harga: 22000,
        kategori: 'Makanan',
        urutanTampil: 3,
      ),
      MenuModel(
        id: 'M004',
        namaMenu: 'Soto Ayam',
        imageUrl: 'https://via.placeholder.com/150/FF33F5/FFFFFF?text=Soto+Ayam',
        harga: 18000,
        kategori: 'Makanan',
        urutanTampil: 4,
      ),
      MenuModel(
        id: 'M005',
        namaMenu: 'Gado-Gado',
        imageUrl: 'https://via.placeholder.com/150/FFD700/FFFFFF?text=Gado-Gado',
        harga: 15000,
        kategori: 'Makanan',
        urutanTampil: 5,
      ),

      // Kategori: Minuman
      MenuModel(
        id: 'D001',
        namaMenu: 'Es Teh Manis',
        imageUrl: 'https://via.placeholder.com/150/87CEEB/FFFFFF?text=Es+Teh',
        harga: 5000,
        kategori: 'Minuman',
        urutanTampil: 1,
      ),
      MenuModel(
        id: 'D002',
        namaMenu: 'Es Jeruk',
        imageUrl: 'https://via.placeholder.com/150/FFA500/FFFFFF?text=Es+Jeruk',
        harga: 7000,
        kategori: 'Minuman',
        urutanTampil: 2,
      ),
      MenuModel(
        id: 'D003',
        namaMenu: 'Jus Alpukat',
        imageUrl: 'https://via.placeholder.com/150/90EE90/FFFFFF?text=Jus+Alpukat',
        harga: 12000,
        kategori: 'Minuman',
        urutanTampil: 3,
      ),
      MenuModel(
        id: 'D004',
        namaMenu: 'Kopi Susu',
        imageUrl: 'https://via.placeholder.com/150/8B4513/FFFFFF?text=Kopi+Susu',
        harga: 10000,
        kategori: 'Minuman',
        urutanTampil: 4,
      ),
      MenuModel(
        id: 'D005',
        namaMenu: 'Air Mineral',
        imageUrl: 'https://via.placeholder.com/150/ADD8E6/FFFFFF?text=Air+Mineral',
        harga: 3000,
        kategori: 'Minuman',
        urutanTampil: 5,
      ),

      // Kategori: Snack
      MenuModel(
        id: 'S001',
        namaMenu: 'Pisang Goreng',
        imageUrl: 'https://via.placeholder.com/150/FFE4B5/FFFFFF?text=Pisang+Goreng',
        harga: 8000,
        kategori: 'Snack',
        urutanTampil: 1,
      ),
      MenuModel(
        id: 'S002',
        namaMenu: 'Kentang Goreng',
        imageUrl: 'https://via.placeholder.com/150/F4A460/FFFFFF?text=Kentang',
        harga: 10000,
        kategori: 'Snack',
        urutanTampil: 2,
      ),
      MenuModel(
        id: 'S003',
        namaMenu: 'Tahu Isi',
        imageUrl: 'https://via.placeholder.com/150/DEB887/FFFFFF?text=Tahu+Isi',
        harga: 6000,
        kategori: 'Snack',
        urutanTampil: 3,
      ),
    ];
  }

  /// Validasi menu untuk mencegah duplikasi berdasarkan ID
  bool isDuplicate(List<MenuModel> existingMenus, MenuModel newMenu) {
    return existingMenus.any((menu) => menu.id == newMenu.id);
  }

  /// Group menu berdasarkan kategori dan sort berdasarkan urutanTampil
  Map<String, List<MenuModel>> groupAndSortMenus(List<MenuModel> menus) {
    final Map<String, List<MenuModel>> grouped = {};

    for (var menu in menus) {
      if (!grouped.containsKey(menu.kategori)) {
        grouped[menu.kategori] = [];
      }
      grouped[menu.kategori]!.add(menu);
    }

    // Sort each category by urutanTampil
    grouped.forEach((key, value) {
      value.sort((a, b) => a.urutanTampil.compareTo(b.urutanTampil));
    });

    return grouped;
  }
}
