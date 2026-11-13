import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_pou/main.dart';
import 'package:astro_pou/screens/astropou_splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('AstroPou splash screen cycles dynamic messages every 3 seconds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AstroPouSplashScreen(),
      ),
    );

    // Initial message
    expect(
      find.text('Hey, space buddy! Ready for an amazing mission together? 🚀'),
      findsOneWidget,
    );
    expect(find.text('Explore'), findsOneWidget);

    // Advance by 3 seconds + animation duration
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    // Second message should now be visible
    expect(
      find.text('Space missions are exciting, but your health comes first! 💙'),
      findsOneWidget,
    );

    // Advance by another 3 seconds + animation duration
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));

    // Third message
    expect(
      find.text("I'll help you keep an eye on your health throughout the journey."),
      findsOneWidget,
    );
  });

  testWidgets('Tapping MEET YOUR COMPANION navigates to AstroPou splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AstroPouApp());

    await tester.tap(find.text('MEET YOUR COMPANION'));
    await tester.pumpAndSettle();

    expect(
      find.text('Hey, space buddy! Ready for an amazing mission together? 🚀'),
      findsOneWidget,
    );
    expect(find.text('Explore'), findsOneWidget);
  });
}
