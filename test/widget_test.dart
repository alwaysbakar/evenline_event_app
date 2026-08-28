// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:evenline_event_app/main.dart';
import 'package:evenline_event_app/features/onboarding/presentation/onboarding_page.dart';

void main() {
  testWidgets('onboarding leads to the Evenline home screen', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(EvenlineApp(preferences: preferences));
    expect(find.text('Make plans\nworth remembering.'), findsOneWidget);

    await tester.tap(find.text('Start exploring'));
    await tester.pumpAndSettle();

    expect(find.text('Featured events'), findsOneWidget);
    expect(preferences.getBool(onboardingKey), isTrue);
  });
}
