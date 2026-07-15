import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/widgets/internal_components/day_number.dart';

// The today highlight used to be a disabled IconButton.filled, which Material
// paints with the disabled colors. That greyed it out, so it read as
// "unavailable" rather than "today". DayNumber keeps the tonal look while
// staying non-interactive, for every component that shows a day number.
void main() {
  const todayKey = ValueKey('test.today');

  Future<ColorScheme> pump(WidgetTester tester, {required bool isToday, Size? size}) async {
    late ColorScheme colorScheme;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              colorScheme = Theme.of(context).colorScheme;
              return DayNumber(
                number: const Text('15'),
                isToday: isToday,
                todayKey: todayKey,
                size: size,
              );
            },
          ),
        ),
      ),
    );
    return colorScheme;
  }

  IconButton button(WidgetTester tester) => tester.widget<IconButton>(find.byType(IconButton));

  testWidgets('is never interactive', (tester) async {
    await pump(tester, isToday: false);
    expect(button(tester).onPressed, isNull);

    await pump(tester, isToday: true);
    expect(button(tester).onPressed, isNull, reason: 'the highlight is a label too');
  });

  testWidgets('applies the today key only when it is today', (tester) async {
    await pump(tester, isToday: true);
    expect(find.byKey(todayKey), findsOne);

    await pump(tester, isToday: false);
    expect(find.byKey(todayKey), findsNothing);
    expect(find.text('15'), findsOne, reason: 'the number still renders, just unhighlighted');
  });

  testWidgets('today keeps the tonal colors rather than the disabled greys', (tester) async {
    final colorScheme = await pump(tester, isToday: true);
    final style = button(tester).style;

    expect(
      style?.backgroundColor?.resolve({WidgetState.disabled}),
      colorScheme.secondaryContainer,
      reason: 'a disabled button would otherwise paint onSurface at 12% opacity',
    );
    expect(style?.foregroundColor?.resolve({WidgetState.disabled}), colorScheme.onSecondaryContainer);
  });

  testWidgets('a day that is not today is not given a background', (tester) async {
    await pump(tester, isToday: false);
    expect(button(tester).style, isNull, reason: 'it should be a plain icon button');
  });

  testWidgets('size tightens the button, null keeps its natural size', (tester) async {
    // The size constrains the highlight itself. IconButton keeps its own tap
    // target around that, so assert what is passed down rather than the
    // rendered footprint.
    await pump(tester, isToday: true, size: const Size(28, 28));
    expect(button(tester).constraints, BoxConstraints.tight(const Size(28, 28)));
    expect(button(tester).padding, EdgeInsets.zero, reason: 'the padding would fight a tight size');

    await pump(tester, isToday: true);
    expect(button(tester).constraints, isNull, reason: 'no size means the button decides');
    expect(button(tester).padding, isNull);
  });
}
