import 'package:flutter_test/flutter_test.dart';
import 'package:halo_mina/main.dart';

void main() {
  testWidgets('Halo Minna menampilkan halaman awal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HaloMinnaApp());

    // Selesaikan animasi splash dan timer yang berjalan.
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(HaloMinnaApp), findsOneWidget);
  });
}
