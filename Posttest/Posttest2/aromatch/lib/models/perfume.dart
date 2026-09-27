// Model data sederhana untuk merepresentasikan satu produk parfum.
// Model data ini hanya dipakai untuk menyimpan
// data yang nanti ditampilkan lewat widget Text, Container, dsb.
class Perfume {
  final String name;
  final String brand;
  final String price;
  final String imageUrl; // URL gambar produk parfum
  final List<String> notes; // daftar aroma/elemen yang dimiliki parfum ini

  const Perfume({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.notes,
  });
}
