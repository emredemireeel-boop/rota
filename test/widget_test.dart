import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota/main.dart';
import 'package:rota/screens/media_composer_screen.dart';
import 'package:rota/screens/scratch_map_screen.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const RotaApp());
    expect(find.text('Rotan nereye?'), findsOneWidget);
    expect(find.text('Medya Haritam'), findsOneWidget);
    expect(find.text('Gez Kazı Haritası'), findsOneWidget);
  });

  testWidgets('Media composer exposes photo and video choices', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RotaAppForTest(home: MediaComposerScreen()));

    expect(find.text('Fotoğraf çek'), findsOneWidget);
    expect(find.text('Fotoğraf seç'), findsOneWidget);
    expect(find.text('Video çek'), findsOneWidget);
    expect(find.text('Video seç'), findsOneWidget);
  });

  testWidgets('Gez Kazı map switches between Turkey and world', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RotaAppForTest(home: ScratchMapScreen()));

    expect(find.text('Türkiye Yolculuğum'), findsOneWidget);
    expect(find.text('İl adı veya plaka ara'), findsOneWidget);
    await tester.tap(find.text('Dünya'));
    await tester.pumpAndSettle();
    expect(find.text('Dünya Yolculuğum'), findsOneWidget);
  });

  testWidgets('Gezilmiş bir il aramadan seçilince geri alma onayı gösterilir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RotaAppForTest(home: ScratchMapScreen()));

    await tester.tap(find.text('İl adı veya plaka ara'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Adana');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Adana'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('İl adı veya plaka ara'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Adana');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Adana'));
    await tester.pumpAndSettle();

    expect(find.text('Gez Kazı işaretini geri al'), findsOneWidget);
    expect(
      find.textContaining('Kayıtlı fotoğraf ve videolarınız silinmez'),
      findsOneWidget,
    );
  });
}

class RotaAppForTest extends StatelessWidget {
  final Widget home;

  const RotaAppForTest({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: home);
  }
}
