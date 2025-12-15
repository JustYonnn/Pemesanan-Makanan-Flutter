// Script untuk Import Data Menu ke Firebase Firestore
// Jalankan dengan: flutter run tools/firebase_import.dart -d edge

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pemesanan_makanan/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔥 Starting Firebase import...');
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  
  // Data menu yang akan diimport
  final List<Map<String, dynamic>> menus = [
    // Makanan
    {
      'id': 'M001',
      'namaMenu': 'Nasi Goreng Spesial',
      'harga': 25000,
      'kategori': 'Makanan',
      'urutanTampil': 1,
      'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
    },
    {
      'id': 'M002',
      'namaMenu': 'Mie Ayam',
      'harga': 18000,
      'kategori': 'Makanan',
      'urutanTampil': 2,
      'imageUrl': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
    },
    {
      'id': 'M003',
      'namaMenu': 'Soto Ayam',
      'harga': 20000,
      'kategori': 'Makanan',
      'urutanTampil': 3,
      'imageUrl': 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
    },
    {
      'id': 'M004',
      'namaMenu': 'Gado-Gado',
      'harga': 16000,
      'kategori': 'Makanan',
      'urutanTampil': 4,
      'imageUrl': 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
    },
    {
      'id': 'M005',
      'namaMenu': 'Ayam Geprek',
      'harga': 22000,
      'kategori': 'Makanan',
      'urutanTampil': 5,
      'imageUrl': 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
    },
    
    // Minuman
    {
      'id': 'D001',
      'namaMenu': 'Es Teh Manis',
      'harga': 5000,
      'kategori': 'Minuman',
      'urutanTampil': 1,
      'imageUrl': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
    },
    {
      'id': 'D002',
      'namaMenu': 'Es Jeruk',
      'harga': 8000,
      'kategori': 'Minuman',
      'urutanTampil': 2,
      'imageUrl': 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
    },
    {
      'id': 'D003',
      'namaMenu': 'Jus Alpukat',
      'harga': 12000,
      'kategori': 'Minuman',
      'urutanTampil': 3,
      'imageUrl': 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400',
    },
    {
      'id': 'D004',
      'namaMenu': 'Cappuccino',
      'harga': 18000,
      'kategori': 'Minuman',
      'urutanTampil': 4,
      'imageUrl': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
    },
    {
      'id': 'D005',
      'namaMenu': 'Thai Tea',
      'harga': 10000,
      'kategori': 'Minuman',
      'urutanTampil': 5,
      'imageUrl': 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400',
    },
    
    // Snack
    {
      'id': 'S001',
      'namaMenu': 'Pisang Goreng',
      'harga': 8000,
      'kategori': 'Snack',
      'urutanTampil': 1,
      'imageUrl': 'https://images.unsplash.com/photo-1587132137056-bfbf0166836e?w=400',
    },
    {
      'id': 'S002',
      'namaMenu': 'Bakwan Jagung',
      'harga': 7000,
      'kategori': 'Snack',
      'urutanTampil': 2,
      'imageUrl': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
    },
    {
      'id': 'S003',
      'namaMenu': 'Tahu Crispy',
      'harga': 9000,
      'kategori': 'Snack',
      'urutanTampil': 3,
      'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
    },
  ];

  print('📦 Importing ${menus.length} menu items...\n');

  // Import ke Firestore
  int count = 0;
  for (var menu in menus) {
    final id = menu['id'];
    menu.remove('id');
    
    try {
      await firestore.collection('menus').doc(id).set(menu);
      count++;
      print('✅ [$count/${menus.length}] Added: ${menu['namaMenu']} (${menu['kategori']})');
    } catch (e) {
      print('❌ Failed to add: ${menu['namaMenu']} - Error: $e');
    }
  }

  print('\n🎉 Import completed! $count/${menus.length} items successfully added to Firestore.');
  print('📊 Check your Firebase Console: https://console.firebase.google.com/');
  print('\n✅ You can close this window now.');
  
  // Exit after import
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: const Color(0xFF00AA13),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Import Selesai!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$count/${menus.length} menu berhasil ditambahkan',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Silakan tutup jendela ini',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ));
}
