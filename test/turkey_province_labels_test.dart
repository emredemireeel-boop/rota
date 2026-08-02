import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota/widgets/turkey_province_labels.dart';

void main() {
  testWidgets('il etiketleri küçük haritada sınırların içinde kalır', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 320,
              height: 180,
              child: TurkeyProvinceLabels(),
            ),
          ),
        ),
      ),
    );

    final mapRect = tester.getRect(find.byType(TurkeyProvinceLabels));
    for (var plate = 1; plate <= 81; plate++) {
      final label = find.byKey(ValueKey('province-label-$plate'));
      expect(label, findsOneWidget);
      final rect = tester.getRect(label);
      expect(rect.left, greaterThanOrEqualTo(mapRect.left));
      expect(rect.top, greaterThanOrEqualTo(mapRect.top));
      expect(rect.right, lessThanOrEqualTo(mapRect.right));
      expect(rect.bottom, lessThanOrEqualTo(mapRect.bottom));
    }
  });

  testWidgets('uzun il adları okunabilir kısa biçimde gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 360,
          height: 220,
          child: TurkeyProvinceLabels(highlightedPlates: {46, 63}),
        ),
      ),
    );

    expect(find.text('Afyon'), findsOneWidget);
    expect(find.text('K.Maraş'), findsOneWidget);
    expect(find.text('Ş.Urfa'), findsOneWidget);
  });
}
