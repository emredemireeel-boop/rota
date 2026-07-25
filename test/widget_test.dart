import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rota/main.dart';
import 'package:rota/screens/media_composer_screen.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const RotaApp());
    expect(find.text('Rotan nereye?'), findsOneWidget);
    expect(find.text('Medya Haritam'), findsOneWidget);
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
}

class RotaAppForTest extends StatelessWidget {
  final Widget home;

  const RotaAppForTest({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: home);
  }
}
