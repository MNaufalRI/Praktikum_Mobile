import 'package:flutter_test/flutter_test.dart';

import 'package:aromatch/main.dart';

void main() {
  testWidgets('Menambah parfum ke keranjang menaikkan badge', (tester) async {
    await tester.pumpWidget(const PerfumeRecommenderApp());

    // Badge belum muncul karena keranjang masih kosong.
    expect(find.text('1'), findsNothing);

    // Tekan tombol "Masukkan Keranjang" pada kartu pertama.
    await tester.tap(find.text('Masukkan Keranjang').first);
    await tester.pump();

    // Badge pada tab Keranjang kini menampilkan 1.
    expect(find.text('1'), findsOneWidget);
  });
}
