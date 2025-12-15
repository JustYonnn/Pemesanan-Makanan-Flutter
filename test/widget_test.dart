import 'package:flutter_test/flutter_test.dart';
import 'package:pemesanan_makanan/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts without crashing
    expect(find.text('Pemesanan Makanan v0.1'), findsOneWidget);
  });
}
