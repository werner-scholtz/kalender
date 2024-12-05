import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/enumerations.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/pages/multi_calendar.dart';
import 'package:web_demo/pages/single_calendar.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/event_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) => context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web Demo',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      home: const MyHomePage(title: 'Kalender Demo'),
    );
  }

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final eventsController = EventsController<Event>();

  final _viewConfigurations = [
    MultiDayViewConfiguration.singleDay(),
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.workWeek(),
    MultiDayViewConfiguration.custom(numberOfDays: 3),
    MonthViewConfiguration.singleMonth(),
  ];

  late final _calendarCallbacks = CalendarCallbacks<Event>(
    onEventTapped: (event, renderBox) => _createOverlay(event, renderBox),
    onEventCreate: (event) => event.copyWith(data: Event(title: 'New Event')),
    onEventCreated: (event) => eventsController.addEvent(event),
  );

  ViewType _type = ViewType.single;

  final _portalController = OverlayPortalController();
  CalendarEvent<Event>? selectedEvent;
  RenderBox? selectedRenderBox;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => eventsController.addEvents(generateEvents(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton.filledTonal(
            onPressed: () => MyApp.of(context)!.toggleTheme(),
            icon: Icon(
              MyApp.of(context)!.themeMode == ThemeMode.dark ? Icons.brightness_2_rounded : Icons.brightness_7_rounded,
            ),
          ),
          DropdownMenu<ViewType>(
            initialSelection: _type,
            dropdownMenuEntries: [
              ...ViewType.values.map((e) => DropdownMenuEntry(value: e, label: e.label)),
            ],
            onSelected: (value) {
              if (value == null) return;
              setState(() => _type = value);
            },
          ),
        ],
      ),
      body: OverlayPortal(
        controller: _portalController,
        overlayChildBuilder: _buildOverlay,
        child: _type == ViewType.single
            ? SingleCalendarView(
                eventsController: eventsController,
                callbacks: _calendarCallbacks,
                viewConfigurations: _viewConfigurations,
              )
            : MultiCalendarView(
                eventsController: eventsController,
                callbacks: _calendarCallbacks,
                viewConfigurations: _viewConfigurations,
              ),
      ),
    );
  }

  void _createOverlay(CalendarEvent<Event> event, RenderBox renderBox) {
    selectedEvent = event;
    selectedRenderBox = renderBox;
    _portalController.show();
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    var position = selectedRenderBox!.localToGlobal(Offset.zero);
    const height = 300.0;
    const width = 300.0;

    final size = MediaQuery.sizeOf(context);

    if (position.dy + height > size.height) {
      position = position.translate(0, size.height - (position.dy + height) - 25);
    } else if (position.dy < 0) {
      position = position.translate(0, -position.dy);
    }

    if (position.dx + width + selectedRenderBox!.size.width > size.width) {
      position = position.translate(-width - 16, 0);
    } else {
      position = position.translate(selectedRenderBox!.size.width, 0);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _portalController.hide,
          ),
        ),
        Positioned(
          top: position.dy,
          left: position.dx,
          child: EventOverlayCard(
            event: selectedEvent!,
            position: position,
            height: height,
            width: width,
            onDismiss: _portalController.hide,
            eventsController: eventsController,
          ),
        ),
      ],
    );
  }
}
