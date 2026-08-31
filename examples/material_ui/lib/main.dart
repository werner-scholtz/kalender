// The calendar's public API still uses the types from package:flutter/material.dart.
// This import supplies DateTimeRange and TimeOfDay wherever kalender expects them.
import 'package:flutter/material.dart' as legacy;
import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender on material_ui',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      // The bridge maps the theme and installs the legacy localizations the
      // calendar looks up. Without it the timeline throws.
      // ignore: deprecated_member_use
      builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();

  final now = DateTime.now();

  late final displayRange = legacy.DateTimeRange(
    start: now.subtract(const Duration(days: 365)),
    end: now.add(const Duration(days: 365)),
  );

  late final viewConfiguration = MultiDayViewConfiguration.week(
    displayRange: displayRange,
    initialTimeOfDay: const legacy.TimeOfDay(hour: 7, minute: 0),
  );

  @override
  void initState() {
    super.initState();
    final today = DateTime(now.year, now.month, now.day);
    eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: legacy.DateTimeRange(
          start: today.add(const Duration(hours: 9)),
          end: today.add(const Duration(hours: 10, minutes: 30)),
        ),
      ),
      CalendarEvent(
        dateTimeRange: legacy.DateTimeRange(
          start: today.add(const Duration(days: 1, hours: 13)),
          end: today.add(const Duration(days: 1, hours: 14)),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    eventsController.dispose();
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender on material_ui')),
      // KalenderThemeData cannot be registered on a material_ui ThemeData, so
      // app-wide styling goes through this widget instead.
      body: KalenderTheme(
        data: const KalenderThemeData(
          timeIndicatorStyle: TimeIndicatorStyle(lineColor: Color(0xFFE91E63)),
        ),
        child: KalenderView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: viewConfiguration,
          header: const CalendarHeader(),
          body: const CalendarBody(),
        ),
      ),
    );
  }
}
