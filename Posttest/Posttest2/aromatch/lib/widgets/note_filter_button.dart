import 'package:flutter/material.dart';

// Widget kustom untuk satu tombol filter aroma (note).
// Widget ini dibuat dengan menggunakan GestureDetector (mendeteksi tap)
// + Container + Text
class NoteFilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NoteFilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container( // Container: mengatur warna latar, padding, border, dan radius tombol
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // padding: jarak teks ke tepi tombol
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white, 
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
          ), // border : garis tepi tombol
          borderRadius: BorderRadius.circular(20), // borderRadius: sudut membulat seperti pill
        ),
        child: Text( // Text: menampilkan nama aroma pada tombol
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
