import 'package:flutter/material.dart';
import '../utils/format.dart';

// CheckoutSuccessPage : halaman konfirmasi setelah checkout berhasil.
// Hanya menampilkan data yang diterima (total), jadi cukup StatelessWidget.
class CheckoutSuccessPage extends StatelessWidget {
  final int total; // total belanja yang sudah dibayar (snapshot saat checkout)

  const CheckoutSuccessPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold : struktur dasar halaman
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding( // Padding : jarak konten dari tepi layar
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column( // Column : ikon, total, dan tombol disusun vertikal di tengah
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar( // CircleAvatar : lingkaran latar ikon centang
                radius: 36,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Total', style: TextStyle(fontSize: 20)),
              Text(
                formatRupiah(total),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( // ElevatedButton : kembali ke aplikasi utama
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Kembali'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
