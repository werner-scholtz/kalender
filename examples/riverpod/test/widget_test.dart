import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:riverpod_example/main.dart';

void main() {
  testWidgets('renders the calendar with a view switcher', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.byType(CalendarView), findsOneWidget);
    expect(find.byType(DropdownMenu<ViewConfiguration>), findsOneWidget);
  });

  test('selecting a view updates the provider', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final configs = container.read(viewConfigurationsProvider);
    expect(container.read(selectedViewProvider), configs.first, reason: 'defaults to the first configuration');

    container.read(selectedViewProvider.notifier).select(configs.last);
    expect(container.read(selectedViewProvider), configs.last, reason: 'selecting updates the state');
  });
}
