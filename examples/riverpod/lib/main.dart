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

class Event extends CalendarEvent<Event> {
  Event({required this.dateTimeRange});

  @override
  final DateTimeRange dateTimeRange;

  @override
  bool get canModify => true;

  @override
  Event updateDateTimeRange({required DateTimeRange dateTimeRange}) {
    return Event(dateTimeRange: dateTimeRange);
  }
}

/// Provider for the calendar view.
final kalenderView = ChangeNotifierProvider<KalenderView>((ref) => KalenderView());
final eventsProvider = ChangeNotifierProvider<EventsController<Event>>((ref) => EventsController());

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsController = ref.read(eventsProvider);
    final view = ref.watch(kalenderView);

    return Scaffold(
      body: CalendarView<Event>(
        eventsController: eventsController,
        calendarController: view.controller,
        viewConfiguration: view.viewConfiguration,
        callbacks: CalendarCallbacks(
          onEventTapped: (id, event, renderBox) => view.controller.selectEvent(id, event),
          onEventCreate: (dateTimeRange) => Event(dateTimeRange: dateTimeRange),
          onEventCreated: (event) => eventsController.addEvent(event),
        ),
        header: Material(
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 2,
          child: Column(
            children: [
              CalendarToolBar(),
              CalendarHeader<Event>(multiDayTileComponents: tileComponents(context, body: false)),
            ],
          ),
        ),
        body: CalendarBody<Event>(
          multiDayTileComponents: tileComponents(context),
          monthTileComponents: tileComponents(context, body: false),
          multiDayBodyConfiguration: MultiDayBodyConfiguration(showMultiDayEvents: false),
          monthBodyConfiguration: MultiDayHeaderConfiguration(),
        ),
      ),
    );
  }
}

class KalenderView with ChangeNotifier {
  KalenderView();

  /// The controller for the view.
  final controller = CalendarController<Event>();

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
  late final _displayRange = DateTimeRange(start: _now.subtractDays(363), end: _now.addDays(365));
}
