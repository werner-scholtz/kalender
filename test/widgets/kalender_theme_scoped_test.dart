import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Covers [KalenderTheme] as a widget: scoping a theme to part of the tree, and
/// where it sits relative to the theme extension and the Material 3 defaults.
void main() {
  /// The rendered color of the day separator, which follows the theme.
  Color? separatorColor(WidgetTester tester, {Finder? within}) {
    final finder =
        within == null ? find.byType(Container) : find.descendant(of: within, matching: find.byType(Container));
    return tester.widget<Container>(finder.first).color;
  }

  Widget app({KalenderThemeData? extension, required Widget child}) {
    return MaterialApp(
      theme: ThemeData(extensions: [if (extension != null) extension]),
      home: Scaffold(body: child),
    );
  }

  testWidgets('a scoped theme applies below it', (tester) async {
    const scoped = Color(0xFF00FF00);

    await tester.pumpWidget(
      app(
        child: const KalenderTheme(
          data: KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: scoped)),
          child: DaySeparator(),
        ),
      ),
    );

    expect(separatorColor(tester), scoped);
  });

  testWidgets('a scoped theme beats the extension', (tester) async {
    const fromExtension = Color(0xFFFF0000);
    const fromScope = Color(0xFF00FF00);

    await tester.pumpWidget(
      app(
        extension: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: fromExtension)),
        child: const KalenderTheme(
          data: KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: fromScope)),
          child: DaySeparator(),
        ),
      ),
    );

    expect(separatorColor(tester), fromScope);
  });

  testWidgets('a scoped theme fills in from the extension field by field', (tester) async {
    const fromExtension = Color(0xFFFF0000);

    await tester.pumpWidget(
      app(
        extension: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: fromExtension)),
        child: const KalenderTheme(
          // Sets the width only, so the color still comes from the extension.
          data: KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(width: 5)),
          child: DaySeparator(),
        ),
      ),
    );

    expect(separatorColor(tester), fromExtension);
  });

  testWidgets('two calendars in one app can be themed differently', (tester) async {
    const left = Color(0xFF00FF00);
    const right = Color(0xFF0000FF);
    final leftKey = UniqueKey();
    final rightKey = UniqueKey();

    await tester.pumpWidget(
      app(
        child: Row(
          children: [
            Expanded(
              child: KalenderTheme(
                data: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: left)),
                child: SizedBox(key: leftKey, child: const DaySeparator()),
              ),
            ),
            Expanded(
              child: KalenderTheme(
                data: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: right)),
                child: SizedBox(key: rightKey, child: const DaySeparator()),
              ),
            ),
          ],
        ),
      ),
    );

    expect(separatorColor(tester, within: find.byKey(leftKey)), left);
    expect(separatorColor(tester, within: find.byKey(rightKey)), right);
  });

  testWidgets('the nearest scope wins when they nest', (tester) async {
    const outer = Color(0xFFFF0000);
    const inner = Color(0xFF00FF00);

    await tester.pumpWidget(
      app(
        child: const KalenderTheme(
          data: KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: outer)),
          child: KalenderTheme(
            data: KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: inner)),
            child: DaySeparator(),
          ),
        ),
      ),
    );

    expect(separatorColor(tester), inner);
  });

  testWidgets('changing the data notifies dependents, an equal value does not', (tester) async {
    // Counts didChangeDependencies, not builds. A build counter cannot tell a
    // real notification from the child being replaced by its parent rebuilding.
    _DependentState.notifications = 0;

    Widget build(KalenderThemeData data) {
      return app(child: KalenderTheme(data: data, child: const _Dependent()));
    }

    await tester.pumpWidget(build(const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(width: 1))));
    expect(_DependentState.notifications, 1);

    // Same values, a different instance.
    await tester.pumpWidget(build(const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(width: 1))));
    expect(_DependentState.notifications, 1, reason: 'an equal theme is not a change');

    await tester.pumpWidget(build(const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(width: 2))));
    expect(_DependentState.notifications, 2);
  });

  testWidgets('wrap carries the theme into a detached tree', (tester) async {
    // What InheritedTheme adds over a plain InheritedWidget, and the reason the
    // dragged tile is themed: the captured themes are replayed somewhere that
    // is not a descendant.
    const scoped = Color(0xFF00FF00);
    late Widget captured;

    await tester.pumpWidget(
      app(
        child: KalenderTheme(
          data: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: scoped)),
          child: Builder(
            builder: (context) {
              captured = InheritedTheme.captureAll(context, const DaySeparator());
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    // Pumped outside the scope entirely.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: captured)));

    expect(separatorColor(tester), scoped);
  });
}

/// Reads the theme and records every time it is reported as changed.
class _Dependent extends StatefulWidget {
  const _Dependent();

  @override
  State<_Dependent> createState() => _DependentState();
}

class _DependentState extends State<_Dependent> {
  static int notifications = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    KalenderTheme.of(context);
    notifications++;
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
