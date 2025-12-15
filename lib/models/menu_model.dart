/// Model untuk menu makanan dan minuman
class MenuModel {
  final String id;
  final String namaMenu;
  final String imageUrl;  // Renamed from gambar to imageUrl
  final double harga;
  final String kategori;
  final int urutanTampil;

  MenuModel({
    required this.id,
    required this.namaMenu,
    required this.imageUrl,
    required this.harga,
    required this.kategori,
    required this.urutanTampil,
  });

  /// Convert dari Firestore document
  factory MenuModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return MenuModel(
      id: documentId,
      namaMenu: data['namaMenu'] as String,
      imageUrl: data['imageUrl'] as String,
      harga: (data['harga'] as num).toDouble(),
      kategori: data['kategori'] as String,
      urutanTampil: data['urutanTampil'] as int,
    );
  }

  /// Convert dari JSON (untuk backward compatibility)
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] as String,
      namaMenu: json['namaMenu'] as String,
      imageUrl: (json['imageUrl'] ?? json['gambar'] ?? '') as String,  // Support both with fallback
      harga: (json['harga'] as num).toDouble(),
      kategori: json['kategori'] as String,
      urutanTampil: json['urutanTampil'] as int,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaMenu': namaMenu,
      'imageUrl': imageUrl,
      'harga': harga,
      'kategori': kategori,
      'urutanTampil': urutanTampil,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
