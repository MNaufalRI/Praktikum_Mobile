import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const PerfumeRecommenderApp());
}

// MaterialApp : widget wrapper utama dari aplikasi Flutter (dari Modul 2).
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
      home: const HomePage(), 
    );
  }
}
