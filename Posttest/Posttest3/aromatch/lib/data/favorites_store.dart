import 'package:flutter/foundation.dart';
import '../models/perfume.dart';

// FavoritesStore : penyimpanan sederhana untuk daftar parfum favorit.
// Dibuat sebagai class dengan anggota static agar status favorit tetap
// sama walaupun pengguna berpindah-pindah halaman (Beranda <-> Favorit)
// lewat Navigator.push, tanpa perlu mengoper data secara manual.
class FavoritesStore {
  FavoritesStore._(); // constructor privat, class ini tidak perlu di-instansiasi

  // ValueNotifier : widget/objek "lanjutan" bawaan Flutter yang menyimpan
  // sebuah nilai sekaligus otomatis memberi tahu (notify) setiap
  // ValueListenableBuilder yang mendengarkannya saat nilai berubah.
  static final ValueNotifier<Set<String>> favoriteKeys =
      ValueNotifier<Set<String>>(<String>{});

  // Kunci unik satu parfum, dibentuk dari brand + nama.
  static String keyOf(Perfume p) => '${p.brand}-${p.name}';

  static bool isFavorite(Perfume p) => favoriteKeys.value.contains(keyOf(p));

  // Menambah/menghapus satu parfum dari daftar favorit.
  static void toggle(Perfume p) {
    final updated = Set<String>.from(favoriteKeys.value);
    final key = keyOf(p);
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    favoriteKeys.value = updated; 
  }

  static void clear() {
    favoriteKeys.value = <String>{};
  }
}
