import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const PerfumeRecommenderApp());
}

// MaterialApp : widget wrapper utama dari aplikasi Flutter.
// Bertugas mengatur konfigurasi global seperti title, theme, dan halaman
// pertama yang ditampilkan (home).
class PerfumeRecommenderApp extends StatelessWidget {
  const PerfumeRecommenderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aromatch', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // MainPage : StatefulWidget induk yang menyimpan state keranjang, stok, dan tab aktif.
      home: const MainPage(),
    );
  }
}
