import 'dart:io';

import 'package:example/resize_handle.dart';
import 'package:example/trigger.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/kalender_extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender Example',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class Event {
  final String title;
  final Color? color;

  Event(this.title, this.color);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Create [EventsController]
  final eventsController = EventsController();

  /// Create [CalendarController]
  final calendarController = CalendarController();

  late ViewConfiguration viewConfiguration = viewConfigurations[0];
  final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
  ];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    eventsController.addEvents(
      [
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: now,
            end: now.add(const Duration(hours: 1)),
          ),
          data: Event('My Event', Colors.red),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: now,
            end: now.add(const Duration(hours: 1)),
          ),
          data: Event('My Event', Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: viewConfiguration,
          callbacks: CalendarCallbacks(onEventTapped: (event, renderBox) {
            calendarController.eventModification.selectEvent(event);
          }),
          header: _header(),
          body: _body(),
        ),
      ),
    );
  }

  CalendarBody<Object?> _body() {
    return CalendarBody(
      multiDayTileComponents: tileComponents,
      monthTileComponents: tileComponents,
      multiDayBodyComponents: const MultiDayBodyComponents(
        leftPageTriggerWidget: TriggerWidget(),
        rightPageTriggerWidget: TriggerWidget(),
      ),
    );
  }

  Material _header() {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: calendarController.visibleDateTimeRange,
                  builder: (context, value, child) {
                    final year = value.start.year;
                    final month = value.start.monthNameEnglish;

                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        fixedSize: const Size(120, 40),
                      ),
                      child: Text('$month $year'),
                    );
                  },
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
                DropdownMenu(
                  dropdownMenuEntries: viewConfigurations
                      .map((e) => DropdownMenuEntry(value: e, label: e.name))
                      .toList(),
                  initialSelection: viewConfiguration,
                  onSelected: (value) {
                    if (value == null) return;
                    setState(() => viewConfiguration = value);
                  },
                ),
              ],
            ),
          ),
          CalendarHeader(multiDayTileComponents: multiDayTileComponents),
        ],
      ),
    );
  }

  TileComponents get tileComponents {
    return TileComponents(
      tileBuilder: (event) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dropTargetTile: _dropTargetTile,
      feedbackTileBuilder: _feedbackTileBuilder,
      tileWhenDraggingBuilder: _tileWhenDraggingBuilder,
      dragAnchorStrategy: dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  TileComponents get multiDayTileComponents {
    return TileComponents(
      tileBuilder: (event) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dropTargetTile: _dropTargetTile,
      feedbackTileBuilder: _feedbackTileBuilder,
      tileWhenDraggingBuilder: _tileWhenDraggingBuilder,
      dragAnchorStrategy: dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );
  }

  Widget _feedbackTileBuilder(CalendarEvent event, Size dropTargetWidgetSize) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: dropTargetWidgetSize.width * 0.8,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(150),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _tileWhenDraggingBuilder(CalendarEvent event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _dropTargetTile(CalendarEvent event) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Offset dragAnchorStrategy(
    Draggable draggable,
    BuildContext context,
    Offset position,
  ) {
    final renderObject = context.findRenderObject()! as RenderBox;
    return Offset(
      20,
      renderObject.size.height / 2,
    );
  }
}
