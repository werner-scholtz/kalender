import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/main.dart';
import 'package:web_demo/timezone/standalone.dart';
import 'package:web_demo/widgets/toolbar/locale_dropdown.dart';
import 'package:web_demo/widgets/toolbar/theme_button.dart';

void main() {
  // main() normally does this before runApp; the tests pump MyApp directly.
  setUpAll(() async {
    await initializeTimeZonePackage();
  });

  testWidgets('renders the demo with a calendar and toolbar controls', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(CalendarView), findsWidgets);
    expect(find.byType(ThemeButton), findsOneWidget);
    expect(find.byType(LocaleDropdown), findsOneWidget);
  });

  test('the fallback locale is a supported locale', () {
    // _resolveLocale falls back to en_GB, so it must stay in the list.
    expect(supportedLocales, isNotEmpty);
    expect(supportedLocales, contains(const Locale('en', 'GB')));
  });
}
