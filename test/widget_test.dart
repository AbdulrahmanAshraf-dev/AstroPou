import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_pou/main.dart';

void main() {
  testWidgets('Splash screen loads and renders expected UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(const AstroPouApp());

    expect(find.text("Space Is Tough. You Don't Have to Face It Alone."), findsOneWidget);
    expect(
      find.text(
        'Stay healthy, feel connected, and never feel alone. '
        'Your personal space companion is here to support your well-being throughout every mission.',
      ),
      findsOneWidget,
    );
    expect(find.text('MEET YOUR COMPANION'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_outward), findsOneWidget);
  });
}
