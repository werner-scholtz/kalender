import 'dart:io';

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
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        cardTheme: const CardThemeData(
            margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
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

class Event extends CalendarEvent {
  Event({
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event].
  final Color? color;

  @override
  Event copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    String? description,
    Color? color,
  }) {
    final newEvent = Event(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
    newEvent.id = id;

    return newEvent;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Create [EventsController], this is used to add and remove events.
  final eventsController = DefaultEventsController();

  /// Create [CalendarController],
  final calendarController = CalendarController();

  final now = DateTime.now();

  /// Decide on a range you want to display.
  late final displayRange = DateTimeRange(start: now.subtractDays(363), end: now.addDays(365));

  /// Set the initial view configuration.
  late ViewConfiguration viewConfiguration = viewConfigurations[0];

  /// Create a list of view configurations to choose from.
  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: displayRange),
    MonthViewConfiguration.singleMonth(),
    MultiDayViewConfiguration.freeScroll(displayRange: displayRange, numberOfDays: 4, name: "Free Scroll (WIP)"),
  ];

  @override
  void initState() {
    super.initState();
    eventsController.addEvents(
      [
        Event(
          dateTimeRange: DateTimeRange(start: now, end: now.add(const Duration(hours: 1))),
          title: 'My Event',
          color: Colors.green,
        ),
        Event(
          dateTimeRange: DateTimeRange(start: now, end: now.add(const Duration(hours: 1))),
          title: 'My Event',
          color: Colors.blue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: viewConfiguration,
        // Handle the callbacks made by the calendar.
        callbacks: CalendarCallbacks(
          onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
          onEventCreate: (event) => event,
          onEventCreated: (event) => eventsController.addEvent(event),
          onEventChanged: (event, updatedEvent) => eventsController.updateEvent(
            event: event,
            updatedEvent: updatedEvent,
          ),
        ),
        // Customize the components.
        components: CalendarComponents(
          multiDayComponents: const MultiDayComponents(),
          multiDayComponentStyles: const MultiDayComponentStyles(),
          monthComponents: const MonthComponents(),
          monthComponentStyles: const MonthComponentStyles(),
          scheduleComponents: const ScheduleComponents(),
          scheduleComponentStyles: const ScheduleComponentStyles(),
        ),
        // Style the header with a martial widget.
        header: Material(
          color: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          elevation: 2,
          child: Column(
            children: [
              // Add some useful controls.
              _calendarToolbar(),
              // Ad display the default header.
              CalendarHeader(multiDayTileComponents: tileComponents(body: false)),
            ],
          ),
        ),
        body: CalendarBody(
          multiDayTileComponents: tileComponents(),
          monthTileComponents: tileComponents(body: false),
          scheduleTileComponents: scheduleTileComponents(context),
          multiDayBodyConfiguration: const MultiDayBodyConfiguration(showMultiDayEvents: false),
          monthBodyConfiguration: const MultiDayHeaderConfiguration(),
          scheduleBodyConfiguration: ScheduleBodyConfiguration(),
        ),
      ),
    );
  }

  Color get color => Theme.of(context).colorScheme.primaryContainer;
  BorderRadius get radius => BorderRadius.circular(8);

  TileComponents tileComponents({bool body = true}) {
    return TileComponents(
      tileBuilder: (event, tileRange) {
        return Card(
          color: (event is Event) ? event.color : color,
          child: Text((event is Event) ? event.title : ""),
        );
      },
      dropTargetTile: (event) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
          borderRadius: radius,
        ),
      ),
      feedbackTileBuilder: (event, dropTargetWidgetSize) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: dropTargetWidgetSize.width * 0.8,
        height: dropTargetWidgetSize.height,
        decoration: BoxDecoration(color: color.withAlpha(100), borderRadius: radius),
      ),
      tileWhenDraggingBuilder: (event) => Container(
        decoration: BoxDecoration(color: color.withAlpha(80), borderRadius: radius),
      ),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      verticalResizeHandle: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(150),
          shape: BoxShape.circle,
        ),
      ),
      horizontalResizeHandle: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(150),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  ScheduleTileComponents scheduleTileComponents(BuildContext context) {
    return ScheduleTileComponents(
      tileBuilder: (event, tileRange) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: color,
          child: Text((event is Event) ? event.title : ""),
        );
      },
      dropTargetTile: (event) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
          borderRadius: radius,
        ),
      ),
    );
  }

  Widget _calendarToolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: calendarController.internalDateTimeRange,
                  builder: (context, value, child) {
                    if (value == null) return const SizedBox.shrink();

                    final String month;
                    final int year;

                    if (viewConfiguration is MonthViewConfiguration) {
                      final dominantMonthDate = value.dominantMonthDate;
                      // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
                      // we need to check the second week of the visibleDateTimeRange to determine the month and year.
                      year = dominantMonthDate.year;
                      month = dominantMonthDate.monthNameLocalized();
                    } else {
                      year = value.start.year;
                      month = value.start.monthNameLocalized();
                    }

                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(150, kMinInteractiveDimension),
                      ),
                      child: Text('$month $year'),
                    );
                  },
                ),
              ],
            ),
          ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          IconButton.filledTonal(
            onPressed: () => calendarController.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
          SizedBox(
            width: 120,
            child: DropdownMenu(
              dropdownMenuEntries: viewConfigurations.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
              initialSelection: viewConfiguration,
              onSelected: (value) {
                if (value == null) return;
                setState(() => viewConfiguration = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayEventTile extends StatelessWidget {
  final CalendarEvent event;
  final DateTimeRange tileRange;
  const DayEventTile({super.key, required this.event, required this.tileRange});

  @override
  Widget build(BuildContext context) {
    final calendarEvent = event;

    return GestureDetector(
      onTapUp: (details) {},
      child: Card(
        color: (calendarEvent is Event)
            ? (calendarEvent.color ?? Theme.of(context).colorScheme.primaryContainer)
            : Theme.of(context).colorScheme.primaryContainer,
        child: Text((calendarEvent is Event) ? calendarEvent.title : ""),
      ),
    );
  }
}
