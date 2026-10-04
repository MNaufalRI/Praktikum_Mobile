import 'package:flutter/material.dart';
import '../data/dummy_perfumes.dart';
import '../data/favorites_store.dart';
import '../models/perfume.dart';
import '../utils/format.dart';
import '../widgets/cart_product_card.dart';

// CartPage : halaman Keranjang. Tidak menyimpan state sendiri; semua data
// (isi keranjang & stok) berasal dari MainPage, dan perubahan dikirim balik
// lewat callback (konsep "lifting state up" pada Modul 4).
class CartPage extends StatelessWidget {
  final Map<String, int> cart; // key parfum -> jumlah di keranjang
  final Map<String, int> stock; // key parfum -> stok tersisa
  final void Function(Perfume, int) onQuantityChanged;
  final void Function(Perfume) onRemove;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cart,
    required this.stock,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    // Produk yang sedang ada di keranjang.
    final items = dummyPerfumes
        .where((p) => (cart[FavoritesStore.keyOf(p)] ?? 0) > 0)
        .toList();

    // State turunan: Grand Total dihitung dari isi keranjang, bukan disimpan terpisah.
    int grandTotal = 0;
    for (final p in items) {
      grandTotal += p.priceValue * cart[FavoritesStore.keyOf(p)]!;
    }

    return Scaffold( // Scaffold : struktur dasar halaman keranjang
      backgroundColor: Colors.white,
      body: SafeArea( // SafeArea : hindari notch/status bar
        child: Column( // Column : judul, daftar item, lalu bar total di bawah
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding( // Padding : jarak judul dari tepi layar
              padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                'Keranjang',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded( // Expanded : daftar item mengisi sisa ruang vertikal
              child: items.isEmpty
                  ? Center( // Center : pesan saat keranjang kosong
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined,
                              size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 8),
                          Text('Keranjang masih kosong',
                              style: TextStyle(color: Colors.grey.shade500)),
                          const SizedBox(height: 4),
                          Text(
                            'Tekan "Masukkan Keranjang" pada kartu parfum',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder( // ListView.builder : daftar item yang bisa discroll
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final p = items[index];
                        final key = FavoritesStore.keyOf(p);
                        final qty = cart[key]!;
                        return CartProductCard(
                          // ValueKey : menjaga State (controller) tetap menempel pada
                          // produk yang sama saat ada item lain yang dihapus.
                          key: ValueKey(key),
                          perfume: p,
                          quantity: qty,
                          maxQuantity: qty + (stock[key] ?? 0),
                          onQuantityChanged: (value) => onQuantityChanged(p, value),
                          onRemove: () => onRemove(p),
                        );
                      },
                    ),
            ),
            Container( // Container : bar total di bawah, diberi bayangan agar terlihat melayang
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow( // BoxShadow : efek melayang di atas daftar
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row( // Row : total di kiri, tombol checkout di kanan
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text(formatRupiah(grandTotal),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  // ElevatedButton : aktif hanya jika grandTotal > 0 (state turunan dari keranjang).
                  ElevatedButton.icon(
                    onPressed: grandTotal > 0 ? onCheckout : null,
                    icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                    label: const Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
