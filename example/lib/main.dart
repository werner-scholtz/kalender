import 'dart:io';

import 'package:example/resize_handle.dart';
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
        cardTheme: const CardTheme(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        cardTheme: const CardTheme(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Create [EventsController], this is used to add and remove events.
  final eventsController = EventsController<Event>();

  /// Create [CalendarController],
  /// This is used to control a calendar view with functions such as:
  /// - [CalendarController.animateToDate]
  /// - [CalendarController.animateToDateTime]
  /// - [CalendarController.animateToEvent]
  ///
  /// It can also be used to listen to changes in the calendar view such as:
  /// - [CalendarController.visibleEvents]
  /// - [CalendarController.selectedEvent]
  /// - [CalendarController.visibleDateTimeRange]
  ///
  final calendarController = CalendarController<Event>();

  final now = DateTime.now();

  /// Decide on a range you want to display.
  late final displayRange = DateTimeRange(start: now.subtractDays(363), end: now.addDays(365));
  late ViewConfiguration viewConfiguration = viewConfigurations[0];
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
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: now, end: now.add(const Duration(hours: 1))),
          data: Event('My Event', Colors.green),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: now, end: now.add(const Duration(hours: 1))),
          data: Event('My Event', Colors.blue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarView<Event>(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: viewConfiguration,
          callbacks: CalendarCallbacks<Event>(
            onEventTapped: (event, renderBox) => calendarController.selectEvent(event),
            onEventCreate: (event) => event,
            onEventCreated: (event) => eventsController.addEvent(event),
          ),
          header: Material(
            color: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            elevation: 2,
            child: Column(
              children: [
                _calendarToolbar(),
                CalendarHeader<Event>(
                  multiDayTileComponents: tileComponents(body: false),
                  multiDayHeaderComponents: const MultiDayHeaderComponents(),
                ),
              ],
            ),
          ),
          body: CalendarBody<Event>(
            multiDayTileComponents: tileComponents(),
            monthTileComponents: tileComponents(),
            multiDayBodyComponents: const MultiDayBodyComponents(),
            multiDayBodyConfiguration: MultiDayBodyConfiguration(
              showMultiDayEvents: false,
            ),
            monthBodyConfiguration: MultiDayHeaderConfiguration(),
          ),
        ),
      ),
    );
  }

  Color get color => Theme.of(context).colorScheme.primaryContainer;
  BorderRadius get radius => BorderRadius.circular(8);

  TileComponents<Event> tileComponents({bool body = true}) {
    return TileComponents<Event>(
      tileBuilder: (event, tileRange) {
        return Card(
          margin: body ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 1),
          color: color,
          child: Text(event.data?.title ?? ""),
        );
      },
      dropTargetTile: _dropTargetTile,
      feedbackTileBuilder: _feedbackTileBuilder,
      tileWhenDraggingBuilder: _tileWhenDraggingBuilder,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  Widget _feedbackTileBuilder(CalendarEvent event, Size dropTargetWidgetSize) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: dropTargetWidgetSize.width * 0.8,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(color: color.withAlpha(100), borderRadius: radius),
    );
  }

  Widget _tileWhenDraggingBuilder(CalendarEvent event) {
    return Container(decoration: BoxDecoration(color: color.withAlpha(80), borderRadius: radius));
  }

  Widget _dropTargetTile(CalendarEvent event) {
    return DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
            borderRadius: radius));
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
                  valueListenable: calendarController.visibleDateTimeRange,
                  builder: (context, value, child) {
                    final year = value.start.year;
                    final month = value.start.monthNameEnglish;
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(minimumSize: const Size(160, kMinInteractiveDimension)),
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

class Event {
  final String title;
  final Color? color;

  Event(this.title, this.color);
}
