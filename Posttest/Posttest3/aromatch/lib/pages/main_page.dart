import 'package:flutter/material.dart';
import '../data/dummy_perfumes.dart';
import '../data/favorites_store.dart';
import '../models/perfume.dart';
import 'cart_page.dart';
import 'checkout_success_page.dart';
import 'favorit_page.dart';
import 'home_page.dart';
import 'profil_page.dart';

// MainPage : StatefulWidget induk (pada modul disebut MainApp).
// Seluruh state yang dipakai bersama antar halaman disimpan di sini:
//   - _currentIndex : tab NavigationBar yang aktif
//   - _stock        : stok terkini tiap parfum
//   - _cart         : isi keranjang (key parfum -> jumlah)
// Halaman anak menerima data lewat parameter dan mengubahnya lewat callback;
// setState hanya dipanggil di sini (lifting state up).
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Stok awal diambil dari data dummy, lalu berkurang/bertambah saat keranjang berubah.
  final Map<String, int> _stock = {
    for (final p in dummyPerfumes) FavoritesStore.keyOf(p): p.stock,
  };
  final Map<String, int> _cart = {};

  // State turunan: total jumlah item di keranjang (untuk badge pada NavigationBar).
  int get _cartCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  // Menambah 1 produk ke keranjang dan mengurangi stok.
  void addToCart(Perfume p) {
    final key = FavoritesStore.keyOf(p);
    final remaining = _stock[key] ?? 0;
    if (remaining <= 0) return; // stok habis, abaikan
    setState(() {
      _stock[key] = remaining - 1;
      _cart[key] = (_cart[key] ?? 0) + 1;
    });
    // ScaffoldMessenger + SnackBar : umpan balik singkat bahwa produk masuk keranjang.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${p.name} ditambahkan ke keranjang'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  // Mengubah jumlah produk di keranjang; selisihnya disesuaikan ke stok.
  void changeQuantity(Perfume p, int newQuantity) {
    final key = FavoritesStore.keyOf(p);
    final current = _cart[key] ?? 0;
    if (current == 0) return;
    final maxQuantity = current + (_stock[key] ?? 0);
    final quantity = newQuantity.clamp(1, maxQuantity).toInt();
    setState(() {
      _stock[key] = maxQuantity - quantity;
      _cart[key] = quantity;
    });
  }

  // Menghapus produk dari keranjang dan mengembalikan stoknya.
  void removeFromCart(Perfume p) {
    final key = FavoritesStore.keyOf(p);
    setState(() {
      final qty = _cart.remove(key) ?? 0;
      _stock[key] = (_stock[key] ?? 0) + qty;
    });
  }

  // Checkout: hitung total, kosongkan keranjang (stok tetap berkurang), lalu buka halaman sukses.
  void checkout() {
    int total = 0;
    for (final p in dummyPerfumes) {
      total += p.priceValue * (_cart[FavoritesStore.keyOf(p)] ?? 0);
    }
    if (total <= 0) return;
    setState(() => _cart.clear());
    // Navigator.push : membuka halaman sukses di atas MainPage.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutSuccessPage(total: total)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold : kerangka utama berisi halaman aktif + NavigationBar
      backgroundColor: Colors.white,
      // IndexedStack : menampilkan satu halaman sesuai index, tetapi semua halaman
      // tetap hidup sehingga state HomePage (teks pencarian, filter) tidak hilang saat pindah tab.
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(stock: _stock, onAddToCart: addToCart),
          FavoritPage(stock: _stock, onAddToCart: addToCart),
          CartPage(
            cart: _cart,
            stock: _stock,
            onQuantityChanged: changeQuantity,
            onRemove: removeFromCart,
            onCheckout: checkout,
          ),
          ProfilPage(onKeluar: () => setState(() => _currentIndex = 0)),
        ],
      ),
      // NavigationBar : navigasi bawah; setState pada onDestinationSelected mengganti tab aktif.
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            // Badge : lencana angka jumlah item keranjang, tersembunyi saat keranjang kosong.
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
