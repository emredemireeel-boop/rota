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
    expect(find.text('Gez Kazan Haritası'), findsOneWidget);
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

  testWidgets('Gez Kazan map switches between Turkey and world', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const RotaAppForTest(home: ScratchMapScreen()),
    );

    expect(find.text('Türkiye Yolculuğum'), findsOneWidget);
    await tester.tap(find.text('Dünya'));
    await tester.pumpAndSettle();
    expect(find.text('Dünya Yolculuğum'), findsOneWidget);
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
