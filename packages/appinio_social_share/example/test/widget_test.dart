import 'package:appinio_social_share_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Mostra i pulsanti di condivisione', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.widgetWithText(ElevatedButton, 'Condividi testo'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Condividi testo e file'),
        findsOneWidget);
  });
}
