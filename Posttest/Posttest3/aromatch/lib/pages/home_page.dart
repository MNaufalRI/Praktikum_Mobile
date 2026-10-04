import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk FilteringTextInputFormatter (Modul 3: membatasi input TextField hanya angka)
import '../data/dummy_perfumes.dart';
import '../data/favorites_store.dart';
import '../models/perfume.dart';
import '../widgets/note_filter_button.dart';
import '../widgets/perfume_card.dart';

class HomePage extends StatefulWidget {
  final Map<String, int> stock; // stok terkini tiap parfum (state milik MainPage)
  final void Function(Perfume) onAddToCart; // callback ke MainPage.addToCart

  const HomePage({super.key, required this.stock, required this.onAddToCart});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menyimpan aroma/note yang sedang dipilih pengguna sebagai filter.
  final Set<String> _selectedNotes = {};
  String _searchQuery = '';
  int? _maxPrice; // harga maksimal (angka saja) dari TextField "Harga maksimal"
  bool _onlyInStock = false; // state Switch "Hanya stok tersedia"

  // Mengubah string harga dummy (contoh: "Rp1.470.000") menjadi angka murni.
  int _parsePrice(String price) {
    final digitsOnly = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digitsOnly) ?? 0;
  }

  // Mengembalikan daftar parfum yang sudah difilter berdasarkan pencarian & note,
  // lalu diurutkan berdasarkan seberapa banyak note yang cocok (skor rekomendasi).
  List<Perfume> get _filteredPerfumes {
    final result = dummyPerfumes.where((p) {
      final query = _searchQuery.toLowerCase();
      final matchName = p.name.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query);
      final matchNotes = _selectedNotes.isEmpty ||
          p.notes.any((n) => _selectedNotes.contains(n));
      final matchPrice = _maxPrice == null || _parsePrice(p.price) <= _maxPrice!;
      final matchStock =
          !_onlyInStock || (widget.stock[FavoritesStore.keyOf(p)] ?? 0) > 0;
      return matchName && matchNotes && matchPrice && matchStock;
    }).toList();

    if (_selectedNotes.isNotEmpty) {
      result.sort((a, b) {
        final aScore = a.notes.where(_selectedNotes.contains).length;
        final bScore = b.notes.where(_selectedNotes.contains).length;
        return bScore.compareTo(aScore); // parfum paling cocok ditaruh di atas
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold : struktur dasar halaman (background, body, bottom area)
      backgroundColor: Colors.white, // backgroundColor: mengikuti warna tema aplikasi
      body: SafeArea( // SafeArea : memastikan konten tidak tertutup notch/status bar perangkat
        child: Padding( // Padding : memberi jarak antara konten dan tepi layar
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column( // Column : menyusun judul, search, filter, dan hasil secara vertikal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text( // Text : judul halaman
                'Temukan parfum yang cocok untukmu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4), // SizedBox: jarak vertikal antar elemen
              Text(
                'Pilih aroma favoritmu, kami rekomendasikan parfumnya',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField( // TextField : input pencarian nama/brand parfum
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari parfum atau brand',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  suffixIcon: Padding( // Padding : jarak antara icon dan tepi kanan field
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon( // Icon : penanda visual kolom pencarian
                      Icons.search,
                      size: 22,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aroma favorit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SizedBox( // SizedBox : membatasi tinggi area filter agar tidak memakan seluruh layar
                height: 40,
                child: SingleChildScrollView( // SingleChildScrollView : membuat daftar filter bisa discroll horizontal
                  scrollDirection: Axis.horizontal,
                  child: Row( // Row : menyusun tombol-tombol filter aroma secara horizontal
                    children: [
                      for (final note in perfumeNotes) ...[
                        NoteFilterButton(
                          label: note,
                          isSelected: _selectedNotes.contains(note),
                          onTap: () {
                            setState(() {
                              if (_selectedNotes.contains(note)) {
                                _selectedNotes.remove(note);
                              } else {
                                _selectedNotes.add(note);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 8), // SizedBox: jarak antar tombol filter
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text( // Text : label input harga maksimal
                'Harga maksimal (opsional)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField( // TextField : input angka untuk membatasi harga parfum yang ditampilkan
                keyboardType: TextInputType.number, // keyboardType : memunculkan keyboard angka saja
                // inputFormatters : membatasi karakter yang bisa diketik hanya digit 0-9
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {
                    _maxPrice = value.isEmpty ? null : int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Contoh: 1000000',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // SwitchListTile : saklar filter; setState membuat daftar difilter ulang
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text('Hanya stok tersedia'),
                value: _onlyInStock,
                onChanged: (value) => setState(() => _onlyInStock = value),
              ),
              const SizedBox(height: 8),
              Text(
                'Rekomendasi (${_filteredPerfumes.length})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded( // Expanded : memaksa area hasil rekomendasi mengisi sisa ruang vertikal
                child: _filteredPerfumes.isEmpty
                    ? Center(
                        child: Text(
                          'Parfum tidak ditemukan',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      )
                    : SingleChildScrollView( // SingleChildScrollView : membuat daftar hasil bisa discroll vertikal
                        child: Column( // Column : menyusun kartu-kartu hasil rekomendasi secara vertikal
                          children: _filteredPerfumes
                              .map((p) => PerfumeCard(
                                    perfume: p,
                                    stock: widget.stock[FavoritesStore.keyOf(p)] ?? 0,
                                    onAddToCart: () => widget.onAddToCart(p),
                                  ))
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
