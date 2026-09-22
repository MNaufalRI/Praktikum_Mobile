import 'package:flutter/material.dart';
import '../models/perfume.dart';

// Widget kustom untuk menampilkan satu kartu hasil rekomendasi parfum.
class PerfumeCard extends StatelessWidget {
  final Perfume perfume;

  const PerfumeCard({super.key, required this.perfume});

  @override
  Widget build(BuildContext context) {
    return Container( // Container : membungkus seluruh kartu, mengatur margin, padding, warna, border, radius
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12), // borderRadius : sudut kartu membulat
      ),
      child: Row( // Row : menyusun gambar placeholder dan detail parfum secara horizontal
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect( // ClipRRect : memotong gambar mengikuti sudut membulat kartu
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 72,
              height: 72,
              color: Colors.deepPurple.shade50, // warna latar selagi gambar dimuat / jika gagal
              child: Image.network( // Image.network : menampilkan foto produk asli dari URL dataset 
                perfume.imageUrl,   // jadi, disini saya menambahkan dataset dari kaggle sebagai data dummy (sementara)
                width: 72,          // dan menggunakan network untuk menyalin URL yang ada di dataset (dummy)
                height: 72,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Icon( // Icon : pengganti jika gambar gagal dimuat
                  Icons.local_florist,
                  color: Colors.deepPurple,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), // SizedBox  jarak horizontal antara gambar dan teks
          Expanded( // Expanded : memaksa kolom detail mengisi sisa ruang pada Row
            child: Column( // Column : menyusun nama, brand, notes, dan harga secara vertikal
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( // Text : nama parfum
                  perfume.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text( // Text : nama brand
                  perfume.brand,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 6), // SizedBox : jarak vertikal sebelum daftar notes
                Row( // Row : menyusun tag-tag note/aroma secara horizontal
                  children: [
                    for (int i = 0; i < perfume.notes.length; i++) ...[
                      if (i > 0) const SizedBox(width: 6), // SizedBox: jarak antar tag note
                      Container( // Container : tag kecil untuk satu note/aroma
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text( // Text : label nama note
                          perfume.notes[i],
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text( // Text : harga parfum
                  perfume.price,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
