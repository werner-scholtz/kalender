import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

/// The shared calendar controller.
final calendarControllerProvider = Provider<CalendarController>((ref) => CalendarController());

/// The shared events controller.
final eventsProvider = Provider<EventsController>((ref) => DefaultEventsController());

/// The view configurations the user can pick from.
final viewConfigurationsProvider = Provider<List<ViewConfiguration>>((ref) {
  final now = DateTime.now();
  final displayRange = DateTimeRange(start: now.copyWith(day: now.day - 365), end: now.copyWith(day: now.day + 365));
  return [
    MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: displayRange),
    MonthViewConfiguration.singleMonth(displayRange: displayRange),
  ];
});

/// The currently selected view configuration. Watchers rebuild when [select] runs.
class SelectedView extends Notifier<ViewConfiguration> {
  @override
  ViewConfiguration build() => ref.watch(viewConfigurationsProvider).first;

  void select(ViewConfiguration config) => state = config;
}

final selectedViewProvider = NotifierProvider<SelectedView, ViewConfiguration>(SelectedView.new);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // These providers never change, so read them; only the selected view
    // configuration should rebuild this widget.
    final eventsController = ref.read(eventsProvider);
    final calendarController = ref.read(calendarControllerProvider);
    final configurations = ref.read(viewConfigurationsProvider);
    final selected = ref.watch(selectedViewProvider);

    return Scaffold(
      body: CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: selected,
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
          onEventChanged: (event, updatedEvent) => eventsController.updateEvent(
            event: event,
            updatedEvent: updatedEvent,
          ),
        ),
        header: Material(
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    DropdownMenu<ViewConfiguration>(
                      initialSelection: selected,
                      dropdownMenuEntries: [
                        for (final config in configurations)
                          DropdownMenuEntry(value: config, label: config.name),
                      ],
                      onSelected: (value) {
                        if (value != null) ref.read(selectedViewProvider.notifier).select(value);
                      },
                    ),
                  ],
                ),
              ),
              CalendarHeader(),
            ],
          ),
        ),
        body: CalendarBody(
          multiDayBodyConfiguration: MultiDayBodyConfiguration(showMultiDayEvents: false),
          monthBodyConfiguration: MonthBodyConfiguration(),
        ),
      ),
    );
  }
}
