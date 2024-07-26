import 'dart:io';

import 'package:example/resize_handle.dart';
import 'package:example/trigger.dart';
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
  final controller = CalendarController();

  final displayRange = DateTimeRange(
    start: DateTime.now().subtractDays(365),
    end: DateTime.now().addDays(365),
  );
  late ViewConfiguration viewConfiguration = viewConfigurations[0];
  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(displayRange: displayRange, firstDayOfWeek: 1),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    MultiDayViewConfiguration.custom(numberOfDays: 3, displayRange: displayRange),
    MonthViewConfiguration.singleMonth(),
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
          data: Event('My Event', Colors.green),
        ),
        CalendarEvent(
          dateTimeRange: DateTimeRange(
            start: now,
            end: now.add(const Duration(hours: 1)),
          ),
          data: Event('My Event', Colors.blue),
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
          calendarController: controller,
          viewConfiguration: viewConfiguration,
          callbacks: CalendarCallbacks(
            onEventTapped: (event, renderBox) => controller.selectEvent(event),
            onEventCreated: (event)=>  eventsController.addEvent(event),
          ),
          header: Material(
            color: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            elevation: 2,
            child: Column(
              children: [
                NavigationHeader(
                  controller: controller,
                  viewConfigurations: viewConfigurations,
                  selected: viewConfiguration,
                  onSelected: (config) => setState(() => viewConfiguration = config),
                ),
                CalendarHeader(multiDayTileComponents: multiDayTileComponents),
              ],
            ),
          ),
          body: CalendarBody(
            multiDayTileComponents: tileComponents,
            monthTileComponents: tileComponents,
            multiDayBodyComponents: const MultiDayBodyComponents(
              leftPageTriggerWidget: TriggerWidget(),
              rightPageTriggerWidget: TriggerWidget(),
            ),
            multiDayBodyConfiguration: MultiDayBodyConfiguration(
              eventLayoutStrategy: sideBySideLayoutStrategy,
            ),
          ),
        ),
      ),
    );
  }

  TileComponents get tileComponents {
    return TileComponents(
      tileBuilder: (event) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('data'),
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
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('data'),
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

class NavigationHeader extends StatelessWidget {
  final CalendarController controller;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration selected;
  final void Function(ViewConfiguration config) onSelected;
  const NavigationHeader({
    required this.controller,
    required this.viewConfigurations,
    required this.onSelected,
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: controller.visibleDateTimeRange,
                  builder: (context, value, child) {
                    final year = value.start.year;
                    final month = value.start.monthNameEnglish;
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(160, kMinInteractiveDimension),
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
              onPressed: () => controller.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => controller.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          IconButton.filledTonal(
            onPressed: () => controller.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
          DropdownMenu(
            dropdownMenuEntries:
                viewConfigurations.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
            initialSelection: selected,
            onSelected: (value) {
              if (value == null) return;
              onSelected(value);
            },
          ),
        ],
      ),
    );
  }
}
