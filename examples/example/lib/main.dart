import 'package:example/tiles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

/// A custom event that extends [KalenderEvent] with a title and color.
class Event extends KalenderEvent {
  Event({
    super.id,
    required super.start,
    required super.end,
    required this.title,
    this.color,
    super.interaction,
    super.multiDayRule,
  });

  final String title;
  final Color? color;

  // Rebuilds only what this class adds. The id, the interaction config and the
  // rule are restored by KalenderEvent afterwards.
  @override
  Event copyWithData({required DateTime start, required DateTime end}) {
    return Event(start: start, end: end, title: title, color: color);
  }

  @override
  bool operator ==(Object other) => super == other && other is Event && other.title == title && other.color == color;

  @override
  int get hashCode => Object.hash(super.hashCode, title, color);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final eventsController = DefaultEventsController();
  final calendarController = KalenderController();

  final now = DateTime.now();

  late final displayRange = KalenderDateTimeRange(
    start: now.copyWith(day: now.day - 365),
    end: now.copyWith(day: now.day + 365),
  );

  // Without this the day opens at midnight, on hours no one has events in.
  static const initialTimeOfDay = KalenderTime(hour: 7, minute: 0);

  late ViewConfiguration viewConfiguration = viewConfigurations[0];
  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(
      displayRange: displayRange,
      firstDayOfWeek: 1,
      initialTimeOfDay: initialTimeOfDay,
    ),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange, initialTimeOfDay: initialTimeOfDay),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange, initialTimeOfDay: initialTimeOfDay),
    MultiDayViewConfiguration.custom(
      numberOfDays: 3,
      displayRange: displayRange,
      initialTimeOfDay: initialTimeOfDay,
    ),
    MonthViewConfiguration.singleMonth(displayRange: displayRange),
    ScheduleViewConfiguration.continuous(displayRange: displayRange),
  ];

  @override
  void initState() {
    super.initState();

    // Add some sample events to showcase the calendar.
    final today = DateTime(now.year, now.month, now.day);
    eventsController.addEvents([
      Event(
        start: today.add(const Duration(hours: 9)),
        end: today.add(const Duration(hours: 10, minutes: 30)),
        title: 'Team Standup',
        color: Colors.blue,
      ),
      Event(
        start: today.add(const Duration(hours: 13)),
        end: today.add(const Duration(hours: 14)),
        title: 'Lunch Meeting',
        color: Colors.green,
      ),
      Event(
        start: today.add(const Duration(days: 1, hours: 10)),
        end: today.add(const Duration(days: 1, hours: 12)),
        title: 'Workshop',
        color: Colors.orange,
      ),
      Event(
        start: today,
        end: today.add(const Duration(days: 3)),
        title: 'Conference',
        color: Colors.purple,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        callbacks: KalenderCallbacks(
          onEventTapped: (event) => calendarController.selectEvent(event),
          onEventCreate: (event) {
            // Give newly created events a default title.
            return Event(start: event.start, end: event.end, title: 'New Event');
          },
          onEventCreated: (event) => eventsController.addEvent(event),
          onEventChanged: (event, updatedEvent) => eventsController.updateEvent(
            event: event,
            updatedEvent: updatedEvent,
          ),
        ),
        // Style the header with a Material widget.
        header: Material(
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 2,
          child: Column(
            children: [
              _calendarToolbar(),
              const KalenderHeader(multiDayTileComponents: tileComponents),
            ],
          ),
        ),
        body: const KalenderBody(
          multiDayTileComponents: tileComponents,
          monthTileComponents: tileComponents,
          scheduleTileComponents: scheduleTileComponents,
        ),
      ),
    );
  }

  /// Whether the platform supports desktop-style navigation (prev/next page buttons).
  bool get _isDesktop {
    if (kIsWeb) return true;
    final platform = Theme.of(context).platform;
    return platform != TargetPlatform.android && platform != TargetPlatform.iOS;
  }

  Widget _calendarToolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 4,
        children: [
          // Month/year label that navigates to today on tap.
          ValueListenableBuilder(
            valueListenable: calendarController.internalDateTimeRange,
            builder: (context, value, child) {
              if (value == null) return const SizedBox.shrink();
              final localRange = value.forLocation();

              final String month;
              final int year;

              if (viewConfiguration is MonthViewConfiguration) {
                final dominantMonthDate = InternalDateTimeRange.fromDateTimeRange(localRange).dominantMonthDate;
                year = dominantMonthDate.year;
                month = dominantMonthDate.monthNameLocalized();
              } else {
                year = localRange.start.year;
                month = localRange.start.monthNameLocalized();
              }

              return FilledButton.tonal(
                onPressed: () => calendarController.animateToDate(DateTime.now()),
                style: FilledButton.styleFrom(minimumSize: const Size(150, kMinInteractiveDimension)),
                child: Text('$month $year'),
              );
            },
          ),

          if (_isDesktop) ...[
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
          IconButton.filledTonal(
            onPressed: () => calendarController.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
          const Spacer(),
          DropdownMenu(
            dropdownMenuEntries: viewConfigurations.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
            initialSelection: viewConfiguration,
            onSelected: (value) {
              if (value == null) return;
              setState(() => viewConfiguration = value);
            },
          ),
        ],
      ),
    );
  }
}
