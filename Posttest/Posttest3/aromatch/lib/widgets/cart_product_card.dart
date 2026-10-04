import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk FilteringTextInputFormatter (input jumlah hanya angka)
import '../models/perfume.dart';
import '../utils/format.dart';

// CartProductCard : kartu satu produk di halaman Keranjang.
// Dibuat StatefulWidget karena memiliki TextEditingController (state yang
// hidup selama widget ada) dan perlu initState / didUpdateWidget / dispose.
class CartProductCard extends StatefulWidget {
  final Perfume perfume;
  final int quantity; // jumlah di keranjang (state milik MainPage)
  final int maxQuantity; // batas jumlah = stok tersisa + jumlah di keranjang
  final ValueChanged<int> onQuantityChanged; // callback ke CartPage -> MainPage.changeQuantity
  final VoidCallback onRemove; // callback ke MainPage.removeFromCart

  const CartProductCard({
    super.key,
    required this.perfume,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  late final TextEditingController quantityController;
  // FocusNode : memantau kapan TextField jumlah kehilangan fokus (pengguna selesai mengetik).
  final FocusNode _focusNode = FocusNode();

  // initState : dipanggil sekali saat State dibuat. Di sini controller diisi
  // dengan jumlah awal produk (state dari TextEditingController).
  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: '${widget.quantity}');
    // Saat fokus hilang dan isi field kosong / bukan angka valid, kembalikan ke
    // jumlah terakhir yang sah agar tampilan selalu sama dengan isi keranjang.
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final parsed = int.tryParse(quantityController.text);
        if (parsed == null || parsed < 1) {
          quantityController.text = '${widget.quantity}';
        }
      }
    });
  }

  // didUpdateWidget : dipanggil saat widget induk mengirim data baru.
  // Dipakai untuk menyamakan isi TextField dengan quantity terbaru
  // apabila ada perubahan dari luar CartProductCard (mis. hasil clamp).
  @override
  void didUpdateWidget(covariant CartProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity &&
        quantityController.text != '${widget.quantity}') {
      quantityController.text = '${widget.quantity}';
    }
  }

  // dispose : membersihkan controller agar tidak terjadi memory leak.
  @override
  void dispose() {
    quantityController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Validasi input: teks -> angka, abaikan jika kosong/bukan angka/kurang dari 1,
  // lalu batasi maksimal sesuai stok (clamp). Perubahan dikirim ke atas lewat callback.
  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1) return;
    final clamped = parsed.clamp(1, widget.maxQuantity).toInt();
    // Jika input melebihi stok, tampilkan kembali angka yang sudah dibatasi.
    if (clamped != parsed) {
      quantityController.text = '$clamped';
      quantityController.selection =
          TextSelection.collapsed(offset: quantityController.text.length);
    }
    widget.onQuantityChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.perfume.priceValue * widget.quantity;
    return Container( // Container : pembungkus kartu (margin, padding, border, radius)
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row( // Row : gambar, detail, dan input jumlah disusun horizontal
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect( // ClipRRect : memotong gambar dengan sudut membulat
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 72,
              height: 72,
              color: Colors.deepPurple.shade50,
              child: Image.network( // Image.network : foto produk dari URL
                widget.perfume.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.local_florist,
                  color: Colors.deepPurple,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), // SizedBox : jarak horizontal
          Expanded( // Expanded : kolom detail mengisi sisa lebar Row
            child: Column( // Column : nama, brand, harga, subtotal, batas stok
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( // Text : nama parfum
                  widget.perfume.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  widget.perfume.brand,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text( // Text : subtotal = harga x jumlah (state turunan)
                  formatRupiah(subtotal),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Maks. ${widget.maxQuantity}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column( // Column : input jumlah di atas, tombol hapus di bawah
            children: [
              SizedBox( // SizedBox : membatasi lebar TextField jumlah
                width: 56,
                child: TextField( // TextField : input jumlah, isinya dikelola quantityController
                  controller: quantityController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) =>
                          newValue.text.startsWith('0') ? oldValue : newValue,
                    ),
                  ],
                  textAlign: TextAlign.center,
                  onChanged: updateQuantity,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              IconButton( // IconButton : menghapus produk dari keranjang
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.redAccent,
                tooltip: 'Hapus dari keranjang',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
