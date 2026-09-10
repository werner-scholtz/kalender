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
      // The calendar renders without the bridge, but its own Theme.of lookup
      // falls back to ThemeData.fallback(), so it would not pick up this theme.
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

  late final displayRange = KalenderDateTimeRange(
    start: now.subtract(const Duration(days: 365)),
    end: now.add(const Duration(days: 365)),
  );

  late final viewConfiguration = MultiDayViewConfiguration.week(
    displayRange: displayRange,
    initialTimeOfDay: const KalenderTime(hour: 7, minute: 0),
  );

  @override
  void initState() {
    super.initState();
    final today = DateTime(now.year, now.month, now.day);
    eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: KalenderDateTimeRange(
          start: today.add(const Duration(hours: 9)),
          end: today.add(const Duration(hours: 10, minutes: 30)),
        ),
      ),
      CalendarEvent(
        dateTimeRange: KalenderDateTimeRange(
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
