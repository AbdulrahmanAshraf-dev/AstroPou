import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:astro_pou/main.dart';
import 'package:astro_pou/screens/astropou_splash_screen.dart';
import 'package:astro_pou/screens/home_screen.dart';

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
  });

  testWidgets('Tapping MEET YOUR COMPANION navigates to AstroPou splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AstroPouApp());

    await tester.tap(find.text('MEET YOUR COMPANION'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text('Hey, space buddy! Ready for an amazing mission together? 🚀'),
      findsOneWidget,
    );
    expect(find.text('Explore'), findsOneWidget);
  });

  testWidgets('Home screen default state hides cards and shows companion greeting', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Header is visible
    expect(find.text('Good Morning, Commander'), findsOneWidget);
    expect(find.text("Here's your health status for today."), findsOneWidget);

    // AstroPou speech bubble and mission status card are visible
    expect(
      find.text("Your health looks good! 🚀\nLet's keep your vitals stable and stay mission-ready."),
      findsOneWidget,
    );
    expect(find.text('Mission Day 99'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);

    // By default, cards have opacity 0.0
    final cardioOpacity = tester.widget<AnimatedOpacity>(
      find.ancestor(of: find.text('cardiovascular'), matching: find.byType(AnimatedOpacity)),
    );
    expect(cardioOpacity.opacity, 0.0);
  });

  testWidgets('Hotspots update AstroPou dialogue and cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    final hotspots = find.byType(GestureDetector);

    // Tap cardiovascular hotspot (hotspot index 2)
    await tester.tap(hotspots.at(2));
    await tester.pump(const Duration(milliseconds: 300));

    // Cardiovascular card should now have opacity 1.0
    final cardioOpacityAfterTap = tester.widget<AnimatedOpacity>(
      find.ancestor(of: find.text('cardiovascular'), matching: find.byType(AnimatedOpacity)),
    );
    expect(cardioOpacityAfterTap.opacity, 1.0);

    // AstroPou speech bubble reacts to cardiovascular
    expect(
      find.text("Heart rate is stable at 66%. Keep up the calm breathing, Commander! ❤️"),
      findsOneWidget,
    );

    // Tap radiation hotspot (hotspot index 1)
    await tester.tap(hotspots.at(1));
    await tester.pump(const Duration(milliseconds: 300));

    // Radiation card active
    final radOpacity = tester.widget<AnimatedOpacity>(
      find.ancestor(of: find.text('radiation'), matching: find.byType(AnimatedOpacity)),
    );
    expect(radOpacity.opacity, 1.0);

    // AstroPou speech bubble reacts to radiation
    expect(
      find.text("Radiation level is at 80%. Shield integrity is holding strong, stay safe! 🛡️"),
      findsOneWidget,
    );

    // Tap radiation hotspot again to deselect
    await tester.tap(hotspots.at(1));
    await tester.pump(const Duration(milliseconds: 300));

    // Returns to default mission health status message
    expect(
      find.text("Your health looks good! 🚀\nLet's keep your vitals stable and stay mission-ready."),
      findsOneWidget,
    );
  });

  testWidgets('Tapping AstroPou directly triggers encouraging companion remarks', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Tap AstroPou image by its key
    final astropouGesture = find.byKey(const Key('astropou_companion'));
    expect(astropouGesture, findsOneWidget);

    await tester.tap(astropouGesture);
    await tester.pump(const Duration(milliseconds: 300));

    // Displays first encouraging remark
    expect(find.text("You're doing great, Commander! 🌟"), findsOneWidget);

    // Tap again
    await tester.tap(astropouGesture);
    await tester.pump(const Duration(milliseconds: 300));

    // Displays second encouraging remark
    expect(find.text("Keep it up! Your health looks good! 🚀"), findsOneWidget);
  });

  testWidgets('Tapping Explore on AstroPou screen navigates to Home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AstroPouSplashScreen(),
      ),
    );

    await tester.tap(find.text('Explore'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Good Morning, Commander'), findsOneWidget);
    expect(find.text('Mission Day 99'), findsOneWidget);
  });
}
