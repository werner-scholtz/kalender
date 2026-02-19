import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalender/kalender.dart';
import 'package:riverpod_example/calendar_components.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
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

/// Provider for the calendar view.
final kalenderView = ChangeNotifierProvider<KalenderView>((ref) => KalenderView());
final eventsProvider = ChangeNotifierProvider<EventsController>((ref) => DefaultEventsController());

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsController = ref.read(eventsProvider);
    final view = ref.watch(kalenderView);

    return Scaffold(
      body: CalendarView(
        eventsController: eventsController,
        calendarController: view.controller,
        viewConfiguration: view.viewConfiguration,
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => view.controller.selectEvent(event),
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
              CalendarToolBar(),
              CalendarHeader(multiDayTileComponents: tileComponents(context, body: false)),
            ],
          ),
        ),
        body: CalendarBody(
          multiDayTileComponents: tileComponents(context),
          monthTileComponents: tileComponents(context, body: false),
          scheduleTileComponents: scheduleTileComponents(context),
          multiDayBodyConfiguration: MultiDayBodyConfiguration(showMultiDayEvents: false),
          monthBodyConfiguration: MonthBodyConfiguration(),
        ),
      ),
    );
  }
}

class KalenderView with ChangeNotifier {
  KalenderView();

  /// The controller for the view.
  final controller = CalendarController();

  /// The viewConfiguration to display.
  late var _viewConfiguration = viewConfigurations[0];
  ViewConfiguration get viewConfiguration => _viewConfiguration;
  set viewConfiguration(ViewConfiguration view) {
    if (_viewConfiguration == view) return;
    _viewConfiguration = view;
    notifyListeners();
  }

  /// The [ViewConfiguration] the user can choose.
  late final viewConfigurations = [
    MultiDayViewConfiguration.week(displayRange: _displayRange, firstDayOfWeek: 1),
    MultiDayViewConfiguration.singleDay(displayRange: _displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: _displayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: _displayRange),
    MonthViewConfiguration.singleMonth(),
  ];

  final _now = DateTime.now();
  late final _displayRange =
      DateTimeRange(start: _now.copyWith(day: _now.day - 365), end: _now.copyWith(day: _now.day + 365));
}
