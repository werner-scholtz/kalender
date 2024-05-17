import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );

    final darkTheme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ));

    return MaterialApp(
      title: 'Kalender Example',
      themeMode: ThemeMode.dark,
      theme: theme,
      darkTheme: darkTheme,
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
  final controller = CalendarController();
  final controller1 = CalendarController();
  final eventsController = EventsController();

  late ViewConfiguration _viewConfig = _viewConfigs[0];
  late ViewConfiguration _viewConfig1 = _viewConfigs[1];
  final _viewConfigs = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3)
  ];

  @override
  void initState() {
    super.initState();

    controller.addListener(() {});

    final now = DateTime.now();
    eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(hours: 3)),
        ),
      ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(minutes: 30)),
      //     end: now.add(const Duration(hours: 1)),
      //   ),
      // ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(days: 1)),
      //     end: now.add(const Duration(days: 1, hours: 1)),
      //   ),
      // ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(days: 2)),
      //     end: now.add(const Duration(days: 2, hours: 1)),
      //   ),
      // ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(days: 3)),
      //     end: now.add(const Duration(days: 3, hours: 1)),
      //   ),
      // ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(days: 4)),
      //     end: now.add(const Duration(days: 4, hours: 1)),
      //   ),
      // ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(days: 5)),
      //     end: now.add(const Duration(days: 5, hours: 1)),
      //   ),
      // ),
      // CalendarEvent(
      //   dateTimeRange: DateTimeRange(
      //     start: now.add(const Duration(days: 6)),
      //     end: now.add(const Duration(days: 6, hours: 1)),
      //   ),
      // ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final callbacks = CalendarCallbacks(
      onEventTapped: (event, renderBox) {},
      onEventCreated: (date) => log('Calendar tapped: $date'),
      onPageChanged: (dateTimeRange) => log('Calendar dragged: $dateTimeRange'),
    );

    final multiDayComponents = TileComponents(
      tileBuilder: (event) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dropTargetTile: (event) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      feedbackTileBuilder: (event, dropTargetWidgetSize) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: dropTargetWidgetSize.width * 0.8,
          height: dropTargetWidgetSize.height,
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      tileWhenDraggingBuilder: (event) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dragAnchorStrategy: (draggable, context, position) {
        final renderObject = context.findRenderObject()! as RenderBox;
        return Offset(
          20,
          renderObject.size.height / 2,
        );
      },
      resizeHandle: const ResizeHandle(),
    );

    final calendar = CalendarView(
      calendarController: controller,
      eventsController: eventsController,
      viewConfiguration: _viewConfig,
      header: calendarHeader(
        controller,
        _viewConfig,
        (value) => setState(() => _viewConfig = value),
      ),
      body: MultiDayBody(
        heightPerMinute: ValueNotifier(0.5),
        tileComponents: multiDayComponents,
        callbacks: callbacks,
      ),
    );

    final calendar1 = CalendarView(
      calendarController: controller1,
      eventsController: eventsController,
      viewConfiguration: _viewConfig1,
      header: calendarHeader(
        controller1,
        _viewConfig1,
        (value) => setState(() => _viewConfig1 = value),
      ),
      body: MultiDayBody(
        heightPerMinute: ValueNotifier(0.5),
        tileComponents: multiDayComponents,
        callbacks: callbacks,
      ),
    );

    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 3,
            child: calendar,
          ),
          Flexible(
            flex: 3,
            child: calendar1,
          ),
        ],
      ),
    );
  }

  Widget calendarHeader(
    CalendarController controller,
    ViewConfiguration viewConfiguration,
    void Function(ViewConfiguration value) onSelected,
  ) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: Text(controller.focusedDate.toString()),
              ),
              IconButton.filledTonal(
                onPressed: () async {
                  await controller.animateToPreviousPage();
                },
                icon: const Icon(Icons.navigate_before),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  controller.animateToNextPage();
                },
                icon: const Icon(Icons.navigate_next),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  controller.animateToDate(DateTime.now());
                },
                icon: const Icon(Icons.today),
              ),
              Expanded(
                child: DropdownMenu(
                  dropdownMenuEntries: _viewConfigs
                      .map((e) => DropdownMenuEntry(value: e, label: e.name))
                      .toList(),
                  initialSelection: viewConfiguration,
                  expandedInsets: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == null) return;
                    onSelected(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Event {
  Event({
    required this.title,
    this.description,
    this.color,
  });

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event] tile.
  final Color? color;
}

class ResizeHandle extends StatefulWidget {
  const ResizeHandle({super.key});

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUp,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: hovering ? 1 : 0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color:
                hovering ? Colors.white10.withAlpha(100) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
