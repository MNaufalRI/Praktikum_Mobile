import 'package:flutter/material.dart';
import '../data/dummy_perfumes.dart';
import '../models/perfume.dart';
import '../data/favorites_store.dart';
import '../widgets/perfume_card.dart';

// FavoritPage : halaman kedua aplikasi, menampilkan daftar parfum yang
// ditandai favorit oleh pengguna. Halaman ini dibuat pada Modul 3 (Widget
// Lanjutan & Navigation). Pada Modul 4, navigasinya dipindah ke MainPage.
class FavoritPage extends StatelessWidget {
  final Map<String, int> stock; // stok terkini (state milik MainPage)
  final void Function(Perfume) onAddToCart; // callback ke MainPage.addToCart

  const FavoritPage({super.key, required this.stock, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold : struktur dasar halaman (background, body, bottom nav)
      backgroundColor: Colors.white,
      body: SafeArea( // SafeArea : memastikan konten tidak tertutup notch/status bar
        child: Padding( // Padding : jarak antara konten dan tepi layar
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column( // Column : menyusun judul dan daftar favorit secara vertikal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text( // Text : judul halaman
                'Parfum favorit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4), // SizedBox : jarak vertikal antar elemen
              Text(
                'Kumpulan parfum yang sudah kamu tandai suka',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Expanded( // Expanded : memaksa area daftar favorit mengisi sisa ruang vertikal
                // ValueListenableBuilder : widget lanjutan yang otomatis membangun ulang
                // tampilannya setiap kali FavoritesStore.favoriteKeys berubah nilai,
                // sehingga daftar di halaman ini selalu sinkron dengan tombol hati di Beranda.
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: FavoritesStore.favoriteKeys,
                  builder: (context, favoriteKeys, _) {
                    final favoritePerfumes = dummyPerfumes
                        .where((p) => favoriteKeys.contains(FavoritesStore.keyOf(p)))
                        .toList();

                    return Stack( // Stack : menumpuk daftar favorit dengan panel ringkasan di bagian bawah
                      children: [
                        favoritePerfumes.isEmpty
                            ? Center( // Center : menengahkan pesan saat belum ada favorit
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon( // Icon : ilustrasi sederhana saat daftar kosong
                                      Icons.favorite_border,
                                      size: 48,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Belum ada parfum favorit',
                                      style: TextStyle(color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ketuk ikon hati pada kartu parfum di Beranda',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView( // SingleChildScrollView : daftar favorit bisa discroll vertikal
                                padding: const EdgeInsets.only(bottom: 90),
                                child: Column(
                                  children: favoritePerfumes
                                      .map((p) => PerfumeCard(
                                            perfume: p,
                                            stock: stock[FavoritesStore.keyOf(p)] ?? 0,
                                            onAddToCart: () => onAddToCart(p),
                                          ))
                                      .toList(),
                                ),
                              ),
                        if (favoritePerfumes.isNotEmpty)
                          Positioned( // Positioned : menempelkan panel ringkasan di bagian bawah layar
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container( // Container : panel ringkasan jumlah favorit + tombol hapus semua
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow( // BoxShadow : efek melayang di atas konten yang ada di baliknya
                                    color: Colors.grey.shade300,
                                    blurRadius: 10,
                                    offset: const Offset(0, -3),
                                  ),
                                ],
                              ),
                              child: Row( // Row : menyusun teks jumlah favorit dan tombol secara horizontal
                                children: [
                                  Expanded( // Expanded : teks jumlah favorit mengisi sisa ruang di Row
                                    child: Text(
                                      '${favoritePerfumes.length} parfum favorit',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  ElevatedButton( // ElevatedButton : tombol untuk menghapus seluruh favorit
                                    onPressed: () => FavoritesStore.clear(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Hapus semua'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
