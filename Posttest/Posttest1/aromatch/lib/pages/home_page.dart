import 'package:flutter/material.dart';
import '../data/dummy_perfumes.dart';
import '../models/perfume.dart';
import '../widgets/note_filter_button.dart';
import '../widgets/perfume_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menyimpan aroma/note yang sedang dipilih pengguna sebagai filter.
  final Set<String> _selectedNotes = {};
  String _searchQuery = '';

  // Mengembalikan daftar parfum yang sudah difilter berdasarkan pencarian & note,
  // lalu diurutkan berdasarkan seberapa banyak note yang cocok (skor rekomendasi).
  List<Perfume> get _filteredPerfumes {
    final result = dummyPerfumes.where((p) {
      final query = _searchQuery.toLowerCase();
      final matchName = p.name.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query);
      final matchNotes = _selectedNotes.isEmpty ||
          p.notes.any((n) => _selectedNotes.contains(n));
      return matchName && matchNotes;
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
                              .map((p) => PerfumeCard(perfume: p))
                              .toList(),
                        ),
                      ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // Navigasi bawah statis (dekoratif), dibangun manual dari Container + Row + Icon + Text,
  // mengikuti pola yang sama seperti pada gambar studi kasus Modul 2.
  Widget _buildBottomNav() {
    return Container( // Container : membungkus bar navigasi, mengatur border atas
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row( // Row : menyusun 3 item navigasi secara horizontal
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(Icons.home, 'Beranda'),
          _navItem(Icons.favorite_border, 'Favorit'),
          _navItem(Icons.person_outline, 'Profil'),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label) {
    return Expanded( // Expanded : membagi rata lebar setiap item navigasi
      child: Column( // Column : menyusun ikon dan label secara vertikal
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade700), // Icon : simbol menu navigasi
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
