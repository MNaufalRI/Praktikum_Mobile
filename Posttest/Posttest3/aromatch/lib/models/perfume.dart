// Model data sederhana untuk merepresentasikan satu produk parfum.
// Model data ini hanya dipakai untuk menyimpan
// data yang nanti ditampilkan lewat widget Text, Container, dsb.
class Perfume {
  final String name;
  final String brand;
  final String price;
  final String imageUrl; // URL gambar produk parfum
  final int stock; // stok AWAL (stok yang berjalan disimpan sebagai state di MainPage)
  final List<String> notes; // daftar aroma/elemen yang dimiliki parfum ini

  const Perfume({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.stock = 5,
    required this.notes,
  });

  // Harga dalam bentuk angka murni (contoh: "Rp1.470.000" -> 1470000),
  // dipakai untuk menghitung subtotal dan grand total keranjang.
  int get priceValue =>
      int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}
