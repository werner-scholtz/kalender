import 'package:demo/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'package:demo/data/event.dart';
import 'package:demo/overlay.dart';
import 'package:demo/theme.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  /// The range of dates to display in the calendar.
  final DateTimeRange? calendarDisplayRange;
  const App({super.key, this.calendarDisplayRange});

  static AppState? of(BuildContext context) => context.findAncestorStateOfType<AppState>();
  static EventsController<Event> eventsController(BuildContext context) => of(context)!.eventsController;
  static List<ViewConfiguration> views(BuildContext context) => of(context)!.viewConfigurations;
  static CalendarController<Event> controller(BuildContext context) => of(context)!.controller;
  static ValueNotifier<ViewConfiguration> viewConfiguration(BuildContext context) => of(context)!.viewConfiguration;

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  /// The current theme.
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    setState(() => _themeMode = mode);
  }

  void toggleTheme() => themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  final eventsController = DefaultEventsController<Event>();
  final controller = CalendarController<Event>();
  late final viewConfiguration = ValueNotifier(viewConfigurations[1]);

  late final viewConfigurations = [
    MultiDayViewConfiguration.singleDay(displayRange: widget.calendarDisplayRange),
    MultiDayViewConfiguration.week(displayRange: widget.calendarDisplayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: widget.calendarDisplayRange),
    MonthViewConfiguration.singleMonth(displayRange: widget.calendarDisplayRange),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: MaterialTheme.lightTheme(),
      darkTheme: MaterialTheme.darkTheme(),
      themeMode: _themeMode,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with CalendarOverlay {
  @override
  late final eventsController = App.eventsController(context);

  late final callbacks = CalendarCallbacks<Event>(
    onEventTapped: (event, renderBox) => createOverlay(event, renderBox),
    onEventCreate: (event) => event.copyWith(data: const Event(title: 'New Event')),
    onEventCreated: (event) => eventsController.addEvent(event),
    onTapped: (date) {
      eventsController.addEvent(CalendarEvent(
        dateTimeRange: DateTimeRange(start: date, end: date.add(const Duration(hours: 1))),
        data: const Event(title: 'New Event'),
      ));
    },
    onMultiDayTapped: (dateRange) {
      eventsController.addEvent(
        CalendarEvent(dateTimeRange: dateRange, data: const Event(title: 'New Event')),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalender Demo"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        elevation: 2,
        actions: [
          IconButton.filledTonal(
            onPressed: () => App.of(context)!.toggleTheme(),
            icon: Icon(
              App.of(context)!.themeMode == ThemeMode.dark ? Icons.brightness_2_rounded : Icons.brightness_7_rounded,
            ),
          ),
        ],
      ),
      body: OverlayPortal(
        controller: portalController,
        overlayChildBuilder: buildOverlay,
        child: CalendarWidget(
          controller: App.controller(context),
          view: App.viewConfiguration(context),
          callbacks: callbacks,
        ),
      ),
    );
  }
}
