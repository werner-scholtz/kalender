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
  const App({super.key});
  static AppState? of(BuildContext context) => context.findAncestorStateOfType<AppState>();
  static EventsController<Event> eventsController(BuildContext context) => of(context)!.eventsController;

  static List<ViewConfiguration> views(BuildContext context) => of(context)!.viewConfigurations;

  static CalendarController<Event> controller1(BuildContext context) => of(context)!.controller1;
  static ValueNotifier<ViewConfiguration> view1(BuildContext context) => of(context)!.viewConfiguration1;

  static CalendarController<Event> controller2(BuildContext context) => of(context)!.controller2;
  static ValueNotifier<ViewConfiguration> view2(BuildContext context) => of(context)!.viewConfiguration2;

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

  final controller1 = CalendarController<Event>();
  late final viewConfiguration1 = ValueNotifier(viewConfigurations[1]);

  final controller2 = CalendarController<Event>();
  late final viewConfiguration2 = ValueNotifier(viewConfigurations[1]);

  final viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MonthViewConfiguration.singleMonth(),
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
          controller: App.controller1(context),
          view: App.view1(context),
          callbacks: callbacks,
        ),
      ),
    );
  }
}
