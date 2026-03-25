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

/// A custom event that extends [CalendarEvent] with a title and color.
class Event extends CalendarEvent {
  Event({
    required super.dateTimeRange,
    required this.title,
    this.color,
    super.interaction,
  });

  final String title;
  final Color? color;

  @override
  Event copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    Color? color,
  }) {
    final newEvent = Event(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      color: color ?? this.color,
    );
    newEvent.id = id;
    return newEvent;
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
  final calendarController = CalendarController();

  final now = DateTime.now();

  late final displayRange = DateTimeRange(
    start: now.copyWith(day: now.day - 365),
    end: now.copyWith(day: now.day + 365),
  );

  late ViewConfiguration viewConfiguration = viewConfigurations[0];
  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: displayRange),
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
        dateTimeRange: DateTimeRange(
          start: today.add(const Duration(hours: 9)),
          end: today.add(const Duration(hours: 10, minutes: 30)),
        ),
        title: 'Team Standup',
        color: Colors.blue,
      ),
      Event(
        dateTimeRange: DateTimeRange(
          start: today.add(const Duration(hours: 13)),
          end: today.add(const Duration(hours: 14)),
        ),
        title: 'Lunch Meeting',
        color: Colors.green,
      ),
      Event(
        dateTimeRange: DateTimeRange(
          start: today.add(const Duration(days: 1, hours: 10)),
          end: today.add(const Duration(days: 1, hours: 12)),
        ),
        title: 'Workshop',
        color: Colors.orange,
      ),
      Event(
        dateTimeRange: DateTimeRange(
          start: today,
          end: today.add(const Duration(days: 3)),
        ),
        title: 'Conference',
        color: Colors.purple,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
          onEventCreate: (event) {
            // Give newly created events a default title.
            return Event(dateTimeRange: event.dateTimeRange, title: 'New Event');
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

  Color _eventColor(CalendarEvent event) =>
      (event is Event ? event.color : null) ?? Theme.of(context).colorScheme.primaryContainer;

  TileComponents _tileComponents() {
    final radius = BorderRadius.circular(8);
    final scheme = Theme.of(context).colorScheme;

    return TileComponents(
      tileBuilder: (event, tileRange) => Card(
        color: _eventColor(event),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            (event is Event) ? event.title : '',
            style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 12),
          ),
        ),
      ),
      dropTargetTile: (event) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: scheme.onSurface.withAlpha(80), width: 2),
          borderRadius: radius,
        ),
      ),
      feedbackTileBuilder: (event, dropTargetWidgetSize) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: dropTargetWidgetSize.width * 0.8,
        height: dropTargetWidgetSize.height,
        decoration: BoxDecoration(color: _eventColor(event).withAlpha(100), borderRadius: radius),
      ),
      tileWhenDraggingBuilder: (event) => Container(
        decoration: BoxDecoration(color: _eventColor(event).withAlpha(80), borderRadius: radius),
      ),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      verticalResizeHandle: DecoratedBox(
        decoration: BoxDecoration(color: scheme.onPrimaryContainer.withAlpha(150), shape: BoxShape.circle),
      ),
      horizontalResizeHandle: DecoratedBox(
        decoration: BoxDecoration(color: scheme.onPrimaryContainer.withAlpha(150), shape: BoxShape.circle),
      ),
    );
  }

  ScheduleTileComponents _scheduleTileComponents() {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(8);

    return ScheduleTileComponents(
      tileBuilder: (event, tileRange) => Card(
        margin: const EdgeInsets.symmetric(vertical: 1),
        color: _eventColor(event),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text((event is Event) ? event.title : ''),
        ),
      ),
      dropTargetTile: (event) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: scheme.onSurface.withAlpha(80), width: 2),
          borderRadius: radius,
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
