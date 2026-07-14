import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Verifies the style layering on a rendered component:
/// widget-level style over theme extension over Material 3 defaults.
void main() {
  Widget app({KalenderThemeData? extension, required Widget child}) {
    return MaterialApp(
      theme: ThemeData(extensions: [if (extension != null) extension]),
      home: Scaffold(body: child),
    );
  }

  Color? daySeparatorColor(WidgetTester tester) {
    final container = tester.widget<Container>(find.byType(Container));
    return container.color;
  }

  testWidgets('a component uses the Material 3 default when nothing is set', (tester) async {
    await tester.pumpWidget(app(child: const DaySeparator()));
    final context = tester.element(find.byType(DaySeparator));
    expect(daySeparatorColor(tester), Theme.of(context).colorScheme.surfaceContainerHighest);
  });

  testWidgets('a KalenderThemeData extension overrides the default', (tester) async {
    const extension = KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF123456)));
    await tester.pumpWidget(app(extension: extension, child: const DaySeparator()));
    expect(daySeparatorColor(tester), const Color(0xFF123456));
  });

  testWidgets('a widget-level style overrides the extension', (tester) async {
    const extension = KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF123456)));
    const widgetStyle = DaySeparatorStyle(color: Color(0xFF654321));
    await tester.pumpWidget(app(extension: extension, child: const DaySeparator(style: widgetStyle)));
    expect(daySeparatorColor(tester), const Color(0xFF654321));
  });

  testWidgets('a widget-level style only overrides the fields it sets', (tester) async {
    // The extension sets the color and width, the widget style only the width.
    const extension = KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF123456), width: 3));
    const widgetStyle = DaySeparatorStyle(width: 5);
    await tester.pumpWidget(app(extension: extension, child: const DaySeparator(style: widgetStyle)));
    expect(daySeparatorColor(tester), const Color(0xFF123456));
    final box = tester.renderObject<RenderBox>(find.byType(Container));
    expect(box.size.width, 5);
  });

  testWidgets('the time indicator defaults to the error color of the color scheme', (tester) async {
    await tester.pumpWidget(
      app(
        child: TimeIndicator(
          timeOfDayRange: TimeOfDayRange.allDay(),
          heightPerMinute: 1,
          location: null,
          nowCallback: () => DateTime(2026, 1, 1, 12),
        ),
      ),
    );
    final context = tester.element(find.byType(TimeIndicator));
    final containers = tester.widgetList<Container>(find.byType(Container));
    expect(containers.map((c) => c.color), contains(Theme.of(context).colorScheme.error));
  });
}
