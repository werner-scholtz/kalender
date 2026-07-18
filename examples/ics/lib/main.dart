import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

import 'ics_calendar.dart';
import 'ics_event.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender ICS Example',
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
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
  late final displayRange = DateTimeRange(
    start: DateTime(now.year - 1, now.month, now.day),
    end: DateTime(now.year + 1, now.month, now.day),
  );

  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
    MonthViewConfiguration.singleMonth(displayRange: displayRange),
    ScheduleViewConfiguration.continuous(displayRange: displayRange),
  ];
  late ViewConfiguration viewConfiguration = viewConfigurations.first;

  List<IcsSource> _sources = [];

  /// The window the events controller currently holds expanded events for.
  DateTimeRange? _covered;

  @override
  void initState() {
    super.initState();
    calendarController.internalDateTimeRange.addListener(_onVisibleRangeChanged);
    _loadSample();
  }

  @override
  void dispose() {
    calendarController.internalDateTimeRange.removeListener(_onVisibleRangeChanged);
    eventsController.dispose();
    calendarController.dispose();
    super.dispose();
  }

  Future<void> _loadSample() async {
    final text = await rootBundle.loadString('assets/sample.ics');
    _sources = parseIcs(text);
    // Seed a window around today; the range listener keeps it in sync afterwards.
    _regenerate(_windowAround(DateTimeRange(start: now, end: now)));
  }

  void _onVisibleRangeChanged() {
    final visible = calendarController.internalDateTimeRange.value?.forLocation();
    if (visible == null || _sources.isEmpty) return;
    final covered = _covered;
    if (covered != null && !visible.start.isBefore(covered.start) && !visible.end.isAfter(covered.end)) {
      return; // still inside the materialized window
    }
    _regenerate(_windowAround(visible));
  }

  DateTimeRange _windowAround(DateTimeRange range) => DateTimeRange(
        start: range.start.subtract(const Duration(days: 60)),
        end: range.end.add(const Duration(days: 60)),
      );

  void _regenerate(DateTimeRange window) {
    _covered = window;
    // The controller has no atomic replace, so clear then add.
    eventsController.clearEvents();
    eventsController.addEvents(expandEvents(_sources, window));
  }

  Future<void> _showExport() async {
    final text = exportIcs(_sources);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exported .ics'),
        content: SizedBox(width: 480, child: SingleChildScrollView(child: SelectableText(text))),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.of(context).pop();
            },
            child: const Text('Copy'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _onEventTapped(CalendarEvent event) {
    if (event is! IcsEvent) return;
    calendarController.selectEvent(event);
    final message = event.description == null ? event.title : '${event.title} — ${event.description}';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICS example'),
        actions: [
          IconButton(onPressed: _loadSample, icon: const Icon(Icons.refresh), tooltip: 'Reload sample'),
          IconButton(onPressed: _showExport, icon: const Icon(Icons.download), tooltip: 'Export .ics'),
          const SizedBox(width: 8),
        ],
      ),
      body: CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        callbacks: CalendarCallbacks(onEventTapped: (event, renderBox) => _onEventTapped(event)),
        header: Material(
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    DropdownMenu<ViewConfiguration>(
                      initialSelection: viewConfiguration,
                      dropdownMenuEntries: [
                        for (final config in viewConfigurations) DropdownMenuEntry(value: config, label: config.name),
                      ],
                      onSelected: (value) => setState(() => viewConfiguration = value ?? viewConfiguration),
                    ),
                  ],
                ),
              ),
              CalendarHeader(multiDayTileComponents: _tileComponents()),
            ],
          ),
        ),
        body: CalendarBody(
          multiDayTileComponents: _tileComponents(),
          monthTileComponents: _tileComponents(),
          scheduleTileComponents: _scheduleTileComponents(),
        ),
      ),
    );
  }

  TileComponents _tileComponents() {
    return TileComponents(
      tileBuilder: (event, tileRange) {
        final ics = event as IcsEvent;
        return Card(
          margin: EdgeInsets.zero,
          color: ics.color.withAlpha(220),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(ics.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        );
      },
    );
  }

  ScheduleTileComponents _scheduleTileComponents() {
    return ScheduleTileComponents(
      tileBuilder: (event, tileRange) {
        final ics = event as IcsEvent;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: ics.color.withAlpha(220),
          child: Padding(
              padding: const EdgeInsets.all(8), child: Text(ics.title, style: const TextStyle(color: Colors.white))),
        );
      },
    );
  }
}
