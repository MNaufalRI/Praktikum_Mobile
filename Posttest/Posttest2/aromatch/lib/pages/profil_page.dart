import 'package:flutter/material.dart';
import 'favorit_page.dart';

// ProfilPage : halaman ketiga aplikasi, menampilkan data diri pengguna
// beserta beberapa pengaturan sederhana. Dibuat pada Modul 3 (Widget
// Lanjutan & Navigation) dan diakses lewat NavigationBar.
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // Status switch "Mode gelap", disimpan sebagai state lokal halaman ini.
  bool _darkMode = false;
  bool _notifAktif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold : struktur dasar halaman profil
      backgroundColor: Colors.white,
      body: SafeArea( // SafeArea : hindari konten tertutup notch/status bar perangkat
        child: SingleChildScrollView( // SingleChildScrollView : seluruh isi halaman bisa discroll vertikal
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text( // Text : judul halaman
                'Profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16), // SizedBox : jarak vertikal antar elemen
              Center(
                child: Stack( // Stack : menumpuk foto profil dengan lencana kecil di pojoknya
                  children: [
                    ClipOval( // ClipOval : memotong gambar menjadi bentuk lingkaran
                      child: Image.asset( // Image.asset : menampilkan gambar dari folder assets aplikasi
                        'assets/avatar_placeholder.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned( // Positioned : menempatkan lencana verifikasi di pojok kanan bawah foto
                      right: 0,
                      bottom: 0,
                      child: Container( // Container : latar bulat kecil untuk ikon lencana
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon( // Icon : lencana pengguna terverifikasi
                          Icons.verified,
                          color: Colors.deepPurple,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text( // Text : nama pengguna
                  'Muhammad Naufal Rifyan Ilham',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  'mnaufalriunmul@student.unmul.ac.id',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(), // Divider : garis pemisah antar bagian konten
              ListTile( // ListTile : baris menu dengan ikon, judul, dan panah di kanan
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, color: Colors.deepPurple),
                title: const Text('Riwayat pencarian'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              SwitchListTile( // SwitchListTile : baris menu dengan Switch bawaan Flutter di kanan
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.dark_mode_outlined, color: Colors.deepPurple),
                title: const Text('Mode gelap'),
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value), // setState : perbarui tampilan Switch
              ),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.notifications_outlined, color: Colors.deepPurple),
                title: const Text('Notifikasi rekomendasi'),
                value: _notifAktif,
                onChanged: (value) => setState(() => _notifAktif = value),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline, color: Colors.deepPurple),
                title: const Text('Tentang Aromatch'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTentangDialog(context), // menampilkan AlertDialog
              ),
              const Divider(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( // ElevatedButton : tombol utama untuk aksi keluar akun
                  onPressed: () => _showKeluarDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Keluar akun'),
                ),
              ),
            ],
          ),
        ),
      ),
      // NavigationBar : index ke-2 (Profil) ditandai aktif di halaman ini.
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: 2,
        onDestinationSelected: (index) {
          if (index == 0) {
            // Navigator.pop : kembali ke halaman sebelumnya (Beranda) dengan
            // menghapus halaman Profil dari navigation stack.
            Navigator.pop(context);
          } else if (index == 1) {
            // Navigator.pushReplacement : mengganti halaman Profil dengan Favorit
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FavoritPage()),
            );
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorit'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // showDialog + AlertDialog : menampilkan kotak dialog informasi di atas halaman.
  void _showTentangDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog( // AlertDialog : kotak dialog bawaan Material untuk info/konfirmasi
        title: const Text('Tentang Aromatch'),
        content: const Text(
          'Aromatch adalah aplikasi rekomendasi parfum berdasarkan aroma/note '
          'favorit pengguna. Aplikasi ini masih dalam Tahap Pengembangan, dibuat untuk memenuhi Posttest praktikum Pemrograman '
          'Piranti Bergerak.',
        ),
        actions: [
          TextButton( // TextButton : tombol teks polos untuk menutup dialog
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // showDialog + AlertDialog : konfirmasi sebelum kembali ke Beranda (simulasi keluar akun).
  void _showKeluarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar akun?'),
        content: const Text('Kamu akan kembali ke halaman Beranda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // tutup dialog saja
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // Navigator.pop : kembali ke HomePage
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
